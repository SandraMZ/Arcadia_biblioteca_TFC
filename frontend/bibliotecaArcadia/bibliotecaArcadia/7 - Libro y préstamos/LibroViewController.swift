//
//  LibroViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 22/4/25.
//

import UIKit

//enum para obtener los idiomas completos a partir de su código
enum Idiomas: String, CaseIterable {
    case es = "Español";
    case en = "Inglés";
    case fr = "Francés";
}

class LibroViewController: UIViewController {
    var user: UserDB?
    var id: String? //id del libro que se recibe de pantallas anteriores y permite hacer la petición
    //Variables que se rellenan al hacer la petición
    var status: Int = 0
    var onWishlist: Int = 0
    var onWaitingList: Int = 0
    var sancionado: Int = 0
    var prestamosSancionados: [String] = []
    var arrayGeneros: [String] = []
    var arrayLibrosAutor: [ResLibro] = []
    var tituloPrestamo: String?
    var autores: String?
    var fotoUrl: String?
    
    //Datos para rellenar con el resultado de la petición
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var editorial: UILabel!
    @IBOutlet weak var fechaPublicacion: UILabel!
    @IBOutlet weak var alertaDisponibles: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var generosCollectionView: UICollectionView!
    @IBOutlet weak var idioma: UILabel!
    @IBOutlet weak var paginas: UILabel!
    @IBOutlet weak var encuadernacion: UILabel!
    @IBOutlet weak var librosAutorCollectionView: UICollectionView!
    
    //Botones
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var verMasButton: UIButton!
    @IBOutlet weak var masLibrosAutorButton: UIButton!
    @IBOutlet weak var addToWishlistButton: UIBarButtonItem!
    
    //Constraints para ocultar el botón principal y el secundario
    @IBOutlet weak var heightPrimaryButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightSecondaryButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var marginPrimaryButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var marginSecondaryButtonConstraint: NSLayoutConstraint!
    
    //Constraints para ocultar ver más cuando no haya más descripción para ver
    @IBOutlet weak var heightVerMasConstraint: NSLayoutConstraint!
    @IBOutlet weak var marginVerMasConstraint: NSLayoutConstraint!
    
    //constraints para ocultar mensaje sobre la disponibilidad de pocos ejemplares
    @IBOutlet weak var heightDisponiblesConstraint: NSLayoutConstraint!
    @IBOutlet weak var marginDisponiblesConstraint: NSLayoutConstraint!
    
    //Constraints para ocultar más libros del autor si no hay otros libros del mismo autor
    @IBOutlet weak var heightLibrosAutorConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightMasLibrosAutorButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var marginMasLibrosAutorButtonConstraint: NSLayoutConstraint!
    
    //Constraints para ajustar la vista al ancho del dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //Cambiar tamaño portada
    @IBOutlet weak var portadaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var portadaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var portadaMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var tituloMarginConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y DataSource de los CollectionViews
        generosCollectionView.delegate = self
        generosCollectionView.dataSource = self
        librosAutorCollectionView.delegate = self
        librosAutorCollectionView.dataSource = self
        
        //hacer que la portada tenga filos redondeados
        portada.roundCorners(radius: 6)
        
        //Cambiar el estilo del botón para ver más de la sinopsis
        verMasButton.roundCorners()
        verMasButton.layer.masksToBounds = false
        verMasButton.addShadow()
        
        //Modificar los constraints del botón según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
        
        if UIDevice.current.model == "iPad" || UIDevice.current.model == "iPad Simulator" {
            portadaHeightConstraint.constant = 320
            portadaWidthConstraint.constant = 224
            portadaMarginConstraint.constant = 24
            tituloMarginConstraint.constant = 12
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = getUserDB()! //obtener el usuario actual
        getLibro() //Cargar los datos del libro
        isSanctioned() //obtener si el usuario está sancionado (la devolución de un libro está fuera de fecha)
    }
    
    //Botón para guardar o eliminar de la lista de deseos
    @IBAction func modifyWishlist(_ sender: Any) {
        if onWishlist == 0 {
            //añadir a la wishlist
            addToWishlist()
            
        } else {
            //eliminar a la wishlist
            removeFromWishlist()
        }
    }
    
