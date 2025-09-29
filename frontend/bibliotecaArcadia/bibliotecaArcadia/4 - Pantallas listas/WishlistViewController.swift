//
//  WishlistViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 17/4/25.
//

import UIKit
import Kingfisher

class WishlistViewController: UIViewController {
    var arrayDeseados: [ResLibro] = []
    var arrayEspera: [ResLibro] = []
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! //para cambiar la lista que se muestra en el TableView
    @IBOutlet weak var labelNoLibros: UILabel! //para cambiar el mensaje del label según la lista seleccionada con el segmentedControl
    @IBOutlet weak var heightLabel: NSLayoutConstraint! //para mostrar u ocultar el mensaje según si el array está vacío
    
    //constraints para ajustar los tamaños según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y DataSource de la tabla
        tableview.delegate = self
        tableview.dataSource = self
        
        //Cambiar el tamaño de los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Cargar las listas
        self.getDeseados()
        self.getEnEspera()
    }
    
    //Cambiar el contenido de la pantalla dependiendo de la opción seleccionada en el segmentedControl
    @IBAction func cambiarTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //contenido de libros deseados
            //Si no hay libros deseados, se muestra el mensaje
            if self.arrayDeseados.count == 0 {
                self.heightLabel.constant = 44
                self.labelNoLibros.text = "No hay libros deseados"
            } else {
                self.heightLabel.constant = 0
            }
            tableview.reloadData()
        case 1: //contenidos de libros de los que se está en la lista de espera
            //Si no se está en ninguna lista de espera, se muestra el mensaje
            if self.arrayEspera.count == 0 {
                self.heightLabel.constant = 44
                self.labelNoLibros.text = "No estás en ninguna lista de espera"
            } else {
                self.heightLabel.constant = 0
            }
            tableview.reloadData()
        default:
            break
        }
    }
}

//Extensión para configurar las listas utilizando UITableView
extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    //Indicar el número de items en la tabla según el array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return self.arrayDeseados.count
        } else {
            return self.arrayEspera.count
        }
    }
    
    //Rellenar los datos de las celdas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaWishlist", for: indexPath) as! Celda2LibrosHorizontalTableViewCell
        
        var item: ResLibro!
        
        //elegir el array del que se van al tomar los datos para la celda
        if segmentedControl.selectedSegmentIndex == 0 {
            item = self.arrayDeseados[indexPath.item]
        } else {
            item = self.arrayEspera[indexPath.item]
        }
        
        cell.titulo.text = item.libro.titulo
        var autoresNombres = ""
        for i in 0..<item.autores.count {
            if i == 0 {
                autoresNombres += item.autores[i].nombre
            } else {
                autoresNombres += ", " + item.autores[i].nombre
            }
        }
        cell.autor.text = autoresNombres
        cell.publicacion.text = formatDate(date: item.libro.publicacion)
        
        if item.libro.imagen != nil && item.libro.imagen != "" {
            let url = URL(string: item.libro.imagen!)!
            cell.portada.kf.setImage(with: url)
        } else {
            cell.portada.image = UIImage(named: "libro_placeholder")
        }
        
        return cell
    }
    
    //ir a la pantalla del libro individual al pulsar la celda según el array
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let libro = storyboard.instantiateViewController(withIdentifier: "libroViewController") as! LibroViewController
        
        if segmentedControl.selectedSegmentIndex == 0 {
            libro.id = self.arrayDeseados[indexPath.item].libro.id
        } else {
            libro.id = self.arrayEspera[indexPath.item].libro.id
        }
        
        self.navigationController?.pushViewController(libro, animated: true)
    }
    
    //Eliminar libro de una las listas al hacer swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar"){ (action, sourceView, completionHandler) in
            if self.segmentedControl.selectedSegmentIndex == 0 {
                //Eliminar de la base de datos
                self.deleteFromDeseados(idLibro: self.arrayDeseados[indexPath.item].libro.id)
                
                //Eliminar del array
                self.arrayDeseados.remove(at: indexPath.item)
                if self.arrayDeseados.count == 0 {
                    self.heightLabel.constant = 44
                    self.labelNoLibros.text = "No hay libros deseados"
                }
            } else {
                //Eliminar de la base de datos
                self.deleteFromListaEspera(idLibro: self.arrayEspera[indexPath.item].libro.id)
                
                //Eliminar del array
                self.arrayEspera.remove(at: indexPath.item)
                if self.arrayEspera.count == 0 {
                    self.heightLabel.constant = 44
                    self.labelNoLibros.text = "No estás en ninguna lista de espera"
                }
            }
            self.tableview.reloadData()
            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(red: 249/255, green: 112/255, blue: 88/255, alpha: 1.0)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}

