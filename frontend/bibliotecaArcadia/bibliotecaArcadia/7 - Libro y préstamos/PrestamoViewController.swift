//
//  PrestamoViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 25/4/25.
//

import UIKit

class PrestamoViewController: UIViewController {
    var user: UserDB?
    var validated: Bool = true //variable para controlar los errores de validación
    //Variables para guardar los datos procedentes de los libros y que se tienen que pasar a la pantalla de resumen del préstamo
    var titulo: String?
    var autores: String?
    var fotoUrl: String?
    var idLibro: String?
    var pantallaLibro: LibroViewController?
    
    //constraints para ajustar la anchura de los inputs según ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingBtn: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailingBtn: NSLayoutConstraint!
    
    //scrollview
    @IBOutlet weak var scrollView: UIScrollView!
    
    //textfields
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var dni: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var piso: UITextField!
    @IBOutlet weak var puerta: UITextField!
    @IBOutlet weak var provincia: UITextField!
    @IBOutlet weak var localidad: UITextField!
    @IBOutlet weak var codPostal: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var telf: UITextField!
    
    //labels y constraints errores
    @IBOutlet weak var errorNombre: UILabel!
    @IBOutlet weak var errorApellidos: UILabel!
    @IBOutlet weak var errorDNI: UILabel!
    @IBOutlet weak var errorDireccion: UILabel!
    @IBOutlet weak var errorProvincia: UILabel!
    @IBOutlet weak var errorLocalidad: UILabel!
    @IBOutlet weak var errorCodPostal: UILabel!
    @IBOutlet weak var errorCorreo: UILabel!
    @IBOutlet weak var errorTelf: UILabel!
    
    @IBOutlet weak var heightErrorNombre: NSLayoutConstraint!
    @IBOutlet weak var heightErrorApellidos: NSLayoutConstraint!
    @IBOutlet weak var heightErrorDNI: NSLayoutConstraint!
    @IBOutlet weak var heightErrorDireccion: NSLayoutConstraint!
    @IBOutlet weak var heightErrorProvincia: NSLayoutConstraint!
    @IBOutlet weak var heightErrorLocalidad: NSLayoutConstraint!
    @IBOutlet weak var heightErrorCodPostal: NSLayoutConstraint!
    @IBOutlet weak var heightErrorCorreo: NSLayoutConstraint!
    @IBOutlet weak var heightErrorTelf: NSLayoutConstraint!
    
    @IBOutlet weak var marginErrorNombre: NSLayoutConstraint!
    @IBOutlet weak var marginErrorApellidos: NSLayoutConstraint!
    @IBOutlet weak var marginErrorDNI: NSLayoutConstraint!
    @IBOutlet weak var marginErrorDireccion: NSLayoutConstraint!
    @IBOutlet weak var marginErrorProvincia: NSLayoutConstraint!
    @IBOutlet weak var marginErrorLocalidad: NSLayoutConstraint!
    @IBOutlet weak var marginErrorCodPostal: NSLayoutConstraint!
    @IBOutlet weak var marginErrorCorreo: NSLayoutConstraint!
    @IBOutlet weak var marginErrorTelf: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = getUserDB()! //cargar el usuario de CoreData
        getDomicilio() //obtener los datos del domicilio asignado a esta cuenta
        
        //Mostrar los datos del usuario en el formulario
        self.nombre.text = user?.nombre
        self.apellidos.text = user?.apellidos
        self.correo.text = user?.email
        self.dni.text = user?.dni ?? ""
        self.telf.text = user?.telf ?? ""
        
        //Modificar los constraints según el ancho de la pantalla y del dispositivo
        self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        self.updateConstraintsNoForm(constraintLeading: self.constraintLeadingBtn, constraintTrailing: self.constraintTrailingBtn)
    }
    
    //Modificar los constraints al girar el dispositivo
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reestablecer la validación al regresar a la pantalla
        validated = true
        showErrors(false)
        
        //Gestión del teclado
        self.keyboardWhenTappedAround() //cerrar el teclado al pulsar fuera del mismo
        
        //mover el View al aparecer o desaparecer el teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Cambiar de campo al pulsar intro en el teclado
        self.defineTextFieldsDelegate()
    }
    
    //Quitar los Observers del teclado al desaparecer la vista
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    //Botón para mostrar el modal con información
    @IBAction func modalDNI(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "modalDNI")
        
        if (UIDevice.current.model == "iPhone" || UIDevice.current.model == "iPhone Simulator"){
            //Si es un iPhone, se muestra como modal
            modal.modalPresentationStyle = .pageSheet
            if let sheet = modal.sheetPresentationController {
                //para que el modal sólo llegue hasta la mitad de la pantalla
                sheet.detents = [
                    .medium()
                ]
            }
        } else {
            //Si es un iPad, se muestra como popover con origen en el botón que lo instancia
            modal.modalPresentationStyle = .popover
            modal.preferredContentSize = CGSize(width: 400, height: 300)
            
            if let vistaOrigen = modal.popoverPresentationController{
                vistaOrigen.sourceView = sender as! UIButton
           }
        }

        self.present(modal, animated: true)
    }
    
    //Botón para pasar a la siguiente pantalla si todos los campos del formulario son válidos
    @IBAction func continuar(_ sender: Any) {
        showErrors(true)
        if validated {
            showErrors(false)
            goToResumen()
        }
    }
}

