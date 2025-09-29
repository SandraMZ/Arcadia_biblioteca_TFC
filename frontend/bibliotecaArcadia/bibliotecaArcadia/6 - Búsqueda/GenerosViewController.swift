//
//  GenerosViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 18/4/25.
//

import UIKit

class GenerosViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    
    //constraints para ajustar los elementos según el ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    var generos: [Genero] = []
    var arraySubgeneros: [Subgenero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y DataSource del TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Llenar el array de géneros
        self.getGeneros()
        
        //Modificar los constraints del botón según el ancho de la pantalla
        updateConstraints(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)

        //Añadir estilos al botón de búsqueda
        searchBtn.backgroundColor = .clear
        searchBtn.layer.borderWidth = 1
        searchBtn.roundCorners(radius: 5)
        searchBtn.layer.borderColor = UIColor(red: 165/255, green: 120/255, blue: 101/255, alpha: 1).cgColor
        
    }
    
    //Modificar los constraints al girar la pantalla
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        })
    }
    
    //Botón para redirigir a la pantalla con el campo de búsqueda escrita
    @IBAction func searchBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "searchViewController2") as! BusquedaViewController
        searchVC.title = "Buscar un libro"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension GenerosViewController {
    //Obtener la lista de géneros
    func getGeneros() {
        //Hacer la petición a la API para conseguir todos los géneros
        let urlString = "\(API_URL)/filters/genres"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //Pasarle el token del usuario por el header
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
                let generos = try jsonDecoder.decode([Genero].self, from: data)
                DispatchQueue.main.async {
                    //rellenar el array de géneros y recargar la tabla
                    self.generos = generos
                    self.tableView.reloadData()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Obtener lista de subgéneros
    func getSubgeneros(idGenero: Int) {
        //Hacer la petición a la API para conseguir los subgéneros según la id del género
        let urlString = "\(API_URL)/filters/subgenres/\(idGenero)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //Pasarle el token del usuario por el header
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
                let subgeneros = try jsonDecoder.decode([Subgenero].self, from: data)
                DispatchQueue.main.async {
                    self.arraySubgeneros = subgeneros
                    
                    //Si el array tiene datos, se redirige a otra pantalla que lista todos los subgéneros que corresponden a ese género
                    if self.arraySubgeneros.count > 0 {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let subgenerosVC = storyboard.instantiateViewController(withIdentifier: "subgenerosViewController") as! SubgenerosViewController
                        subgenerosVC.title = "Subgéneros"
                        subgenerosVC.subgeneros = self.arraySubgeneros
                        self.navigationController?.pushViewController(subgenerosVC, animated: true)
                    } else {
                        //Si el array de subgéneros está vacío, se redirige directamente a la pantalla de resultados con todos los libros de ese género
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultadosViewController") as! ResultadosViewController
                        resultsVC.title = "Resultados"
                        resultsVC.idGenero = idGenero
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
}

//TableView para listar todos los géneros devueltos por la API
extension GenerosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaGeneros", for: indexPath) as! CeldaGenerosTableViewCell
        cell.lblGenero.text = generos[indexPath.row].nombre
        cell.imgGenero.image = UIImage(named: generos[indexPath.row].nombre)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Por cada celda/ género, conseguir sus subgéneros (si no tiene, se va a los resultados)
        arraySubgeneros.removeAll()
        self.getSubgeneros(idGenero: generos[indexPath.row].id)
    }
}
