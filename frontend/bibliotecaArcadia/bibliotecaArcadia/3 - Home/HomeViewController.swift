//
//  HomeViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 7/4/25.
//

import UIKit
import CoreData

//Protocolo para hacer un patrón Delegate que permite compartir información desde la pantalla de notificaciones hasta esta
    //Se usa para saber cuándo se han leído las notificaciones y ya no hay que mostrar el badge en la pantalla de inicio
protocol NotifDelegate {
    func eliminarNotif(notiVista: Bool)
}

class HomeViewController: UIViewController {
    var user: UserDB?
    
    //Constraints cambiar márgenes en iPad
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingListas: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailingListas: NSLayoutConstraint!
    
    //estilos botones
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var notifsBtn: UIButton!
    
    //CollectionViews
    @IBOutlet weak var paraTiCV: UICollectionView!
    @IBOutlet weak var wishlistCV: UICollectionView!
    @IBOutlet weak var popularesCV: UICollectionView!
    @IBOutlet weak var ficcionCV: UICollectionView!
    
    //Constraints wishlist para no mostrarlo si está vacío
    @IBOutlet weak var constraintHeightWishlist: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightBtnWishlist: NSLayoutConstraint!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var constraintMarginTopWishlist: NSLayoutConstraint!
    
    //Arrays para los collectionViews
    var arrayParaTi: [ResLibro] = []
    var arrayWishlist: [ResLibro] = []
    var arrayPopulares: [ResLibro] = []
    var arrayFiccion: [ResLibro] = []
    
    //Array notificaciones y conteo de notificaciones nuevas
    var arrayNotif: [NotificacionDB] = []
    var badgeCount: Int = 0
    
    //Badge para el botón de notificaciones
    //Código de https://odenza.medium.com/how-to-add-badge-on-button-swift-c693f9ed12dc
    lazy var badgeLabel: UILabel = {
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
      label.translatesAutoresizingMaskIntoConstraints = false
      label.layer.cornerRadius = label.bounds.size.height / 2
      label.textAlignment = .center
      label.layer.masksToBounds = true
      label.textColor = .white
      label.font = label.font.withSize(12)
      label.backgroundColor = UIColor(red: 249/255, green: 112/255, blue: 88/255, alpha: 1.0)
      return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = self.getUserDB() //obtener los datos del usuario de CoreData
        
        //Delegates y DataSources de los TableViews
        self.paraTiCV.delegate = self
        paraTiCV.dataSource = self
        wishlistCV.delegate = self
        wishlistCV.dataSource = self
        popularesCV.delegate = self
        popularesCV.dataSource = self
        ficcionCV.delegate = self
        ficcionCV.dataSource = self
        
        //estilos del botón de búsqueda
        searchBtn.backgroundColor = .clear
        searchBtn.layer.borderWidth = 1
        searchBtn.layer.cornerRadius = 5
        searchBtn.layer.borderColor = UIColor(red: 165/255, green: 120/255, blue: 101/255, alpha: 1).cgColor
        
        //Cargar las listas
        self.getListRec()
        self.getListPopular()
        self.getListFiction()
        
        //Cambiar el tamaño de los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
        updateConstraintsNoForm(constraintLeading: constraintLeadingListas, constraintTrailing: constraintTrailingListas)
    }
    
    //se carga en viewWillAppear, para que cambien los valores al volver a la pantalla
    override func viewWillAppear(_ animated: Bool) {
        //Cargar la lista de deseados
        self.getWishlist()
        //Cargar la lista de notificaciones y obtener el número de notificaciones nuevas guardado en UserDefaults
        self.getNotifications()
        badgeCount = UserDefaults.standard.integer(forKey: "badgeCount")
    }
    
    //Botón para redirigir a la primera pantalla de búsqueda de libros
    @IBAction func searchBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "searchViewController1") as! GenerosViewController
        searchVC.title = "Búsqueda"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //Botón para redirigir a la primera pantalla de notificaciones
    @IBAction func bellBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificaciones = storyboard.instantiateViewController(withIdentifier: "notifController") as! NotifViewController
        notificaciones.arrayNotif = arrayNotif //pasar el array de notificaciones
        notificaciones.delegate = self //asignarle esta instancia de HomeViewController como delegado a la instancia de NotifViewController que se va a crear
        notificaciones.title = "Notificaciones"
        self.navigationController?.pushViewController(notificaciones, animated: true)
    }
    
    @IBAction func paraTiBtn(_ sender: Any) {
        //Ir a la pantalla de resultados al pulsar el botón que actúa como título para la lista de recomendados
        gotoResults(arrayLibros: arrayParaTi)
    }
    
    @IBAction func wishlistBtn(_ sender: Any) {
        //ir a la pantalla de deseados para ver todos los libros en la wishlist
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    
    @IBAction func popularesBtn(_ sender: Any) {
        //Ir a la pantalla de resultados al pulsar el botón que actúa como título para la lista de más populares
        gotoResults(arrayLibros: arrayPopulares)
    }
    
    @IBAction func ficcionBtn(_ sender: Any) {
        //Ir a la pantalla de resultados al pulsar el botón que actúa como título para la lista de libros de literatura y ficción
        gotoResults(arrayLibros: arrayFiccion)
    }
}