extension PrestamoViewController {
    //Conseguir el domicilio del usuario
    func getDomicilio() {
        //Hacer la petición a la API para conseguir los datos
        let urlString = "\(API_URL)/user/address"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //Pasarle el token del usuario por el header
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
                    if domicilio?.address != nil {
                        //Si hay un domicilio guardado, mostrar los datos en la interfaz
                        self.direccion.text = domicilio!.address!.direccion
                        if domicilio!.address!.piso != nil {
                            self.piso.text = domicilio!.address!.piso
                        }
                        if domicilio!.address!.puerta != nil {
                            self.puerta.text = domicilio!.address!.puerta
                        }
                        self.provincia.text = domicilio!.address!.provincia
                        self.localidad.text = domicilio!.address!.localidad
                        self.codPostal.text = domicilio!.address!.cod_postal
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
                                
        }.resume()
    }
    
    //Comprobación de los campos y cambiar el tamaño de los constraints para mostrar u ocultar los mensajes de error de la validación del formulario
    //Como desde esta pantalla no se envía el formulario a la API, las comprobaciones de la validez de los campos se tienen que calcular en el front en vez de recibirlos desde el back como en el resto del formularios
    func showErrors(_ show: Bool) {
        validated = true //el formulario empieza siendo válido. Cambia a no válido cuando algún campo marca error
        if show {
            //validar campo nombre
            if self.nombre.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                heightErrorNombre.constant = 20
                marginErrorNombre.constant = 8
                errorNombre.text = "Campo obligatorio"
                validated = false
            } else {
                heightErrorNombre.constant = 0
                marginErrorNombre.constant = 0
            }
            
            //validar campo apellidos
            if self.apellidos.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                heightErrorApellidos.constant = 20
                marginErrorApellidos.constant = 8
                errorApellidos.text = "Campo obligatorio"
                validated = false
            } else {
                heightErrorApellidos.constant = 0
                marginErrorApellidos.constant = 0
            }
            
            //validar campo dni
            let dni = self.dni.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if dni == "" {
                heightErrorDNI.constant = 20
                marginErrorDNI.constant = 8
                errorDNI.text = "Campo obligatorio"
                validated = false
            } else if dni.count < 9 {
                heightErrorDNI.constant = 20
                marginErrorDNI.constant = 8
                errorDNI.text = "Al menos 9 caracteres"
                validated = false
            } else if dni.count > 12 {
                heightErrorDNI.constant = 20
                marginErrorDNI.constant = 8
                errorDNI.text = "Máximo 12 caracteres"
                validated = false
            } else {
                //validar si cumple el formato del dni o del nie
                let dniValido = self.validarRegex(texto: dni, patron: "^[0-9]{8}-?[A-Z]$")
                let nieValido = self.validarRegex(texto: dni, patron: "^[XYZ]-?[0-9]{7}-?[A-Z]$")
                
                if dniValido == true || nieValido == true {
                    heightErrorDNI.constant = 0
                    marginErrorDNI.constant = 0
                } else {
                    heightErrorDNI.constant = 20
                    marginErrorDNI.constant = 8
                    errorDNI.text = "Formato incorrecto"
                    validated = false
                }
            }
            
            //validar campo email
            let correo = self.correo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if correo == "" {
                heightErrorCorreo.constant = 20
                marginErrorCorreo.constant = 8
                errorCorreo.text = "Campo obligatorio"
                validated = false
            } else if (correo.contains("@") == false || correo.contains(".") == false) {
                heightErrorCorreo.constant = 20
                marginErrorCorreo.constant = 8
                errorCorreo.text = "Campo para correo electrónico"
                validated = false
            } else {
                heightErrorCorreo.constant = 0
                marginErrorCorreo.constant = 0
            }
            
