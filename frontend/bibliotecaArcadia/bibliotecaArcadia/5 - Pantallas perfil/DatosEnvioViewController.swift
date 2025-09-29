//
//  DatosEnvioViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 11/4/25.
//

import UIKit

class DatosEnvioViewController: UIViewController {
    var user: UserDB?
    
    //constraints para ajustar el formulario al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingBtn: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailingBtn: NSLayoutConstraint!
    
    //constraints para los mensajes de error
    @IBOutlet weak var heightNameError: NSLayoutConstraint!
    @IBOutlet weak var heightApellidoError: NSLayoutConstraint!
    @IBOutlet weak var heightDireccionError: NSLayoutConstraint!
    @IBOutlet weak var heightProvinciaError: NSLayoutConstraint!
    @IBOutlet weak var heightLocalidadError: NSLayoutConstraint!
    @IBOutlet weak var heightCodPostalError: NSLayoutConstraint!
    @IBOutlet weak var heightTelfError: NSLayoutConstraint!
    
    @IBOutlet weak var marginNameError: NSLayoutConstraint!
    @IBOutlet weak var marginApellidoError: NSLayoutConstraint!
    @IBOutlet weak var marginDireccionError: NSLayoutConstraint!
    @IBOutlet weak var marginProvinciaError: NSLayoutConstraint!
    @IBOutlet weak var marginLocalidadError: NSLayoutConstraint!
    @IBOutlet weak var marginCodPostalError: NSLayoutConstraint!
    @IBOutlet weak var marginTelfError: NSLayoutConstraint!
    
    //scroll
    @IBOutlet weak var scrollView: UIScrollView!
    
    //TextFields
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldApellido: UITextField!
    @IBOutlet weak var textFieldDireccion: UITextField!
    @IBOutlet weak var textFieldPiso: UITextField!
    @IBOutlet weak var textFieldPuerta: UITextField!
    @IBOutlet weak var textFieldProvincia: UITextField!
    @IBOutlet weak var textFieldLocalidad: UITextField!
    @IBOutlet weak var textFieldCodPostal: UITextField!
    @IBOutlet weak var textFieldTelf: UITextField!
    
    //Labels errores
    @IBOutlet weak var labelNameError: UILabel!
    @IBOutlet weak var labelApellidoError: UILabel!
    @IBOutlet weak var labelDireccionError: UILabel!
    @IBOutlet weak var labelProvinciaError: UILabel!
    @IBOutlet weak var labelLocalidadError: UILabel!
    @IBOutlet weak var labelCodPostalError: UILabel!
    @IBOutlet weak var labelTelfError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = getUserDB() //obtener los datos del usuario de CoreData
        
        //rellenar los campos con los datos del usuario guardado
        textFieldName.text = user!.nombre
        textFieldApellido.text = user!.apellidos
        textFieldTelf.text = user!.telf
        self.getDomicilio()
        
        //ajustar los constraints del formulario
        self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        self.updateConstraints(constraintLeading: self.constraintLeadingBtn, constraintTrailing: self.constraintTrailingBtn)
        self.showErrors(false)
    }
    
    //ajustar los constraints del formulario al girar el dispositivo
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
            self.updateConstraints(constraintLeading: self.constraintLeadingBtn, constraintTrailing: self.constraintTrailingBtn)
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

