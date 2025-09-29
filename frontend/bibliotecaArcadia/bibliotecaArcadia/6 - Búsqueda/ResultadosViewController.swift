//
//  ResultadosViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 18/4/25.
//

import UIKit

//Protocolo para crear un patrón Delegate para recibir información desde la pantalla de filtros
protocol FiltrosDelegate {
    func recibirFiltros(reciente: Int, fecha: String, idioma: String)
}

class ResultadosViewController: UIViewController {
    //variables para recibir info de las pantallas de géneros y subgéneros
    var idGenero: Int?
    var idSubgenero: Int?
    var busqueda: String? //variable para recibir la búsqueda
    var arrayHome: [ResLibro] = [] //Variable para recibir los arrays de la pantalla de inicio
    var arrayLibros: [ResLibro] = [] //Variable para cargar el array de resultados
    var arrayLibrosFiltrados: [ResLibro] = [] //Variable para filtrar el array de resultados
    
    //valores a enviar de vuelta al filtro
    var reciente: Int = 0
    var fecha: String = ""
    var idioma: String = ""
    
    @IBOutlet weak var tableview: UITableView!
    
    //constraints para ajustar los elementos según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //constraint para mostrar u ocultar el label para cuando no hay resultados
    @IBOutlet weak var constraintLabel: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y DataSource del TableView
        tableview.delegate = self
        tableview.dataSource = self

        if idGenero != nil {
            //Si se recibe un género, cargar el array de resultados con los libros de ese género
            getLibrosPorGenero()
        } else if idSubgenero != nil {
            //Si se recibe un subgénero, cargar el array de resultados con los libros de ese subgénero
            getLibrosPorSubgenero()
        } else if busqueda != nil {
            //Si se recibe una búsqueda, cargar el array de resultados con los libros que coincidan
            getLibrosPorBusqueda()
        } else if arrayHome.count > 0 {
            //Si se recibe un array de la pantalla de inicio, cargar el array de libros con ese array
            arrayLibros = arrayHome
            arrayLibrosFiltrados = arrayLibros
            tableview.reloadData()
        }
        
        //Si el array está vacío, mostrar el mensaje. Si está lleno, ocultar el label
        if arrayLibros.count == 0 {
            constraintLabel.constant = 44
        } else {
            constraintLabel.constant = 0
        }
        
        //Modificar los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
    
    //Botón para redirigir a la pantalla de filtros
    @IBAction func filtros(_ sender: Any) {
        //Cuando se redirige a la pantalla de filtros, antes se hace la petición a la API desde esta pantalla para obtener la lista de años de publicación. Esto se hace para evitar que ese filtro "parpadee" al cambiar la opción default por la pasada desde esta pantalla, ya que ese efecto es a causa de cargar sus datos de forma asíncrona a través de la petición a la API desde la pantalla de filtros
        self.getDates()
    }
}

