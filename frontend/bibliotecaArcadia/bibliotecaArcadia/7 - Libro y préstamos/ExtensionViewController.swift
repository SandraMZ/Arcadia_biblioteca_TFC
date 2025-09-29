//
//  ExtensionViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 25/4/25.
//

import UIKit

//Protocolo para crear un patrón Delegate que le permita recibir datos desde la pantalla MotivoExtensionModal
protocol MotivoDelegate {
    func recibirMotivo(_ motivo: String)
}

class ExtensionViewController: UIViewController {
    @IBOutlet weak var semanasExtension: UIButton!
    @IBOutlet weak var viewSombra: UIView! //view al que se le va a aplicar sombra
    
    //Constraints cambiar márgenes en iPad
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    var id: String? //id del libro
    var weeks = 1
    var motivo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //cambiar el estilo del view
        viewSombra.layer.cornerRadius = 10
        viewSombra.backgroundColor = .white
        viewSombra.addShadow()
        
        setupButton() //cargar el menú del botón con el número de semanas
        
        //Ajustar los constrainst según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
    
    //Redirigir al formulario para introducir el motivo de la extensión del plazo
    @IBAction func goToFormMotivo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let modal = storyboard.instantiateViewController(withIdentifier: "motivoExtensionModal") as! MotivoExtensionModal
        modal.title = "Motivo de la extensión"
        modal.delegate = self //guardar la instancia como delegado
        modal.mensaje = motivo //por si se vuelve a abrir después de haber escrito el mensaje, que se mantenga y no esté el textView vacío
         self.navigationController?.pushViewController(modal, animated: true)
    }
    
    //Hacer la petición de la extensión
    @IBAction func guardarExtension(_ sender: Any) {
        self.postExtension()
    }
}

extension ExtensionViewController{
    //opciones botón número de semanas
    func setupButton(){
        self.semanasExtension.menu = UIMenu(children: [
                UIAction(title: "1 semana"){ action in
                    self.weeks = 1
                },
                UIAction(title: "2 semanas"){ action in
                    self.weeks = 2
                },
                UIAction(title: "3 semanas"){ action in
                    self.weeks = 3
                }
            ])
        self.semanasExtension.showsMenuAsPrimaryAction = true
    }
    
    //alargar el préstamo
    func postExtension(){
        //Hacer la petición a la API para alargar el préstamo según el id del libro
        let urlString = "\(API_URL)/books/borrow/lengthen_loan/\(self.id!)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //Pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //Pasar por el body los datos de los formularios
        let body = "extension=\(self.weeks)&motivo=\(self.motivo)"
        request.httpBody = body.data(using: .utf8)
        
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
                    if getRes.success == 1{
                        //mostrar una alerta informando al usuario de que se ha procesado la petición correctamente
                        let alertController = UIAlertController(title: "La extensión del préstamo se ha procesado correctamente", message: "", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                            //ir a la pantalla de libro individual
                            self.navigationController?.popViewController(animated: true)
                        }
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
}

//Implementar la función del protocolo
extension ExtensionViewController: MotivoDelegate {
    //Guardar el texto escrito en la pantalla MotivoExtensionModal
    func recibirMotivo(_ motivo: String) {
        self.motivo = motivo
    }
}
