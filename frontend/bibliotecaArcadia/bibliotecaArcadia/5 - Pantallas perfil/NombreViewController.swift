//
//  NombreViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 12/4/25.
//

import UIKit

class NombreViewController: UIViewController {
    var user: UserDB?
    
    //constraints para ajustar el formulario al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //Constraints errores
    @IBOutlet weak var heightNameError: NSLayoutConstraint!
    @IBOutlet weak var heightApellidoError: NSLayoutConstraint!
    @IBOutlet weak var marginNameError: NSLayoutConstraint!
    @IBOutlet weak var marginApellidoError: NSLayoutConstraint!
    
    //scroll
    @IBOutlet weak var scrollView: UIScrollView!
    
    //TextFields
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldApellido: UITextField!
    
    //Labels errores
    @IBOutlet weak var labelNameError: UILabel!
    @IBOutlet weak var labelApellidoError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //rellenar los campos con los datos del usuario guardado
        textFieldName.text = user?.nombre
        textFieldApellido.text = user?.apellidos
        
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
        
        //mover el View al aparecer el teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Cambiar de campo al pulsar intro en el teclado
        self.defineTextFieldsDelegate()
    }
    
    //Quitar los Observers del teclado al desaparecer la vista
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //botón de guardar
    @IBAction func save(_ sender: Any) {
        self.saveChanges()
    }

}

extension NombreViewController {
    //Guardar los cambios en la API
    func saveChanges() {
        //Hacer la petición a la API para guardar el cambio del nombre y/o el apellido
        let urlString = "\(API_URL)/user/name"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //Pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //pasar los datos del formulario por el body
        let bodyData = "nombre=\(textFieldName.text!)&apellidos=\(textFieldApellido.text!)"
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
                        self.saveUserFieldDB(nombre: getUserRes.user!.nombre, apellidos: getUserRes.user!.apellidos)
                        
                        //ir a la pantalla anterior en la navegación
                        self.navigationController?.popViewController(animated: true)
                        
                    } else if getUserRes.success == -1 && getUserRes.validator != nil {
                        //Si la respuesta de la API devuelve errores de validación, mostrarlos en el formulario
                        self.showErrors(true, nombre: getUserRes.validator!.nombre?[0], apellidos: getUserRes.validator!.apellidos?[0])
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
    func saveUserFieldDB(nombre: String, apellidos: String) {
        guard UIApplication.shared.delegate is AppDelegate else { return }
        
        user!.setValue(nombre, forKey: "nombre")
        user!.setValue(apellidos, forKey: "apellidos")
        
        do{
            try user!.managedObjectContext?.save()
        } catch let error as NSError {
            print("No se ha podido actualizar el nombre del usuario. \(error), \(error.userInfo)")
        }
    }
    
    //Cambiar el tamaño de los constraints para mostrar u ocultar los mensajes de error de la validación del formulario
    func showErrors(_ show: Bool, nombre: String? = "", apellidos: String? = "") {
        if show {
            if nombre != nil && nombre != ""{
                heightNameError.constant = 20
                marginNameError.constant = 8
                labelNameError.text = nombre
            } else {
                heightNameError.constant = 0
                marginNameError.constant = 0
            }
            
            if apellidos != nil && apellidos != ""{
                heightApellidoError.constant = 20
                marginApellidoError.constant = 8
                labelApellidoError.text = apellidos
            } else {
                heightApellidoError.constant = 0
                marginApellidoError.constant = 0
            }
        } else {
            heightNameError.constant = 0
            heightApellidoError.constant = 0
            marginNameError.constant = 0
            marginApellidoError.constant = 0
            labelNameError.text = "Error"
            labelApellidoError.text = "Error"
        }
    }
    
    //mover el scrollView al aparecer el teclado virtual
    //Se considera que se está mostrando el teclado virtual en pantalla si ocupa al menos el 10% de esta
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > (UIScreen.main.bounds.height * 0.1){
            if let seleccionado = view.selectedTextField {
                if seleccionado.frame.origin.y + seleccionado.frame.height > UIScreen.main.bounds.size.height - keyboardSize.height - 140 {
                    scrollView.contentOffset = CGPoint(x: 0, y: (seleccionado.frame.origin.y - 40))
                }
            }
        }
    }
    
    //Volver al inicio del ScrollView (si se ha movido) al desaparecer el teclado virtual
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > (UIScreen.main.bounds.height * 0.1){
            if scrollView.contentOffset.y != 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
}

//Delegado de los TextFields
extension NombreViewController: UITextFieldDelegate {
    func defineTextFieldsDelegate(){
        view.textFieldsInView.forEach{ $0.delegate = self }
    }
    
    //Pasar al siguiente TextField al hacer intro
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