extension WishlistViewController {
    //lista de libros deseados
    func getDeseados(){
        //Hacer la petición a la API para conseguir la lista de libros deseados
        let urlString = "\(API_URL)/lists/wishlist"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //Como es una url con middleware de autenticación, hay que pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let response = response as? HTTPURLResponse{
                print("CÓDIGO DE RESPUESTA: \(response.statusCode)")
            }
            guard let data = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let libros = try jsonDecoder.decode([ResLibro].self, from: data)
                DispatchQueue.main.async {
                    self.arrayDeseados = libros
                    
                    //si la opción elegida en el segmentedControl es la segunda, se carga la lista con el array devuelto por la api. Si el array devuelto está vacío, se muestra un mensaje
                    if self.segmentedControl.selectedSegmentIndex != 1{
                        self.tableview.reloadData()
                        
                        if self.arrayDeseados.count != 0 {
                            self.heightLabel.constant = 0
                        } else {
                            self.heightLabel.constant = 44
                            self.labelNoLibros.text = "No hay libros deseados"
                        }
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //lista de espera
    func getEnEspera(){
        //Hacer la petición a la API para conseguir la lista de espera
        let urlString = "\(API_URL)/lists/waiting_list"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //Como es una url con middleware de autenticación, hay que pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let response = response as? HTTPURLResponse{
                print("CÓDIGO DE RESPUESTA: \(response.statusCode)")
            }
            guard let data = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let libros = try jsonDecoder.decode([ResLibro].self, from: data)
                DispatchQueue.main.async {
                    self.arrayEspera = libros
                    
                    //si la opción elegida en el segmentedControl es la segunda, se carga la lista con el array devuelto por la api. Si el array devuelto está vacío, se muestra un mensaje
                    if self.segmentedControl.selectedSegmentIndex == 1 {
                        self.tableview.reloadData()
                        
                        if self.arrayEspera.count != 0 {
                            self.heightLabel.constant = 0
                        } else {
                            self.heightLabel.constant = 44
                            self.labelNoLibros.text = "No hay libros en espera"
                        }
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Eliminar de deseados
    func deleteFromDeseados(idLibro: String){
        //Hacer la petición a la API para eliminar un elemento por su id de la lista de deseados
        let urlString = "\(API_URL)/lists/wishlist/\(idLibro)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let response = response as? HTTPURLResponse{
                print("CÓDIGO DE RESPUESTA: \(response.statusCode)")
            }
            guard let data = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let getRes = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    print("Code \(getRes.success): \(getRes.message)")
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Eliminar de la lista de espera
    func deleteFromListaEspera(idLibro: String){
        //Hacer la petición a la API para eliminar un elemento por su id de la lista de espera
        let urlString = "\(API_URL)/lists/waiting_list/\(idLibro)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        //Como es una url con middleware de autenticación, hay que pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let response = response as? HTTPURLResponse{
                print("CÓDIGO DE RESPUESTA: \(response.statusCode)")
            }
            guard let data = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let getRes = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    print("Code \(getRes.success): \(getRes.message)")
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
}
