//
//  FechaNacViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 12/4/25.
//

import UIKit

class FechaNacViewController: UIViewController {
    var user: UserDB?
    
    //constraints para ajustar el formulario al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //Constraints errores
    @IBOutlet weak var heightError: NSLayoutConstraint!
    @IBOutlet weak var marginError: NSLayoutConstraint!
    
    //TextFields
    @IBOutlet weak var textfield: UITextField!
    
    //Labels errores
    @IBOutlet weak var labelError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rellenar los campos con los datos del usuario guardado
        if let birthDate = user?.fecha_nac {
            textfield.text = birthDate
        }
        
        //ajustar los constraints del formulario
        self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        self.showErrors(false)
    }
    
    //ajustar los constraints del formulario al girar el dispositivo
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        })
    }

    //Gestión del teclado
    override func viewWillAppear(_ animated: Bool) {
        self.keyboardWhenTappedAround() //cerrar el teclado al pulsar fuera del mismo
    }
    
    //botón de guardar
    @IBAction func save(_ sender: Any) {
        self.saveChanges()
    }
}

extension FechaNacViewController {
    //Guardar los cambios en la API
    func saveChanges() {
        //Hacer la petición a la API para guardar el cambio de la fecha de nacimiento
        let urlString = "\(API_URL)/user/birth_date"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //Como es una url con middleware de autenticación, hay que pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //pasar los datos del formulario por el body
        let bodyData = "fechaNac=\(textfield.text!)"
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
                let getUserRes = try jsonDecoder.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    //Si la respuesta de la API es exitosa
                    if getUserRes.success == 1 && getUserRes.user != nil {
                        //Guardar en CoreData
                        self.saveUserFieldDB(fecha: getUserRes.user!.fecha_nac!)
                        
                        //ir a la pantalla anterior en la navegación
                        self.navigationController?.popViewController(animated: true)
                        
                    } else if getUserRes.success == -1 && getUserRes.validator != nil {
                        //Si la respuesta de la API devuelve errores de validación, mostrarlos en el formulario
                        self.showErrors(true, fechaError: getUserRes.validator!.fechaNac?[0])
                    }
                    else {
                        print("Code \(getUserRes.success): \(getUserRes.message)")
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
                                
        }.resume()
    }
    
    //Modificar en el CoreData los datos que se han cambiado
    func saveUserFieldDB(fecha: String) {
        guard UIApplication.shared.delegate is AppDelegate else { return }
        
        //Formatear la fecha obtenida del formulario para guardarla en CoreData con el mismo formato que el de la base de datos del servidor
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let date = formatter.date(from: fecha)
        
        let dateString = date?.formatted(date: .numeric, time: .omitted)
        user!.setValue(dateString, forKey: "fecha_nac")
        
        do{
            try user!.managedObjectContext?.save()
        } catch let error as NSError {
            print("No se ha podido actualizar el nombre del usuario. \(error), \(error.userInfo)")
        }
    }
    
    //Cambiar el tamaño de los constraints para mostrar u ocultar los mensajes de error de la validación del formulario
    func showErrors(_ show: Bool, fechaError: String? = "") {
        if show {
            if fechaError != nil && fechaError != ""{
                heightError.constant = 20
                marginError.constant = 8
                labelError.text = fechaError
            } else {
                heightError.constant = 0
                marginError.constant = 0
            }
        } else {
            heightError.constant = 0
            marginError.constant = 0
            labelError.text = "Error"
        }
    }
}