            //validar campo calle de la dirección
            if self.direccion.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                heightErrorDireccion.constant = 20
                marginErrorDireccion.constant = 8
                errorDireccion.text = "Campo obligatorio"
                validated = false
            } else {
                heightErrorDireccion.constant = 0
                marginErrorDireccion.constant = 0
            }
            
            //validar campo provincia
            if self.provincia.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                heightErrorProvincia.constant = 20
                marginErrorProvincia.constant = 8
                errorProvincia.text = "Campo obligatorio"
                validated = false
            } else {
                heightErrorProvincia.constant = 0
                marginErrorProvincia.constant = 0
            }
            
            //validar campo localidad
            if self.localidad.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                heightErrorLocalidad.constant = 20
                marginErrorLocalidad.constant = 8
                errorLocalidad.text = "Campo obligatorio"
                validated = false
            } else {
                heightErrorLocalidad.constant = 0
                marginErrorLocalidad.constant = 0
            }
            
            //validar campo código postal
            let codPostal = self.codPostal.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if codPostal == "" {
                heightErrorCodPostal.constant = 20
                marginErrorCodPostal.constant = 8
                errorCodPostal.text = "Campo obligatorio"
                validated = false
            } else if codPostal.count != 5 {
                heightErrorCodPostal.constant = 20
                marginErrorCodPostal.constant = 8
                errorCodPostal.text = "Sólo 5 caracteres"
                validated = false
            } else {
                heightErrorCodPostal.constant = 0
                marginErrorCodPostal.constant = 0
            }
            
            //Validar campo teléfono
            var telfString = self.telf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if telfString.contains(" ") {
                telfString = telfString.replacingOccurrences(of: " ", with: "")
            }
            
            //si el campo está vacío, es válido (porque es opcional), pero si se ha escrito algo tiene que comprobarse si el formato válido
            let telfValido = telfString == "" ? true : self.validarRegex(texto: telfString, patron: "^[0-9]{9}$")
            
            if telfValido {
                heightErrorTelf.constant = 0
                marginErrorTelf.constant = 0
            } else {
                heightErrorTelf.constant = 20
                marginErrorTelf.constant = 8
                errorTelf.text = "Formato incorrecto"
                validated = false
            }
        } else {
            //ocultar los errores si no se indica que se muestren
            heightErrorNombre.constant = 0
            heightErrorApellidos.constant = 0
            heightErrorDNI.constant = 0
            heightErrorCorreo.constant = 0
            heightErrorDireccion.constant = 0
            heightErrorProvincia.constant = 0
            heightErrorLocalidad.constant = 0
            heightErrorCodPostal.constant = 0
            heightErrorTelf.constant = 0
            
            marginErrorNombre.constant = 0
            marginErrorApellidos.constant = 0
            marginErrorDNI.constant = 0
            marginErrorCorreo.constant = 0
            marginErrorDireccion.constant = 0
            marginErrorProvincia.constant = 0
            marginErrorLocalidad.constant = 0
            marginErrorCodPostal.constant = 0
            marginErrorTelf.constant = 0
        }
    }
    
    //Función para validar el regex del dni y del nie
    func validarRegex(texto: String, patron: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: patron)
            let rango = NSRange(location: 0, length: texto.utf16.count)
            
            if regex.firstMatch(in: texto, options: [], range: rango) != nil {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    //ir a la pantalla de resumen pasándole todos sus datos necesarios
    func goToResumen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resumenVC = storyboard.instantiateViewController(withIdentifier: "resumenViewController") as! ResumenViewController
        resumenVC.title = "Resumen del préstamo"
        
        resumenVC.nombre = self.nombre.text!
        resumenVC.apellidos = self.apellidos.text!
        resumenVC.dni = self.dni.text!
        resumenVC.telefono = self.telf.text!
        resumenVC.email = self.correo.text!
        resumenVC.direccion = self.direccion.text!
        resumenVC.piso = self.piso.text!
        resumenVC.puerta = self.puerta.text!
        resumenVC.provincia = self.provincia.text!
        resumenVC.localidad = self.localidad.text!
        resumenVC.codigoPostal = self.codPostal.text!
        resumenVC.titulo = self.titulo
        resumenVC.autores = self.autores
        resumenVC.fotoUrl = self.fotoUrl
        resumenVC.idLibro = self.idLibro
        resumenVC.pantallaLibro = self.pantallaLibro
        
        self.navigationController?.pushViewController(resumenVC, animated: true)
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
                            if seleccionado.tag == 11 {
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
                                    if seleccionado.tag == 6 || seleccionado.tag == 11 {
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
                        } else if seleccionado.tag > 9 {
                            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
                            scrollView.setContentOffset(bottomOffset, animated: true)
                        }
                    } else if UIScreen.main.bounds.height > 740 {
                        if seleccionado.tag < 4 {
                            scrollView.setContentOffset(.zero, animated: true)
                        } else if seleccionado.tag > 6 {
                            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
                            scrollView.setContentOffset(bottomOffset, animated: true)
                        }
                    } else {
                        if seleccionado.tag < 4 {
                            scrollView.setContentOffset(.zero, animated: true)
                        } else if seleccionado.tag > 8 {
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
extension PrestamoViewController: UITextFieldDelegate {
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
