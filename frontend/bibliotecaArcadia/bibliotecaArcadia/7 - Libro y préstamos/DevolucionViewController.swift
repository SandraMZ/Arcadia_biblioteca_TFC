//
//  DevolucionViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 25/4/25.
//

import UIKit
import PhotosUI

class DevolucionViewController: UIViewController {
    @IBOutlet weak var imagenPaquete: UIImageView!
    
    //constraints para mostrar el error
    @IBOutlet weak var heightErrorConstraint: NSLayoutConstraint!
    @IBOutlet weak var marginErrorConstraint: NSLayoutConstraint!
    
    //Constraints cambiar márgenes en iPad
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    var idLibro: String?
    var imagePicker: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController() //instanciar el imagePicker para tomar fotos con la cámara
        //redondear los picos de la imagen
        imagenPaquete.roundCorners()
        imagenPaquete.clipsToBounds = true
        
        //ajustar los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //esconder el mensaje de error al volver a abrir la pantalla
        heightErrorConstraint.constant = 0
        marginErrorConstraint.constant = 0
    }
    
    //Botón para hacer la devolución
    @IBAction func continuarDevolucion(_ sender: Any) {
        //Comprobar si la imagen en el UIImageView no es la imagen de placeholder
        let imagenPaquete: NSData = self.imagenPaquete.image!.pngData()! as NSData
        let imagenPlaceholder: NSData = UIImage(named: "image_placeholder")!.pngData()! as NSData
        
        if imagenPaquete == imagenPlaceholder {
            //mostrar error si es el placeholder
            heightErrorConstraint.constant = 20
            marginErrorConstraint.constant = 8
        } else {
            //hacer la petición a la api si es otra imagen (la hecha con la cámara)
            self.postDevolucion()
        }
    }
    
    //Botón para abrir la cámara
    @IBAction func usarCamara(_ sender: Any) {
        //Ajustes de la cámara
        imagePicker!.delegate = self
        imagePicker!.sourceType = .camera
        imagePicker!.allowsEditing = true
        imagePicker!.showsCameraControls = true
        imagePicker!.cameraCaptureMode = .photo
        imagePicker!.cameraDevice = .rear
        
        present(imagePicker!, animated: true, completion: nil)
    }
}

extension DevolucionViewController {
    func postDevolucion() {
        //hacer la petición de devolver el préstamo según la id del libro
        let urlString = "\(API_URL)/books/borrow/return/\(idLibro!)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //Como se va a mandar un archivo por el formulario, el enctype tiene que ser multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //Pasarle el token del usuario
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //Convertir la imagen en el UIImageView en jpg
        let jpeg = imagenPaquete.image!.jpegData(compressionQuality: 0.5)!
        //Enviar la imagen por el body
        var bodyData = Data()
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"paquete\"; id=\"paquete\"; filename=\"paquete.jpg\"\r\n".data(using: .utf8)!)
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
                let getRes = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    if getRes.success == 1 {
                        //Alert si se procesa correctamente
                        self.mostrarAlert(returnPrev: true, titulo: "La devolución del préstamo se ha procesado correctamente")
                        
                    } else if getRes.success == -1 {
                        //mostrar un alert informando de que ha habido un error al subir la foto
                        self.mostrarAlert(returnPrev: false, titulo: "No se ha podido guardar la imagen", subtitulo: "Ha habido un error al subir la imagen. Inténtelo de nuevo")
                        
                    } else if getRes.success == -4 {
                        //Alert si el préstamo ya ha sido devuelto
                        self.mostrarAlert(returnPrev: true, titulo: "El préstamo ya ha sido devuelto", subtitulo: getRes.message)
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
                                
        }.resume()
    }
    
    //Función para mostrar las alertas
    func mostrarAlert(returnPrev: Bool, titulo: String, subtitulo: String = ""){
        let alertController = UIAlertController(title: titulo, message: subtitulo, preferredStyle: .alert)
        if returnPrev {
            let okAction = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                //volver a la pantalla de libro individual
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
        } else {
            let okAction = UIAlertAction(title: "Aceptar", style: .default)
            alertController.addAction(okAction)
        }
    
        alertController.view.tintColor = UIColor.accent
        self.present(alertController, animated: true)
    }
}

extension DevolucionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //para que se ponga en el UIImageView la foto tomada con la cámara
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker!.dismiss(animated: true)
        let imagenCamara = info[.editedImage] as! UIImage
        let imagenJpeg = imagenCamara.jpegData(compressionQuality: 0.5)!
        imagenPaquete.image = UIImage(data: imagenJpeg)
    }
}