extension ResultadosViewController {
    //petición libros por género
    func getLibrosPorGenero() {
        //Hacer la petición a la API para obtener todos los libros pertenecientes a un género por su id
        let urlString = "\(API_URL)/filters/books_by_genre/\(idGenero!)"
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
                let libros = try jsonDecoder.decode([ResLibro].self, from: data)
                DispatchQueue.main.async {
                    //cargar los arrays de resultados con los datos obtenidos
                    self.arrayLibros = libros
                    self.arrayLibrosFiltrados = libros
                    
                    if self.arrayLibros.count == 0 {
                        self.constraintLabel.constant = 44
                    } else {
                        self.constraintLabel.constant = 0
                    }
                    
                    self.tableview.reloadData()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //petición libros por subgénero
    func getLibrosPorSubgenero() {
        //Hacer la petición a la API para obtener todos los libros pertenecientes a un subgénero por su id
        let urlString = "\(API_URL)/filters/books_by_subgenre/\(idSubgenero!)"
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
                let libros = try jsonDecoder.decode([ResLibro].self, from: data)
                DispatchQueue.main.async {
                    //cargar los arrays de resultados con los datos obtenidos
                    self.arrayLibros = libros
                    self.arrayLibrosFiltrados = libros
                    
                    if self.arrayLibros.count == 0 {
                        self.constraintLabel.constant = 44
                    } else {
                        self.constraintLabel.constant = 0
                    }
                    
                    self.tableview.reloadData()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //petición libros por búsqueda
    func getLibrosPorBusqueda() {
        //Hacer la petición a la API para hacer una búsqueda
        let urlString = "\(API_URL)/filters/search"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //Pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //pasar la búsqueda hecha por el body
        let bodyData = "search=\(self.busqueda!)"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
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
                    //cargar los arrays de resultados con los datos obtenidos
                    self.arrayLibros = libros
                    self.arrayLibrosFiltrados = libros
                    
                    if self.arrayLibros.count == 0 {
                        self.constraintLabel.constant = 44
                    } else {
                        self.constraintLabel.constant = 0
                    }
                    
                    self.tableview.reloadData()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Lista de fechas que se le pasan al filtro de fecha de publicación
    func getDates(){
        //Hacer la petición a la API para conseguir todos los años de publicación
        let urlString = "\(API_URL)/filters/publishing_year"
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
                let fechas = try jsonDecoder.decode([String].self, from: data)
                DispatchQueue.main.async {
                    //Redirigir a la pantalla de filtros
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let filtersVC = storyboard.instantiateViewController(withIdentifier: "filtrosViewController") as! FiltrosViewController
                    filtersVC.title = "Filtros"
                    filtersVC.delegate = self
                    filtersVC.ordenarCode = self.reciente
                    filtersVC.fecha = self.fecha
                    filtersVC.fechas = ["Ninguna"] + fechas //pasarle el array de años de publicación
                    filtersVC.idiomaString = self.idioma
                    self.navigationController?.pushViewController(filtersVC, animated: true)
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //pasar fecha en string a Date
    func stringToDate(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return formatter.date(from: date)
    }
}

//Implementar el protocolo del Delegate
extension ResultadosViewController: FiltrosDelegate {
    //Cuando se llama a esta función, se filtran los elementos del array por los datos recibidos de la pantalla de filtros
    func recibirFiltros(reciente: Int, fecha: String, idioma: String) {
        arrayLibrosFiltrados = arrayLibros
        self.reciente = reciente
        self.fecha = fecha
        self.idioma = idioma
        
        //Ordenar el array por las fechas de publicación
        if reciente == 1 {
            //De más reciente a menos
            arrayLibrosFiltrados.sort { (libro1, libro2) -> Bool in
                let libro1fecha = stringToDate(date: libro1.libro.publicacion)!
                let libro2fecha = stringToDate(date: libro2.libro.publicacion)!
                
                if libro1fecha > libro2fecha {
                    return true
                } else {
                    return false
                }
            }
        } else if reciente == 2 {
            //De menos reciente a más
            arrayLibrosFiltrados.sort { (libro1, libro2) -> Bool in
                let libro1fecha = stringToDate(date: libro1.libro.publicacion)!
                let libro2fecha = stringToDate(date: libro2.libro.publicacion)!
                
                if libro1fecha < libro2fecha {
                    return true
                } else {
                    return false
                }
            }
        }
        
        //Filtrar por año de publicación
        if fecha != "" {
            arrayLibrosFiltrados = arrayLibrosFiltrados.filter { $0.libro.publicacion.hasPrefix(fecha)}
        }
        
        //Filtrar por idioma
        if idioma != "" {
            arrayLibrosFiltrados = arrayLibrosFiltrados.filter { $0.libro.idioma == idioma}
        }
        
        //Si tras el filtrado el array está vacío, mostrar el mensaje. Si está lleno, ocultar el label
        if self.arrayLibrosFiltrados.count == 0 {
            self.constraintLabel.constant = 44
        } else {
            self.constraintLabel.constant = 0
        }
        
        tableview.reloadData()
    }
}

//TableView para mostrar los resultados de las búsquedas
extension ResultadosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLibrosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaResultados", for: indexPath) as! CeldaResultadosTableViewCell
        let item = self.arrayLibrosFiltrados[indexPath.item]
        
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
            cell.portada.kf.setImage(with: URL(string: item.libro.imagen!)!)
        } else {
            cell.portada.image = UIImage(named: "libro_placeholder")
        }
        
        return cell
    }
    
    //Al elegir una celda, redirigir a la pantalla de información del libro
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let libro = storyboard.instantiateViewController(withIdentifier: "libroViewController") as! LibroViewController
        libro.id = self.arrayLibrosFiltrados[indexPath.item].libro.id
        self.navigationController?.pushViewController(libro, animated: true)
    }
}