    //Botón primario. Sus acciones cambian dependiendo del estado del libro
    @IBAction func primaryButtonActions(_ sender: Any) {
        //Si el estado es 0, el usuario no tiene el libro en préstamo
        if status == 0 {
            //Comprobar si está sancionado o no para continuar con el préstamo
            isSanctioned(prestamo: true)
        } else if status == 1 { //Si el estado es 1, el usuario tiene el libro en préstamo
            //ir a la pantalla de devolver ejemplar
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let devolucionVC = storyboard.instantiateViewController(withIdentifier: "devolucionViewController") as! DevolucionViewController
            devolucionVC.idLibro = id
            devolucionVC.title = "Verificación del envío"
            self.navigationController?.pushViewController(devolucionVC, animated: true)
        }
    }
    
    //Botón secundario. Sus acciones cambian dependiendo del estado del libro
    @IBAction func secondaryButtonActions(_ sender: Any) {
        //el libro no está disponible, acciones de la lista de espera
        if status == 2 {
            //Si el estado es 0, el usuario no está en la lista de espera del libro
            if onWaitingList == 0 {
                //mostrar un alert y añadir a la lista de espera
                showAlert(title: "Recibe un aviso cuando el libro vuelva a estar disponible")
                
            } else { //Si el estado no es 0, el usuario está en la lista de espera del libro
                //mostrar un alert y eliminar de la lista de espera
                showAlert(title: "Ya no recibirás un aviso cuando el libro vuelva a estar disponible", add: false)
            }
        } else {
            //Si el libro sí está disponible
            //Comprobar si el usuario tiene en préstamos el libro
            if status == 1 {
                //Comprobar si la fecha de devolución no se ha pasado (el usuario no está sancionado)
                isSanctioned(prestamo: false, extender: true)
            }
        }
    }
    
    //Botón para expandir o minimizar la sinopsis del libro
    @IBAction func verMasButtonActions(_ sender: Any) {
        if self.descripcion.numberOfLines <= 5 && self.descripcion.numberOfLines != 0 {
            self.descripcion.numberOfLines = 0
            self.verMasButton.setTitle("Ver menos", for: .normal)
        } else {
            self.descripcion.numberOfLines = 5
            self.verMasButton.setTitle("Ver más", for: .normal)
        }
    }
    
    //Botón para redirigir a la pantalla de resultados con la lista de otros libros escritos por el autor del libro
    @IBAction func librosAutorButtonActions(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultadosViewController") as! ResultadosViewController
        resultsVC.title = "Resultados"
        resultsVC.arrayHome = arrayLibrosAutor
        self.navigationController?.pushViewController(resultsVC, animated: true)
    }
}

