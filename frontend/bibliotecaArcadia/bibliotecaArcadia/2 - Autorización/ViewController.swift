//
//  ViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 6/4/25.
//

import UIKit
import CoreData

let API_URL = "https://tfc.provisional.com.es/biblio/public/api/arcadia"

class ViewController: UIViewController {
    //Constraints para cambiar el ancho de los botones según el ancho de la pantalla y evitar que se "extiendan" demasiado
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ajustar los constraints dependiendo del dispositivo
        self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        //Comprobar si el usuario ya tiene la sesión iniciada
        self.getUser()
    }
    
    //Ajustar los constraints al girar el dispositivo
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        })
    }
    
    //Ir a la pantalla de inicio de sesión
    @IBAction func goToLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.title = "Iniciar sesión"
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    //Ir a la pantalla de registro
    @IBAction func goToRegister(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registroVC = storyboard.instantiateViewController(withIdentifier: "RegistroViewController") as! RegistroViewController
        registroVC.title = "Registro"
        self.navigationController?.pushViewController(registroVC, animated: true)
    }
}

extension ViewController {
    //Comprobar si el usuario ya tiene la sesión iniciada
    func getUser() {
        //Llamada a la API para que devuelva el usuario asociado al Token guardado en la memoria de la app del dispositivo
        let urlString = "\(API_URL)/user"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
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
                let getUserRes = try jsonDecoder.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    //Si la respuesta de la API ha devuelto un usuario con ese token, automáticamente se salta el inicio de sesión
                    if(getUserRes.success == 1 && getUserRes.user != nil){
                        self.abrirApp(token: UserDefaults.standard.string(forKey: "token")!, user: getUserRes.user!)
                    } else {
                        print("Code \(getUserRes.success): \(getUserRes.message)")
                    }
                }
            }catch let jsonError {
                print("JSON error: \(jsonError)")
            }
        }.resume()
    }
}