extension DatosEnvioViewController {
    //Conseguir el domicilio del usuario
    func getDomicilio() {
        //Hacer la petición a la API para conseguir los datos
        let urlString = "\(API_URL)/user/address"
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
                let domicilio = try jsonDecoder.decode(ResDomicilio?.self, from: data)
                DispatchQueue.main.async {
                    //Mostrar los datos en los campos de la interfaz si el usuario tiene algún domicilio asociado
                    if domicilio?.address != nil {
                        self.textFieldDireccion.text = domicilio!.address!.direccion
                        if domicilio!.address!.piso != nil {
                            self.textFieldPiso.text = domicilio!.address!.piso
                        }
                        if domicilio!.address!.puerta != nil {
                            self.textFieldPuerta.text = domicilio!.address!.puerta
                        }
                        self.textFieldProvincia.text = domicilio!.address!.provincia
                        self.textFieldLocalidad.text = domicilio!.address!.localidad
                        self.textFieldCodPostal.text = domicilio!.address!.cod_postal
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
                                
        }.resume()
    }
    
    //Guardar los cambios en el domicilio en la API
    func saveChanges() {
        //Hacer la petición a la API para guardar el domicilio
        let urlString = "\(API_URL)/user/address"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //Como es una url con middleware de autenticación, hay que pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //pasar los datos del formulario por el body
        let bodyData = "nombre=\(textFieldName.text!)&apellidos=\(textFieldApellido.text!)&direccion=\(textFieldDireccion.text!)&piso=\(textFieldPiso.text!)&puerta=\(textFieldPuerta.text!)&provincia=\(textFieldProvincia.text!)&localidad=\(textFieldLocalidad.text!)&codPostal=\(textFieldCodPostal.text!)&telf=\(textFieldTelf.text!)"
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
                    if getUserRes.success == 1 && getUserRes.address != nil {
                        //Guardar en CoreData los datos del usuario que se hayan cambiado
                        self.saveUserFieldDB(nombre: getUserRes.user!.nombre, apellidos: getUserRes.user!.apellidos, telf: getUserRes.user!.telf)
                        
                        //ir a la pantalla anterior en la navegación
                        self.navigationController?.popViewController(animated: true)
                        
                    } else if getUserRes.success == -1 && getUserRes.validator != nil {
                        //Si la respuesta de la API devuelve errores de validación, mostrarlos en el formulario
                        self.showErrors(true, nombre: getUserRes.validator!.nombre?[0], apellidos: getUserRes.validator!.apellidos?[0], direccion: getUserRes.validator!.direccion?[0], provincia: getUserRes.validator!.provincia?[0], localidad: getUserRes.validator!.localidad?[0], codigoPostal: getUserRes.validator!.codPostal?[0], telf: getUserRes.validator!.telf?[0])
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
    
    //Modificar en el CoreData los datos del usuario que se han cambiado desde este formulario
    func saveUserFieldDB(nombre: String, apellidos: String, telf: String?) {
        guard UIApplication.shared.delegate is AppDelegate else { return }
        
        user!.setValue(nombre, forKey: "nombre")
        user!.setValue(apellidos, forKey: "apellidos")
        if telf != nil && telf != "" {
            user!.setValue(telf, forKey: "telf")
        }
        
        do{
            try user!.managedObjectContext?.save()
        } catch let error as NSError {
            print("No se ha podido actualizar el usuario. \(error), \(error.userInfo)")
        }
    }
    
    //Cambiar el tamaño de los constraints para mostrar u ocultar los mensajes de error de la validación del formulario
    func showErrors(_ show: Bool, nombre: String? = "", apellidos: String? = "", direccion: String? = "", provincia: String? = "", localidad: String? = "" ,codigoPostal: String? = "", telf: String? = "") {
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
            
            if direccion != nil && direccion != ""{
                heightDireccionError.constant = 20
                marginDireccionError.constant = 8
                labelDireccionError.text = direccion
            } else {
                heightDireccionError.constant = 0
                marginDireccionError.constant = 0
            }
            
            if provincia != nil && provincia != ""{
                heightProvinciaError.constant = 20
                marginProvinciaError.constant = 8
                labelProvinciaError.text = provincia
            } else {
                heightProvinciaError.constant = 0
                marginProvinciaError.constant = 0
            }
            
            if localidad != nil && localidad != ""{
                heightLocalidadError.constant = 20
                marginLocalidadError.constant = 8
                labelLocalidadError.text = localidad
            } else {
                heightLocalidadError.constant = 0
                marginLocalidadError.constant = 0
            }
            
            if codigoPostal != nil && codigoPostal != ""{
                heightCodPostalError.constant = 20
                marginCodPostalError.constant = 8
                labelCodPostalError.text = codigoPostal
            } else {
                heightCodPostalError.constant = 0
                marginCodPostalError.constant = 0
            }
            
            if telf != nil && telf != ""{
                heightTelfError.constant = 20
                marginTelfError.constant = 8
                labelTelfError.text = telf
            } else {
                heightTelfError.constant = 0
                marginTelfError.constant = 0
            }
        } else {
            heightNameError.constant = 0
            heightApellidoError.constant = 0
            heightDireccionError.constant = 0
            heightProvinciaError.constant = 0
            heightLocalidadError.constant = 0
            heightCodPostalError.constant = 0
            heightTelfError.constant = 0
            marginNameError.constant = 0
            marginApellidoError.constant = 0
            marginDireccionError.constant = 0
            marginProvinciaError.constant = 0
            marginLocalidadError.constant = 0
            marginCodPostalError.constant = 0
            marginTelfError.constant = 0
        }
    }
    
    //mover el scrollView al aparecer el teclado virtual dependiendo del tag del input, el tamaño de la pantalla y el dispositivo
    //Se considera que se está mostrando el teclado virtual en pantalla si ocupa al menos el 10% de esta
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > (UIScreen.main.bounds.height * 0.1){
            if let seleccionado = view.selectedTextField {
                if seleccionado.frame.origin.y + seleccionado.frame.height > UIScreen.main.bounds.size.height - keyboardSize.height - 140 {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let orientation = windowScene.interfaceOrientation
                        if orientation.isLandscape {
                            if seleccionado.tag == 9 {
                                let texfield = view.viewWithTag((seleccionado.tag - 1))! as! UITextField
                                if UIScreen.main.bounds.height > 400 {
                                    scrollView.contentOffset = CGPoint(x: 0, y: (texfield.frame.origin.y - 40))
                                } else {
                                    scrollView.contentOffset = CGPoint(x: 0, y: (seleccionado.frame.origin.y - 40))
                                }
                            } else {
                                scrollView.contentOffset = CGPoint(x: 0, y: (seleccionado.frame.origin.y - 40))
                            }
                        } else {
                            if UIDevice.current.model == "iPad" || UIDevice.current.model == "iPad Simulator" {
                                scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height + 100), animated: true)
                            } else {
                                if orientation != .portraitUpsideDown {
                                    if seleccionado.tag == 5 || seleccionado.tag == 6 || seleccionado.tag == 9 {
                                        let texfield = view.viewWithTag((seleccionado.tag - 3))! as! UITextField
                                        scrollView.contentOffset = CGPoint(x: 0, y: (texfield.frame.origin.y + texfield.frame.height))
                                    } else {
                                        let texfield = view.viewWithTag((seleccionado.tag - 2))! as! UITextField
                                        scrollView.contentOffset = CGPoint(x: 0, y: (texfield.frame.origin.y + texfield.frame.height))
                                    }
                                } else {
                                    scrollView.contentOffset = CGPoint(x: 0, y: (seleccionado.frame.origin.y - 40))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //mover el ScrollView al desaparecer el teclado (si se está usando el teclado virtual)
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > (UIScreen.main.bounds.height * 0.1){
            if let seleccionado = view.selectedTextField {
                if seleccionado.frame.origin.y + seleccionado.frame.height > UIScreen.main.bounds.size.height - keyboardSize.height - 140 {
                    if UIScreen.main.bounds.height < 600 {
                        if seleccionado.tag < 3 {
                            scrollView.setContentOffset(.zero, animated: true)
                        } else if seleccionado.tag > 7 {
                            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
                            scrollView.setContentOffset(bottomOffset, animated: true)
                        }
                    } else {
                        if seleccionado.tag <= 5 {
                            scrollView.setContentOffset(.zero, animated: true)
                        } else if seleccionado.tag > 5 {
                            
                            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
                            scrollView.setContentOffset(bottomOffset, animated: true)
                        }
                    }
                }  else {
                    scrollView.setContentOffset(.zero, animated: true)
                }
            } else {
                scrollView.setContentOffset(.zero, animated: true)
            }
        }
    }
}

//Delegado de los TextFields
extension DatosEnvioViewController: UITextFieldDelegate {
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
