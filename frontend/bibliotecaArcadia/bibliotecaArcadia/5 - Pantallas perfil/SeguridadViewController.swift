//
//  SeguridadViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 11/4/25.
//

import UIKit

class SeguridadViewController: UIViewController {
    var user: UserDB?
    @IBOutlet weak var tableView: UITableView!
    
    //constraints para ajustar los elementos según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingBtn: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailingBtn: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y DataSource del TableView
        tableView.dataSource = self
        tableView.delegate = self
        
        user = getUserDB() //obtener los datos del usuario de CoreData
        
        //Modificar los constraints según el dispositivo
        if UIDevice.current.model == "iPad" || UIDevice.current.model == "iPad Simulator" {
            constraintLeading.constant = 40
            constraintTrailing.constant = 40
            constraintLeadingBtn.constant = 40
            constraintTrailingBtn.constant = 40
        }
    }
    
    //Botón para desactivar la cuenta
    @IBAction func deleteUser(_ sender: Any) {
        //Mostrar una alerta de confirmación
        showAlert()
    }
}

extension SeguridadViewController {
    //Alerta para confirmar la desactivación de la cuenta
    func showAlert() {
        let alertController = UIAlertController(title: "¿Estás seguro de que quieres desactivar la cuenta?", message: "Una vez se desactive, no se podrá recuperar la cuenta", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) // botón cancelar
        //botón para aceptar la desactivación de la cuenta
        let deleteAction = UIAlertAction(title: "Desactivar", style: .destructive) { (action) in
            guard let textfield = alertController.textFields else {
                return
            }
            //si el email no está vacío y coincide con el del usuario guardado en CoreData, eliminar el perfil
            if let email = textfield[0].text, email != "" && email == self.user?.email{
                //Desactivar cuenta
                self.deactivateAccount(email: email)
            }
        }
        deleteAction.isEnabled = false //el botón para desactivar la cuenta está desactivado en principio
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        //Añadir un TextField a la alerta para escribir el correo. Detecta los cambios al escribir en el campo
        alertController.addTextField{ textfield in
            textfield.placeholder = "Escribe tu correo para confirmar"
            textfield.keyboardType = .emailAddress
            textfield.addTarget(self, action: #selector(self.textoCambiado), for: .editingChanged)
        }
        alertController.view.tintColor = UIColor.accent //Cambiar el color de los botones del alert
        self.present(alertController, animated: true)
    }
    
    //Borrar usuario
    func deactivateAccount(email: String) {
        //Hacer la petición a la API para desactivar la cuenta
        let urlString = "\(API_URL)/user/deactivate"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //Pasarle el token del usuario por el header
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        //Enviar el email introducido por el body
        let bodyData = "email=\(email)"
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
                    if getUserRes.success == 1 {
                        //Eliminar notificaciones de CoreData
                        let arrayNotif = self.getNotifDB() ?? []
                        for i in 0..<arrayNotif.count{
                            self.deleteNotif(notif: arrayNotif[i])
                        }
                        UserDefaults.standard.set(true, forKey: "eliminarBadge")
                        UserDefaults.standard.set(0, forKey: "badgeCount")
                        
                        //Eliminar las búsquedas anteriores de UserDefaults
                        UserDefaults.standard.set([], forKey: "busquedasAnteriores")
                        
                        //eliminar el token e ir a la primera pantalla de la app
                        self.cerrarApp()
                    } else {
                        print("Código \(getUserRes.success): \(getUserRes.message)")
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
    
    //Manejar cambios en el TextField del alert
    @objc func textoCambiado(_ sender: UITextField){
        var responder: UIResponder! = sender
        while !(responder is UIAlertController) { responder = responder.next }
        let alert = responder as! UIAlertController
        //si el correo introducido por el TextField, se activa el botón para eliminar la cuenta
        alert.actions[1].isEnabled = (sender.text != "" && sender.text == self.user!.email)
    }
}

//TableView con una celda para ir al formulario para editar la contraseña
extension SeguridadViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototipoPass", for: indexPath) as! CeldaPerfilPasswordTableViewCell
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "passwordViewController") as! PasswordViewController
        vc.user = self.user
        vc.navigationItem.title = "Editar contraseña"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
