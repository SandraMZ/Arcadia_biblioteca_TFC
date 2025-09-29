//
//  ResumenViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 25/4/25.
//

import UIKit

class ResumenViewController: UIViewController {
    //variables para obtener la información pasada desde la pantalla del formulario del préstamo
    var nombre: String?
    var apellidos: String?
    var dni: String?
    var email: String?
    var telefono: String?
    var direccion: String?
    var piso: String?
    var puerta: String?
    var provincia: String?
    var localidad: String?
    var codigoPostal: String?
    var titulo: String?
    var autores: String?
    var fotoUrl: String?
    var idLibro: String?
    var pantallaLibro: LibroViewController?
    
    //vista a la que se le van a aplicar las sombras
    @IBOutlet weak var viewShadow: UIView!
    
    //outlets
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var autoresLabel: UILabel!
    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var calleLabel: UILabel!
    @IBOutlet weak var plantaPisoLabel: UILabel!
    @IBOutlet weak var codPostalLabel: UILabel!
    @IBOutlet weak var localidadLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var telfLabel: UILabel!
    
    //constraints para campos opcionales
    @IBOutlet weak var marginPlanta: NSLayoutConstraint!
    @IBOutlet weak var marginTelf: NSLayoutConstraint!
    
    //Constraints cambiar márgenes en iPad
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingBtn: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailingBtn: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //mostrar los datos
        self.tituloLabel.text = self.titulo
        self.autoresLabel.text = self.autores
        self.portada.kf.setImage(with: URL(string: self.fotoUrl!)!)
        self.calleLabel.text = self.direccion
        
        if piso != "" && puerta != "" {
            self.marginPlanta.constant = 8
            self.plantaPisoLabel.text = self.piso! + " " + self.puerta!
        } else if piso != "" {
            self.marginPlanta.constant = 8
            self.plantaPisoLabel.text = self.piso!
        } else if puerta != "" {
            self.marginPlanta.constant = 8
            self.plantaPisoLabel.text = self.puerta!
        } else {
            self.plantaPisoLabel.text = ""
            self.plantaPisoLabel.isHidden = true
            self.marginPlanta.constant = 0
        }
        
        self.codPostalLabel.text = self.codigoPostal
        self.localidadLabel.text = self.localidad! + ", " + self.provincia!
        
        self.nombreLabel.text = self.nombre
        self.correoLabel.text = self.email
        if self.telefono != nil {
            self.telfLabel.text = self.telefono
        } else{
            self.telfLabel.text = ""
            self.telfLabel.isHidden = true
            self.marginTelf.constant = 0
        }
        
        //ambiar estilos
        portada.roundCorners(radius: 6)
        viewShadow.layer.cornerRadius = 10
        viewShadow.addShadow()
        
        //Cambiar los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
        updateConstraintsNoForm(constraintLeading: constraintLeadingBtn, constraintTrailing: constraintTrailingBtn)
    }
    
    //Botón para finalizar el préstamo
    @IBAction func pedirPrestamo(_ sender: Any) {
        postPrestamo()
    }
    
    //enviar el formulario
    func postPrestamo() {
        //Hacer la petición a la API para guardar el préstamo de un libro por su id
        let urlString = "\(API_URL)/books/borrow/\(self.idLibro!)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //Pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //pasarle los datos del formulario de la pantalla anterior por el body
        let bodyData = "direccion=\(direccion!)&piso=\(piso ?? "")&puerta=\(puerta ?? "")&provincia=\(provincia!)&localidad=\(localidad!)&cod_postal=\(codigoPostal!)&email=\(email!)&telf=\(telefono ?? "")&nombre=\(nombre!)&apellidos=\(apellidos!)&dni=\(dni!)"
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
                let getPrestamoRes = try jsonDecoder.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    if getPrestamoRes.success == 1 {
                        //mostrar una alerta informando al usuario de que se ha realizado el préstamo
                        self.showAlert(title: "El préstamo se ha procesado correctamente", message: "Pronto recibirás un correo con los detalles y el estado del envío")
                    } else {
                        //mostrar una alerta informando al usuario de que ha ocurrido un error
                        self.showAlert(title: "Error al procesar el préstamo", message: getPrestamoRes.message)
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
                                
        }.resume()
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            //volver a la pantalla del libro individual
            self.pantallaLibro!.id = self.idLibro!
            self.navigationController?.popToViewController(self.pantallaLibro!, animated: true)
        }
        alertController.addAction(okAction)
        alertController.view.tintColor = UIColor.accent
        self.present(alertController, animated: true)
    }
}
