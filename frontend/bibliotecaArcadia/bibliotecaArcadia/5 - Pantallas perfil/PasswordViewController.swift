//
//  PasswordViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 12/4/25.
//

import UIKit

class PasswordViewController: UIViewController {
    var user: UserDB?
    
    //constraints para ajustar el formulario al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //Constraints errores
    @IBOutlet weak var heightCurrentError: NSLayoutConstraint!
    @IBOutlet weak var heightNewError: NSLayoutConstraint!
    @IBOutlet weak var heightConfirmError: NSLayoutConstraint!
    @IBOutlet weak var marginCurrentError: NSLayoutConstraint!
    @IBOutlet weak var marginNewError: NSLayoutConstraint!
    @IBOutlet weak var marginConfirmError: NSLayoutConstraint!
    
    //scroll
    @IBOutlet weak var scrollView: UIScrollView!
    
    //TextFields
    @IBOutlet weak var textFieldCurrent: UITextField!
    @IBOutlet weak var textFieldNew: UITextField!
    @IBOutlet weak var textFieldConfirm: UITextField!
    
    //Labels errores
    @IBOutlet weak var labelCurrentError: UILabel!
    @IBOutlet weak var labelNewError: UILabel!
    @IBOutlet weak var labelConfirmError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //para evitar que se muestre el mensaje de seguridad que impide introducir la contraseña
        textFieldCurrent.textContentType = .oneTimeCode
        textFieldNew.textContentType = .oneTimeCode
        textFieldConfirm.textContentType = .oneTimeCode

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
    @IBAction func save(){
        self.saveChanges()
    }
}

extension PasswordViewController {
    //Guardar los cambios en la API
    func saveChanges() {
        //Hacer la petición a la API para guardar el cambio de la contraseña
        let urlString = "\(API_URL)/user/password"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //Como es una url con middleware de autenticación, hay que pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //pasar los datos del formulario por el body
        let bodyData = "anteriorPass=\(textFieldCurrent.text!)&nuevaPass=\(textFieldNew.text!)&nuevaPass_confirmation=\(textFieldConfirm.text!)"
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
                    if getUserRes.success == 1 {//ir a la pantalla anterior en la navegación
                        self.navigationController?.popViewController(animated: true)
                        
                    } else if getUserRes.success == -1 && getUserRes.validator != nil {
                        //Si la respuesta de la API devuelve errores de validación, mostrarlos en el formulario
                        self.showErrors(true, current: getUserRes.validator!.anteriorPass?[0], new: getUserRes.validator!.nuevaPass?[0], confirm: getUserRes.validator!.nuevaPass_confirmation?[0])
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
    
    //Cambiar el tamaño de los constraints para mostrar u ocultar los mensajes de error de la validación del formulario
    func showErrors(_ show: Bool, current: String? = "", new: String? = "", confirm: String? = "") {
        if show {
            if current != nil && current != "" {
                heightCurrentError.constant = 20
                marginCurrentError.constant = 8
                labelCurrentError.text = current
            } else {
                heightCurrentError.constant = 0
                marginCurrentError.constant = 0
            }
            
            if new != nil && new != "" {
                heightNewError.constant = 20
                marginNewError.constant = 8
                labelNewError.text = new
            } else {
                heightNewError.constant = 0
                marginNewError.constant = 0
            }
            
            if confirm != nil && confirm != "" {
                heightConfirmError.constant = 20
                marginConfirmError.constant = 8
                labelConfirmError.text = confirm
            } else {
                heightConfirmError.constant = 0
                marginConfirmError.constant = 0
            }
        } else {
            heightCurrentError.constant = 0
            heightNewError.constant = 0
            heightConfirmError.constant = 0
            marginCurrentError.constant = 0
            marginNewError.constant = 0
            marginConfirmError.constant = 0
            labelCurrentError.text = "Error"
            labelNewError.text = "Error"
            labelConfirmError.text = "Error"
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
extension PasswordViewController: UITextFieldDelegate {
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