extension HomeViewController {
    //Instanciar y navegar a la pantalla de resultados
    func gotoResults(arrayLibros: [ResLibro]){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultadosViewController") as! ResultadosViewController
        resultsVC.title = "Resultados"
        resultsVC.arrayHome = arrayLibros
        self.navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    //obtener las notificaciones (se hace en esta pantalla para poder poner el badge en el botón que lleva a la pantalla de notificaciones)
    func getNotifications(){
        //Hacer la petición a la API para conseguir la lista de notificaciones
        let urlString = "\(API_URL)/notifs"
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
                let notificaciones = try jsonDecoder.decode([Notificacion].self, from: data)
                DispatchQueue.main.async {
                    self.arrayNotif = self.getNotifDB() ?? [] //obtener el array de notificaciones guardado en CoreData
                    if notificaciones.count > 0 {
                        //Si la API devuelve un array que no está vacío, se calcula la diferencia entre los arrays
                        let diferencia = notificaciones.count - self.arrayNotif.count
                        
                        if diferencia > 0 {
                            //si la diferencia es mayor que 0, se muestra el badge con la diferencia sumada al número de notificaciones anteriores que aún no se han leído (guardado en UserDefaults)
                            self.badgeCount += diferencia
                            if self.badgeCount > 15 {
                                self.badgeCount = 15
                            }
                            self.showBadge(count: self.badgeCount)
                            
                            //guardar en UserDefaults el número del badge e guardar que no se ha leído aún la notificación
                            UserDefaults.standard.set(self.badgeCount, forKey: "badgeCount")
                            UserDefaults.standard.set(false, forKey:"eliminarBadge")
                            
                            //update del array de CoreData para que tenga los mismos valores
                            for i in 0..<self.arrayNotif.count{
                                self.deleteNotif(notif: self.arrayNotif[i])
                            }
                            self.arrayNotif.removeAll()
                            
                            for i in 0..<notificaciones.count{
                                self.guardarNotif(notif: notificaciones[i])
                            }
                            self.arrayNotif = self.getNotifDB()!
                        } else {
                            //si la diferencia es 0, se muestra el badge o no dependiendo de los valores guardados en UserDefaults
                            let eliminadoBadge = UserDefaults.standard.bool(forKey: "eliminarBadge")
                            if eliminadoBadge || self.badgeCount == 0 {
                                self.badgeLabel.isHidden = true
                            } else {
                                if self.badgeCount > 15 {
                                    self.badgeCount = 15
                                    UserDefaults.standard.set(self.badgeCount, forKey: "badgeCount")
                                }
                                self.showBadge(count: self.badgeCount)
                            }
                        }
                    } else {
                        //Si el array de la API está vacío pero el de CoreData no, se eliminan los notificaciones guadradas en CoreData y se reestabecen los valores guardados en UserDefaults
                        if self.arrayNotif.count > 0 {
                            for i in 0..<self.arrayNotif.count{
                                self.deleteNotif(notif: self.arrayNotif[i])
                            }
                            self.arrayNotif.removeAll()
                            
                            UserDefaults.standard.set(true, forKey: "eliminarBadge")
                            UserDefaults.standard.set(0, forKey: "badgeCount")
                            self.badgeLabel.isHidden = true
                        }
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Mostrar el badge
    //Código de https://odenza.medium.com/how-to-add-badge-on-button-swift-c693f9ed12dc
    func showBadge(count: Int) {
      badgeLabel.text = "\(count)"
      badgeLabel.isHidden = false
      notifsBtn.addSubview(badgeLabel)
      let constraints = [
        badgeLabel.leftAnchor.constraint(equalTo: notifsBtn.centerXAnchor, constant: 2),
        badgeLabel.topAnchor.constraint(equalTo: notifsBtn.topAnchor, constant: -2),
        badgeLabel.widthAnchor.constraint(equalToConstant: 16),
        badgeLabel.heightAnchor.constraint(equalToConstant: 16)
      ]
      NSLayoutConstraint.activate(constraints)
    }
    
    //Obtener los datos de la lista de recomendados
    func getListRec(){
        //Hacer la petición a la API para conseguir la lista de libros recomendados
        let urlString = "\(API_URL)/lists/recommended"
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
                    //Guardar la respuesta en el array y recargar la tabla correspondientes
                    self.arrayParaTi = libros
                    self.paraTiCV.reloadData()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Obtener los datos de la lista de más populares
    func getListPopular(){
        //Hacer la petición a la API para conseguir la lista de libros populares (quedan enos de 5 ejemplares disponibles)
        let urlString = "\(API_URL)/lists/popular"
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
                    //Guardar la respuesta en el array y recargar la tabla correspondientes
                    self.arrayPopulares = libros
                    self.popularesCV.reloadData()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Obtener los datos de la wishlist
    func getWishlist(){
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
                    //Guardar la respuesta en el array
                    self.arrayWishlist = libros
                    
                    if self.arrayWishlist.count > 0 {
                        //Si el array no está vacío, se muestran el título y el TableView
                        self.wishlistCV.reloadData()
                        self.wishlistBtn.isHidden = false
                        self.constraintHeightBtnWishlist.constant = 37
                        self.wishlistBtn.frame.size.height = 37
                        self.constraintMarginTopWishlist.constant = 24
                        self.constraintHeightWishlist.constant = 297
                    } else {
                        //Si el array que se recibe esta vacío, se ocultan el título y la tabla
                        self.wishlistCV.reloadData()
                        self.constraintHeightBtnWishlist.constant = 0
                        self.wishlistBtn.frame.size.height = 0
                        self.wishlistBtn.isHidden = true
                        self.constraintMarginTopWishlist.constant = 0
                        self.constraintHeightWishlist.constant = 0
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Obtener los datos de la lista de ficción y literatura
    func getListFiction(){
        //Hacer la petición a la API para conseguir la lista de libros de ficció
        let urlString = "\(API_URL)/lists/fiction_books"
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
                    //Guardar la respuesta en el array y recargar la tabla correspondientes
                    self.arrayFiccion = libros
                    self.ficcionCV.reloadData()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Ir a la pantalla de libro individual
    func goToBook(arrayItem: ResLibro){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let libro = storyboard.instantiateViewController(withIdentifier: "libroViewController") as! LibroViewController
        libro.id = arrayItem.libro.id
        self.navigationController?.pushViewController(libro, animated: true)
    }
}

//Extensión para conformar el protocolo para el Delegate
extension HomeViewController: NotifDelegate {
    func eliminarNotif(notiVista: Bool) {
        //Como notiVista siempre va a ser true, se guarda ese valor en "eliminarBagde" y el conteo de notificaciones sin leer vuelve a 0
        UserDefaults.standard.set(notiVista, forKey: "eliminarBadge")
        UserDefaults.standard.set(0, forKey: "badgeCount")
    }
}

//Extensión para configurar las listas utilizando UITableView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //Indicar el número de items en la tabla según el array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.paraTiCV {
            //Lista de recomendados
            if self.arrayParaTi.count > 10 {
                return 10
            } else {
                return self.arrayParaTi.count
            }
        } else if collectionView == self.wishlistCV {
            //Wishlist
            if self.arrayWishlist.count > 10 {
                return 10
            } else {
                return self.arrayWishlist.count
            }
        } else if collectionView == self.popularesCV {
            //Lista de libros populares
            if self.arrayPopulares.count > 10 {
                return 10
            } else {
                return self.arrayPopulares.count
            }
        } else if collectionView == self.ficcionCV {
            //Lista de libros de ficción
            if self.arrayFiccion.count > 10 {
                return 10
            } else {
                return self.arrayFiccion.count
            }
        } else {
            //Para que se cubran todos los casos del return
            return 0
        }
    }
    
    //Rellenar los datos de las celdas en la tabla según el array
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Lista de recomendados
        if collectionView == self.paraTiCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda1LibroVertical", for: indexPath) as! CeldaLibrosVerticalCollectionViewCell
            let item =  self.arrayParaTi[indexPath.item]
            
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
            
        //Wishlist
        } else if collectionView == self.wishlistCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda2LibroVertical", for: indexPath) as! Celda2LibrosVerticalCollectionViewCell
            let item = self.arrayWishlist[indexPath.item]
            
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
            
        //Lista de libros populares
        } else if collectionView == self.popularesCV {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda3LibroVertical", for: indexPath) as! Celda3LibrosVerticalCollectionViewCell
            let item = self.arrayPopulares[indexPath.item]
            
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
            
        //Lista de libros de ficción
        } else if collectionView == self.ficcionCV {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda4LibroVertical", for: indexPath) as! Celda4LibrosVerticalCollectionViewCell
            let item = self.arrayFiccion[indexPath.item]
            
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
    
    //ir a la pantalla del libro individual al pulsar la celda según el array
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.paraTiCV { //lista de recomendados
            self.goToBook(arrayItem: arrayParaTi[indexPath.item])
        } else if collectionView == self.wishlistCV { //wishlist
            self.goToBook(arrayItem: arrayWishlist[indexPath.item])
        } else if collectionView == self.popularesCV { //lista de libros populares
            self.goToBook(arrayItem: arrayPopulares[indexPath.item])
        } else if collectionView == self.ficcionCV { //Lista de libros de ficción
            self.goToBook(arrayItem: arrayFiccion[indexPath.item])
        }
    }
}
