//
//  LoginViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 7/4/25.
//

import UIKit

class LoginViewController: UIViewController {
    //constraints para ajustar el formulario al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //constraints para los mensajes de error
    @IBOutlet weak var heightError1: NSLayoutConstraint!
    @IBOutlet weak var heightError2: NSLayoutConstraint!
    @IBOutlet weak var marginError1: NSLayoutConstraint!
    @IBOutlet weak var marginError2: NSLayoutConstraint!
    
    //scroll
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Inputs
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    //Mensajes de error
    @IBOutlet weak var errorEmail: UILabel!
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
    
    //botón de login
    @IBAction func login(_ sender: Any) {
        self.login()
    }
}

extension LoginViewController {
    //Iniciar sesión
    func login() {
        //Hacer la petición a la API para iniciar sesión
        let urlString = "\(API_URL)/user/login"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //enviar por el body los datos introducidos en el formulario
        let bodyData = "email=\(inputEmail.text!)&password=\(inputPassword.text!)"
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
                        self.showErrors(true, email: getUserRes.validator!.email?[0], password: getUserRes.validator!.password?[0])
                    } else {
                        //Si la respuesta de la API devuelve un error de credenciales, mostrarlo en el formulario
                        self.showErrors(true, password: getUserRes.message)
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Cambiar el tamaño de los constraints de los errores para mostrar u ocultar los mensajes de la validación del formulario
    func showErrors(_ show: Bool, email: String? = "", password: String? = "") {
        if show {
            if email != nil && email != ""{
                heightError1.constant = 20
                marginError1.constant = 8
                errorEmail.text = email
            } else {
                heightError1.constant = 0
                marginError1.constant = 0
            }
            
            if password != nil && password != ""{
                heightError2.constant = 20
                marginError2.constant = 8
                errorPassword.text = password
            } else {
                heightError2.constant = 0
                marginError2.constant = 0
            }
        } else {
            heightError1.constant = 0
            heightError2.constant = 0
            marginError1.constant = 0
            marginError2.constant = 0
            errorEmail.text = "Error"
            errorPassword.text = "Error"
        }
    }
    
    //mover el scrollView al aparecer el teclado virtual
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
extension LoginViewController: UITextFieldDelegate {
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
