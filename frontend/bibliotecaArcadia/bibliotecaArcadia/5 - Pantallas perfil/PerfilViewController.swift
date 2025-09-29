//
//  PerfilViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 8/4/25.
//

import UIKit
import PhotosUI

class PerfilViewController: UIViewController{
    //constraints para ajustar los elementos según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeading2: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing2: NSLayoutConstraint!
    
    //outlets para modificar la imagen, el view de los botones del perfil y el botón de datos de envío
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var viewBotonesPerfil: UIView!
    @IBOutlet weak var botonDatosEnvio: UIButton!
    
    //Labels para el nombre y el correo del usuario
    @IBOutlet weak var labelNombreCompleto: UILabel!
    @IBOutlet weak var labelCorreo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hacer que la imagen de perfil sea redonda
        imagenPerfil.roundCorners(radius: imagenPerfil.frame.height/2)
        
        //añadir estilos a los botones
        viewBotonesPerfil.addShadow()
        viewBotonesPerfil.layer.cornerRadius = 8
        botonDatosEnvio.addShadow()
        
        //Modificar los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading2, constraintTrailing: constraintTrailing2)
        if UIDevice.current.model == "iPad" || UIDevice.current.model == "iPad Simulator" {
            constraintLeading.constant = 52
            constraintTrailing.constant = 52
        } else {
            constraintLeading.constant = 36
            constraintTrailing.constant = 36
        }
    }
    
    //para que los datos que se muestran en la interfaz se actualicen cada vez que vuelva a reaparecer la pantalla, no sólo al cargarse
    override func viewWillAppear(_ animated: Bool) {
        self.cargarDatos() //cargar los datos del usuario guardado en CoreData
    }
    
    //Redigirir a la pantalla que da acceso a los formularios para editar los datos de perfil
    @IBAction func goToEditarPerfil(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let datosPerfil = storyboard.instantiateViewController(withIdentifier: "datosPerfilViewController") as! DatosPerfilViewController
        datosPerfil.title = "Datos de perfil"
        self.navigationController?.pushViewController(datosPerfil, animated: true)
    }
    
    //Redigirir a la pantalla de ajustes de seguridad
    @IBAction func goToCambiarPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let seguridadVC = storyboard.instantiateViewController(withIdentifier: "seguridadViewController") as! SeguridadViewController
        seguridadVC.title = "Ajustes de seguridad"
        self.navigationController?.pushViewController(seguridadVC, animated: true)
    }
    
    //Redigirir a la pantalla para guardar o modificar el domicilio asociado a la cuenta
    @IBAction func goToDatosEnvio(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let envioVC = storyboard.instantiateViewController(withIdentifier: "datosEnvioViewController") as! DatosEnvioViewController
        envioVC.title = "Datos de envío"
        self.navigationController?.pushViewController(envioVC, animated: true)
    }
    
    //Botón para cambiar la foto de perfil
    @IBAction func changeProfilePic(_ sender: Any) {
        self.configurarImagePicker()
    }
    
    //Botón para cerrar sesión
    @IBAction func cerrarSesion(_ sender: Any) {
        self.cerrarSesion()
    }
}

extension PerfilViewController {
    //Mostrar en la interfaz los datos obtenidos del usuario de CoreData
    func cargarDatos(){
        let user = getUserDB()
        if user != nil {
            labelNombreCompleto.text = "\(user!.nombre!) \(user!.apellidos!)"
            labelCorreo.text = user!.email
            if user?.pfp != nil && user?.pfp != "" {
                self.getPhoto()
            } else {
                imagenPerfil.image = UIImage(named: "pfp_placeholder")
            }
        }
    }
    
    //cerrar la sesión del usuario y volver al inicio de la app
    func cerrarSesion(){
        //Hacer la petición a la API para cerrar sesión (borrar el token)
        let urlString = "\(API_URL)/user/logout"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //Como es una url con middleware de autenticación, hay que pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token")!)", forHTTPHeaderField: "Authorization")
        
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
                _ = try jsonDecoder.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    //Eliminar las notificaciones de este usuario de CoreData
                    let arrayNotif = self.getNotifDB() ?? []
                    for i in 0..<arrayNotif.count{
                        self.deleteNotif(notif: arrayNotif[i])
                    }
                    UserDefaults.standard.set(true, forKey: "eliminarBadge")
                    UserDefaults.standard.set(0, forKey: "badgeCount")
                    
                    //Eliminar las búsquedas anteriores de UserDefaults
                    UserDefaults.standard.set([], forKey: "busquedasAnteriores")
                    
                    //ir a la primera pantalla de la app
                    self.cerrarApp()
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //FOTOS
    func configurarImagePicker(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    //Conseguir la foto del storage
    func getPhoto() {
        //Hacer la petición a la API para que devuelva la foto del perfil
        let urlString = "\(API_URL)/user/pfp"
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
        
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    self.imagenPerfil.image = UIImage(data: data) //poner la imagen jpg devuelta en el UIImage
                } else {
                    self.imagenPerfil.image = UIImage(named: "pfp_placeholder")
                }
            }
        }.resume()
    }
    
    //Guardar cambio de foto en la base de datos
    func updateProfilePicture(){
        //Hacer la petición a la API para que guarde la nueva foto del perfil
        let urlString = "\(API_URL)/user/pfp"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //Como se va a mandar un archivo por el formulario, el enctype tiene que ser multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //Pasarle el token del usuario
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //Convertir la imagen en el UIImageView en jpg
        let jpeg = imagenPerfil.image!.jpegData(compressionQuality: 0.5)!
        //Enviar la imagen por el body
        var bodyData = Data()
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"image\"; id=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        bodyData.append(jpeg)
        bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = bodyData
        
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
                let getRes = try jsonDecoder.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    if getRes.success == 1 && getRes.photo != nil{
                        //si la foto se ha guardado, cambiar la imagen en el usuario del CoreData
                        self.updateUserDB(pfp: getRes.photo!)
                    } else if getRes.success == -1 {
                        //mostrar un alert informando de que ha habido un error al subir la foto
                        let alertController = UIAlertController(title: "No se ha podido guardar la imagen", message: "La imagen es demasiado grande o no tiene el formato correcto. Inténtalo de nuevo con una diferente.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Aceptar", style: .default)
                        
                        alertController.addAction(okAction)
                        alertController.view.tintColor = UIColor.accent
                        self.present(alertController, animated: true)
                    } else {
                        print("Code \(getRes.success): \(getRes.message)")
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
                                
        }.resume()
    }
    
    //Guardar cambios de la foto de perfil en la base de datos del dispositivo
    func updateUserDB(pfp: String){
        let userDB = getUserDB()
        guard UIApplication.shared.delegate is AppDelegate else { return }
        
        userDB!.setValue(pfp, forKey: "pfp")
        
        do{
            try userDB!.managedObjectContext?.save()
        } catch let error as NSError {
            print("No se ha podido actualizar la foto de perfil. \(error), \(error.userInfo)")
        }
    }
}

//Configurar el acceso a la galería, usar la foto seleccionada para el perfil y guardarla en las bases de datos
extension PerfilViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider{
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self){ image, error in
                    if let error = error {
                        print(error)
                    }
                    
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            let imagenJpeg = selectedImage.jpegData(compressionQuality: 0.5)!
                            //cambiar la foto de perfil
                            self.imagenPerfil.image = UIImage(data: imagenJpeg)
                            
                            //guardar los cambios en el perfil
                            self.updateProfilePicture()
                        }
                    }
                }
            }
        }
    }
}
