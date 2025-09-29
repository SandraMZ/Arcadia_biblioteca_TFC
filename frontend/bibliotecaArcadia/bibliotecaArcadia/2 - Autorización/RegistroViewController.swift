//
//  RegistroViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 7/4/25.
//

import UIKit

class RegistroViewController: UIViewController {
    //constraints para ajustar el formulario al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //constraints para los mensajes de error
    @IBOutlet weak var heightErrorNombre: NSLayoutConstraint!
    @IBOutlet weak var marginErrorNombre: NSLayoutConstraint!
    @IBOutlet weak var heightErrorApellidos: NSLayoutConstraint!
    @IBOutlet weak var marginErrorApellidos: NSLayoutConstraint!
    @IBOutlet weak var heightErrorCorreo: NSLayoutConstraint!
    @IBOutlet weak var marginErrorCorreo: NSLayoutConstraint!
    @IBOutlet weak var heightErrorPassword: NSLayoutConstraint!
    @IBOutlet weak var marginErrorPassword: NSLayoutConstraint!
    
    //scroll
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Inputs
    @IBOutlet weak var inputNombre: UITextField!
    @IBOutlet weak var inputApellidos: UITextField!
    @IBOutlet weak var inputCorreo: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    //Mensajes de error
    @IBOutlet weak var errorNombre: UILabel!
    @IBOutlet weak var errorApellidos: UILabel!
    @IBOutlet weak var errorCorreo: UILabel!
    @IBOutlet weak var errorPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputPassword.textContentType = .oneTimeCode //para evitar que se muestre el mensaje de seguridad que impide introducir la contraseña
        
        //Ajustar los constraints del formulario
        self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        //Mostrar los errores correspondientes en los campos del formulario
        self.showErrors(false)
    }
    
    //Ajustar los constraints del formulario al girar el dispositivo
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
    
    //botón de registrarse
    @IBAction func register(_ sender: Any) {
        //doble check de que los campos no están vacíos (aunque el Validator de la API ya lo comprueba)
        if inputNombre.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && inputApellidos.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && inputCorreo.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && inputPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.register()
        } else {
            let mensaje = "Campo obligatorio"
            showErrors(true, nombre: mensaje, apellidos: mensaje, email: mensaje, password: mensaje)
        }
    }
}

extension RegistroViewController {
    //Registrar un nuevo usuario
    func register() {
        //Hacer la petición a la API para registrarse
        let urlString = "\(API_URL)/user/register"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //enviar por el body los datos introducidos en el formulario
        let bodyData = "nombre=\(inputNombre.text!)&apellidos=\(inputApellidos.text!)&email=\(inputCorreo.text!)&password=\(inputPassword.text!)"
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
                    if getUserRes.success == 1 && getUserRes.user != nil {
                        //Si la respuesta de la API devuelve un usuario, pasar a la siguiente pantalla de la app
                        self.abrirApp(token: getUserRes.token!, user: getUserRes.user!)
                    } else if getUserRes.success == -1 && getUserRes.validator != nil {
                        //Si la respuesta de la API devuelve errores de validación, mostrarlos en el formulario
                        self.showErrors(true, nombre: getUserRes.validator!.nombre?[0], apellidos: getUserRes.validator!.apellidos?[0], email: getUserRes.validator!.email?[0], password: getUserRes.validator!.password?[0])
                    }
                    else {
                        //Si la respuesta de la API devuelve un error al crear las credenciales, mostrarlo en el formulario
                        self.showErrors(true, password: getUserRes.message)
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
                                
        }.resume()
    }
    
    //Cambiar el tamaño de los constraints de los errores para mostrar u ocultar los mensajes de la validación del formulario
    func showErrors(_ show: Bool, nombre: String? = "", apellidos: String? = "", email: String? = "", password: String? = "") {
        if show {
            if nombre != nil && nombre != ""{
                heightErrorNombre.constant = 20
                marginErrorNombre.constant = 8
                errorNombre.text = nombre
            } else {
                heightErrorNombre.constant = 0
                marginErrorNombre.constant = 0
            }
            
            if apellidos != nil && apellidos != ""{
                heightErrorApellidos.constant = 20
                marginErrorApellidos.constant = 8
                errorApellidos.text = apellidos
            } else {
                heightErrorApellidos.constant = 0
                marginErrorApellidos.constant = 0
            }
            
            if email != nil && email != ""{
                heightErrorCorreo.constant = 20
                marginErrorCorreo.constant = 8
                errorCorreo.text = email
            } else {
                heightErrorCorreo.constant = 0
                marginErrorCorreo.constant = 0
            }
            
            if password != nil && password != ""{
                heightErrorPassword.constant = 20
                marginErrorPassword.constant = 8
                errorPassword.text = password
            } else {
                heightErrorPassword.constant = 0
                marginErrorPassword.constant = 0
            }
        } else {
            heightErrorNombre.constant = 0
            marginErrorNombre.constant = 0
            heightErrorApellidos.constant = 0
            marginErrorApellidos.constant = 0
            heightErrorCorreo.constant = 0
            marginErrorCorreo.constant = 0
            heightErrorPassword.constant = 0
            marginErrorPassword.constant = 0
            errorNombre.text = "Error"
            errorApellidos.text = "Error"
            errorCorreo.text = "Error"
            errorPassword.text = "Error"
        }
    }
    
    //mover el scrollView al aparecer el teclado virtual según la posición del campo
    //Se considera que se está mostrando el teclado virtual en pantalla si ocupa al menos el 10% de esta
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > (UIScreen.main.bounds.height * 0.1){
            if let seleccionado = view.selectedTextField {
                if seleccionado.frame.origin.y + seleccionado.frame.height > UIScreen.main.bounds.size.height - keyboardSize.height - 50 {
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
extension RegistroViewController: UITextFieldDelegate {
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