extension LibroViewController{
    //pedir el libro por su id
    func getLibro(){
        //Hacer la petición a la API para conseguir los datos del libro por su id
        let urlString = "\(API_URL)/books/\(id!)"
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
                let libroData = try jsonDecoder.decode(ResLibroID.self, from: data)
                DispatchQueue.main.async {
                    //Completar la interfaz con los datos recibidos
                    self.rellenarDatos(libroData: libroData)
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //comprobar si el usuario está sancionado
    func isSanctioned(prestamo: Bool = false, extender: Bool = false){
        //Hacer la petición a la API para saber si algún préstamo del usuario se ha pasado de la fecha de devolución
        let urlString = "\(API_URL)/user/sanctioned"
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
                let resSancion = try jsonDecoder.decode(SanctionedResponse.self, from: data)
                DispatchQueue.main.async {
                    //guardar la respuesta en las variables
                    self.sancionado = resSancion.sanctioned
                    self.prestamosSancionados = resSancion.late_loans
                    
                    //Si se está comprobando la sanción al pulsar el botón de préstamo
                    if prestamo{
                        if resSancion.sanctioned == 0{
                            //Si no está sancionado, ir a la pantalla de pedir préstamo
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let prestamoVC = storyboard.instantiateViewController(withIdentifier: "prestamoViewController") as! PrestamoViewController
                            prestamoVC.titulo = self.tituloPrestamo
                            prestamoVC.autores = self.autores
                            prestamoVC.fotoUrl = self.fotoUrl
                            prestamoVC.idLibro = self.id
                            prestamoVC.pantallaLibro = self //pasarle esta instancia para poder recuperarla para navegar hasta aquí tras hacer el préstamo
                            prestamoVC.title = "Datos del envío"
                            self.navigationController?.pushViewController(prestamoVC, animated: true)
                        } else {
                            //Si está sancionado, mostrar una alerta
                            self.showAlert(title: "Usuario sancionado", add:false, message: "No se puede solicitar un préstamo nuevo hasta que se devuelvan los ejemplares fuera de plazo", sanctioned: true)
                        }
                        
                    //Si se está comprobando la sanción al pulsar el botón de extender préstamo
                    } else if extender {
                        if resSancion.sanctioned == 0 || !resSancion.late_loans.contains(self.id!){
                            //Si el usuario no está sancionado o si el libro no corresponde a un préstamo fuera de plazo, ir a la pantalla para alargar préstamo
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let alargarVC = storyboard.instantiateViewController(withIdentifier: "extensionViewController") as! ExtensionViewController
                            alargarVC.id = self.id
                            alargarVC.title = "Alargar préstamo"
                            self.navigationController?.pushViewController(alargarVC, animated: true)
                        } else {
                            //Si está sancionado o fuera de plazo, mostrar una alerta
                            self.showAlert(title: "Usuario sancionado", add:false, message: "No se puede alargar el préstamo, el plazo de devolución ha caducado", sanctioned: true)
                        }
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Añadir a la lista de deseados
    func addToWishlist(){
        //Hacer la petición a la API
        let urlString = "\(API_URL)/lists/wishlist/\(self.id!)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                _ = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    //Cambiar el estilo del botón y la variable en la que se guarda el estado de si está en la lista de deseados
                    self.addToWishlistButton.image = UIImage(systemName: "bookmark.fill")
                    self.onWishlist = 1
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Eliminar de la lista de deseados
    func removeFromWishlist(){
        //Hacer la petición a la API
        let urlString = "\(API_URL)/lists/wishlist/\(self.id!)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
                _ = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    //Cambiar el estilo del botón y la variable en la que se guarda el estado de si está en la lista de deseados
                    self.addToWishlistButton.image = UIImage(systemName: "bookmark")
                    self.onWishlist = 0
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Añadir a la lista de espera
    func addToWaitingList(){
        //Hacer la petición a la API
        let urlString = "\(API_URL)/lists/waiting_list/\(self.id!)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                _ = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    //Cambiar el texto del botón y la variable en la que se guarda el estado de si está en la lista de espera
                    self.secondaryButton.setTitle("Eliminar de la lista de espera", for: .normal)
                    self.onWaitingList = 1
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Eliminar de la lista de espera
    func removeFromWaitingList(){
        //Hacer la petición a la API
        let urlString = "\(API_URL)/lists/waiting_list/\(self.id!)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
                _ = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    //Cambiar el texto del botón y la variable en la que se guarda el estado de si está en la lista de espera
                    self.secondaryButton.setTitle("Avísame cuando esté disponible", for: .normal)
                    self.onWaitingList = 0
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Mostrar alertas para modificar la lista de espera o si el usuario está sancionado
    func showAlert(title: String, add: Bool = true, message: String = "", sanctioned: Bool = false){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if !sanctioned {
            //Mostrar los botones para confirmar la acción de la lista de espera
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            let deleteAction = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                if add {
                    self.addToWaitingList() //añadir a la lista de espera
                } else {
                    self.removeFromWaitingList() //eliminar de la lista de espera
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
        } else {
            let okAction = UIAlertAction(title: "Aceptar", style: .default)
            alertController.addAction(okAction)
        }
        
        alertController.view.tintColor = UIColor.accent
        self.present(alertController, animated: true)
    }
    
    //Rellenar los datos de la interfaz
    func rellenarDatos(libroData: ResLibroID){
        if libroData.book!.imagen != nil && libroData.book!.imagen != "" {
            self.portada.kf.setImage(with: URL(string: libroData.book!.imagen!)!)
            self.fotoUrl = libroData.book!.imagen //variable necesaria para pasar la portada al redirigir a otras pantallas
        } else {
            self.portada.image = UIImage(named: "libro_placeholder")
            self.fotoUrl = "https://i.pinimg.com/736x/99/54/5a/99545a844b83812f334d0708a91f49e7.jpg"
        }
        self.titulo.text = libroData.book!.titulo
        self.tituloPrestamo = libroData.book!.titulo
        
        var autoresNombres = ""
        for i in 0..<libroData.authors!.count {
            if i == 0 {
                autoresNombres += libroData.authors![i].nombre
            } else {
                autoresNombres += ", " + libroData.authors![i].nombre
            }
        }
        self.autor.text = autoresNombres
        self.autores = autoresNombres //variable necesaria para pasar directamente el string de autores al ir a otra pantalla
        
        //Dependiendo del número de autores, cambiar el título del botón
        if libroData.authors!.count > 1 {
            self.masLibrosAutorButton.setTitle("Más libros de los autores", for: .normal)
        } else {
            self.masLibrosAutorButton.setTitle("Más libros del autor", for: .normal)
        }
        
        self.editorial.text = libroData.book!.editorial
        self.fechaPublicacion.text = self.formatDate(date: libroData.book!.publicacion)
        
        //Dependiendo de la disponibilidad del libro, mostrar u ocultar el label y cambiar su mensaje
        if libroData.book!.disponibles <= 0 {
            self.heightDisponiblesConstraint.constant = 20
            self.marginDisponiblesConstraint.constant = 8
            self.alertaDisponibles.text = "No disponible"
        } else if libroData.book!.disponibles <= 5 {
            self.heightDisponiblesConstraint.constant = 20
            self.marginDisponiblesConstraint.constant = 8
            self.alertaDisponibles.text = "Sólo queda(n) \(libroData.book!.disponibles) disponible(s)"
        } else {
            self.heightDisponiblesConstraint.constant = 0
            self.marginDisponiblesConstraint.constant = 0
        }
        
        //añadir los géneros y subgéneros al array de géneros para mostrarlos en el CollectionView
        libroData.genres!.forEach { (genero) in
            if !self.arrayGeneros.contains(genero.nombre) {
                self.arrayGeneros.append(genero.nombre)
            }
        }
        if libroData.subgenres!.count > 0 {
            libroData.subgenres!.forEach { (subgenero) in
                if !self.arrayGeneros.contains(subgenero.nombre) {
                    self.arrayGeneros.append(subgenero.nombre)
                }
            }
        }
        self.generosCollectionView.reloadData()
        
        //Mostrar el idioma en base al case del enum que corresponda con la respuesta de la API
        Idiomas.allCases.forEach { (idioma) in
            let idiomaString: String = "\(idioma)"
            if idiomaString == libroData.book!.idioma {
                self.idioma.text = idioma.rawValue
            }
        }
        
        self.encuadernacion.text = libroData.book!.encuadernacion?.rawValue
        self.paginas.text = "\(libroData.book!.n_paginas) páginas"
        
        self.descripcion.text = libroData.book!.descripcion
        if self.descripcion.numberOfLines < 5 {
            self.heightVerMasConstraint.constant = 0
            self.marginVerMasConstraint.constant = 0
            self.verMasButton.isHidden = true
        }
        
        self.status = libroData.status!
        self.onWishlist = libroData.onWishlist!
        self.onWaitingList = libroData.onWaitingList!
        
        //Cambiar la imagen del botón de wishlist según el estado
        if libroData.onWishlist! == 1 {
            self.addToWishlistButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            self.addToWishlistButton.image = UIImage(systemName: "bookmark")
        }
        
        //Comprobar el estado del libro
        if  libroData.status! == 0 {
            //Si el usuario no tiene el libro en préstamo y el libro no está agotado, mostrar el primer botón y ocultar el segundo
            self.heightPrimaryButtonConstraint.constant = 40
            self.marginPrimaryButtonConstraint.constant = 0
            self.heightSecondaryButtonConstraint.constant = 0
            self.marginSecondaryButtonConstraint.constant = 24
            self.primaryButton.setTitle("Pedir préstamo", for: .normal)
            self.primaryButton.tintColor = .accent
            self.secondaryButton.isHidden = true
            //si el usuario está sancionado, deshabilitar los botones
            if sancionado == 0 {
                self.primaryButton.isEnabled = true
            } else {
                self.primaryButton.isEnabled = false
            }
        } else if libroData.status! == 1 {
            //Si el usuario tiene el libro en préstamo
            if sancionado == 0 || !prestamosSancionados.contains(id!){
                //Si no está sancionado o el libro no pertenece a un préstamo fuera de plazo, mostrar los dos botones: el primario es para devolver el préstamo y el secundario para alargar el plazo
                self.heightPrimaryButtonConstraint.constant = 40
                self.marginPrimaryButtonConstraint.constant = 16
                self.heightSecondaryButtonConstraint.constant = 40
                self.marginSecondaryButtonConstraint.constant = 24
                self.primaryButton.isHidden = false
                self.secondaryButton.isHidden = false
                self.primaryButton.setTitle("Devolver préstamo", for: .normal)
                self.secondaryButton.setTitle("Alargar préstamo", for: .normal)
                self.primaryButton.tintColor = .accent
                
                //comprobar si el libro ya ha sido recibido por el usuario (ya se puede devolver o alargar el préstamo)
                if libroData.received! == 1 {
                    //Si se ha recibido, habilitar los botones
                    self.primaryButton.isEnabled = true
                    self.secondaryButton.isEnabled = true
                } else {
                    //Si no se ha recibido, deshabilitar los botones
                    self.primaryButton.isEnabled = false
                    self.secondaryButton.isEnabled = false
                }
            } else {
                //Si está sancionado, mostrar sólo el botón de devolver préstamo en el color que indica alerta
                self.heightPrimaryButtonConstraint.constant = 40
                self.marginPrimaryButtonConstraint.constant = 0
                self.heightSecondaryButtonConstraint.constant = 0
                self.marginSecondaryButtonConstraint.constant = 24
                self.primaryButton.isHidden = false
                self.secondaryButton.isHidden = true
                self.primaryButton.setTitle("Devolver préstamo", for: .normal)
                self.primaryButton.tintColor = UIColor(red: 249/255, green: 112/255, blue: 88/255, alpha: 1.0)
            }
        } else if libroData.status! == 2 {
            //Si el usuario no tiene el libro en préstamo y el libro está agotado, mostrar sólo el botón secundario para poder unirse a la lista de espera
            self.heightPrimaryButtonConstraint.constant = 0
            self.marginPrimaryButtonConstraint.constant = 0
            self.heightSecondaryButtonConstraint.constant = 40
            self.marginSecondaryButtonConstraint.constant = 24
            self.primaryButton.isHidden = true
            self.secondaryButton.isHidden = false
            
            //Cambiar el título del botón dependiendo de si ya está o no en la lista de espera
            if libroData.onWaitingList! == 1 {
                self.secondaryButton.setTitle("Eliminar de la lista de espera", for: .normal)
            } else {
                self.secondaryButton.setTitle("Avísame cuando esté disponible", for: .normal)
            }
        }
        
        //Cargar el array de otros libros del autor
        self.arrayLibrosAutor = libroData.otherBooks!
        self.librosAutorCollectionView.reloadData()
        
        if self.arrayLibrosAutor.count == 0 {
            //Si el array está vacío, ocultar la sección
            self.heightLibrosAutorConstraint.constant = 0
            self.marginMasLibrosAutorButtonConstraint.constant = 0
            self.masLibrosAutorButton.isHidden = true
            self.heightMasLibrosAutorButtonConstraint.constant = 0
        } else {
            //Si el array no está vacío, mostrar la sección (título, collectionview)
            self.heightLibrosAutorConstraint.constant = 297
            self.marginMasLibrosAutorButtonConstraint.constant = 32
            self.masLibrosAutorButton.isHidden = false
            self.heightMasLibrosAutorButtonConstraint.constant = 37
        }
    }
}

//CollectionViews para listar los géneros y subgéneros del libro y para listar los otros libros publicados por el autor o autores
extension LibroViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.generosCollectionView {
            //Si es el collectionView de los géneros
            return self.arrayGeneros.count
        } else if collectionView == self.librosAutorCollectionView {
            //Si es el collectionView de los otros libros del autor
            return self.arrayLibrosAutor.count
        } else {
            //Para que se cubran todos los casos del return
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.generosCollectionView {
            //Rellenar los datos de las celdas de géneros y subgéneros
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaGeneros", for: indexPath) as! CeldaGenerosCollectionViewCell
            cell.labelGenero.text = self.arrayGeneros[indexPath.item]
            return cell
            
        } else if collectionView == self.librosAutorCollectionView {
            //Rellenar los datos de las celdas de los otros libros del autor
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaLibrosAutor", for: indexPath) as! Celda5LibrosVerticalCollectionViewCell
             let item = self.arrayLibrosAutor[indexPath.item]
             
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
             cell.year.text = formatDate(date: item.libro.publicacion)
             if item.libro.imagen != nil && item.libro.imagen != "" {
                 cell.portada.kf.setImage(with: URL(string: item.libro.imagen!)!)
             } else {
                 cell.portada.image = UIImage(named: "libro_placeholder")
             }
            
            return cell
        }
        
        return UICollectionViewCell() //Para que se cubran todos los casos del return
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Si es el collectionView de los libros, redirigir a la pantalla de información del otro libro al pulsar su celda
        if collectionView == self.librosAutorCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let libro = storyboard.instantiateViewController(withIdentifier: "libroViewController") as! LibroViewController
            libro.id = arrayLibrosAutor[indexPath.item].libro.id
            self.navigationController?.pushViewController(libro, animated: true)
        }
    }
}
