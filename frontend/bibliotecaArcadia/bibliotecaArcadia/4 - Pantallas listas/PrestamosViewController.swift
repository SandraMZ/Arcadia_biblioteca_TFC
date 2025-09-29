//
//  PrestamosViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 17/4/25.
//

import UIKit
import Kingfisher

class PrestamosViewController: UIViewController {
    var arrayActuales: [ResLibro] = []
    var arrayAnteriores: [ResLibro] = []
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! //para cambiar la lista que se muestra en el TableView
    @IBOutlet weak var labelPrestamos: UILabel! //para cambiar el mensaje del label según la lista seleccionada con el segmentedControl
    @IBOutlet weak var heightLabel: NSLayoutConstraint! //para mostrar u ocultar el mensaje según si el array está vacío
    
    //constraints para ajustar los tamaños según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y DataSource de la tabla
        tableview.delegate = self
        tableview.dataSource = self
        
        //Cambiar el tamaño de los constraints según el dispositivo/
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Cargar las listas
        self.getActuales()
        self.getAnteriores()
    }

    //Cambiar el contenido de la pantalla dependiendo de la opción seleccionada en el segmentedControl
    @IBAction func cambiarTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //contenido de préstamos activos
            //Si no hay préstamos activos, se muestra el mensaje
            if self.arrayActuales.count == 0 {
                self.heightLabel.constant = 44
                self.labelPrestamos.text = "No hay préstamos activos"
            } else {
                self.heightLabel.constant = 0
            }
            tableview.reloadData()
        case 1: //contenidos de préstamos anteriores
            //Si no hay préstamos anteriores, se muestra el mensaje
            if self.arrayAnteriores.count == 0 {
                self.heightLabel.constant = 44
                self.labelPrestamos.text = "No hay préstamos anteriores"
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
extension PrestamosViewController: UITableViewDelegate, UITableViewDataSource {
    //Indicar el número de items en la tabla según el array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return self.arrayActuales.count
        } else {
            return self.arrayAnteriores.count
        }
    }
    
    //Rellenar los datos de las celdas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaPrestamos", for: indexPath) as! CeldaLibrosHorizontalTableViewCell
        
        var item: ResLibro!
        
        //elegir el array del que se van al tomar los datos para la celda
        if segmentedControl.selectedSegmentIndex == 0 {
            item = self.arrayActuales[indexPath.item]
        } else {
            item = self.arrayAnteriores[indexPath.item]
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
        if item.devolucion != nil && item.devolucion != ""{
            cell.devolucion.text = formatDate(date: item.devolucion!)
        } else {
            cell.devolucion.text = "En envío"
            cell.devolucion.textColor = UIColor(red: 149/255, green: 149/255, blue: 150/255, alpha: 1.0)
        }
        
        if item.cod_pedido != nil {
            cell.codPedido.text = "Pedido: \(item.cod_pedido!)"
        } else {
            cell.codPedido.text = ""
        }
        
        //Si se está mostrando la lista de préstamos actuales, la fecha de devolución se muestra de color rojo si es anterior a la fecha actual
        if segmentedControl.selectedSegmentIndex == 0 {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es_ES")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            if item.devolucion != nil && item.devolucion != ""{
                let date = formatter.date(from: item.devolucion!)
                
                if date! < Date() {
                    cell.devolucion.textColor = UIColor(red: 249/255, green: 112/255, blue: 88/255, alpha: 1.0)
                } else {
                    cell.devolucion.textColor = UIColor(red: 149/255, green: 149/255, blue: 150/255, alpha: 1.0)
                }
            }
        } else {
            cell.devolucion.textColor = UIColor(red: 149/255, green: 149/255, blue: 150/255, alpha: 1.0)
        }
        
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
            libro.id = self.arrayActuales[indexPath.item].libro.id
        } else {
            libro.id = self.arrayAnteriores[indexPath.item].libro.id
        }
        
        self.navigationController?.pushViewController(libro, animated: true)
    }
}

extension PrestamosViewController {
    //préstamos activos actualmente
    func getActuales(){
        //Hacer la petición a la API para conseguir la lista de préstamos activos
        let urlString = "\(API_URL)/books/borrow/current"
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
                    self.arrayActuales = libros
                    
                    //si la opción elegida en el segmentedControl es la segunda, se carga la lista con el array devuelto por la api. Si el array devuelto está vacío, se muestra un mensaje
                    if self.segmentedControl.selectedSegmentIndex != 1 {
                        self.tableview.reloadData()
                        
                        if self.arrayActuales.count == 0 {
                            self.heightLabel.constant = 44
                            self.labelPrestamos.text = "No hay préstamos activos"
                        } else {
                            self.heightLabel.constant = 0
                        }
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //préstamos que ya se han devuelto
    func getAnteriores(){
        //Hacer la petición a la API para conseguir la lista de préstamos anteriores
        let urlString = "\(API_URL)/books/borrow/returned"
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
                    self.arrayAnteriores = libros
                    
                    //si la opción elegida en el segmentedControl es la segunda, se carga la lista con el array devuelto por la api. Si el array devuelto está vacío, se muestra un mensaje
                    if self.segmentedControl.selectedSegmentIndex == 1 {
                        self.tableview.reloadData()
                        
                        if self.arrayAnteriores.count == 0 {
                            self.heightLabel.constant = 44
                            self.labelPrestamos.text = "No hay préstamos anteriores"
                        } else {
                            self.heightLabel.constant = 0
                        }
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
}
