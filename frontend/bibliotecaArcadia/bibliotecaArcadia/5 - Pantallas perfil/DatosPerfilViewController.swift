//
//  DatosPerfilViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 10/4/25.
//

import UIKit

class DatosPerfilViewController: UIViewController {
    var user: UserDB?
    @IBOutlet weak var tableView: UITableView!
    
    //constraints para ajustar los elementos según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = getUserDB() //obtener los datos del usuario de CoreData
        tableView.reloadData()
    }
}

//TableView con las opciones para ir a los formularios para editar cada dato
extension DatosPerfilViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Rellenar los datos de cada celda/ botón con la información correspondiente
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prototipo1", for: indexPath) as! CeldaPerfil1TableViewCell
            cell.titulo.text = "Nombre y apellidos"
            cell.datoPerfil.text = "\(user!.nombre!) \(user!.apellidos!)"
            cell.contentView.layer.masksToBounds = true
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prototipo1", for: indexPath) as! CeldaPerfil1TableViewCell
            cell.titulo.text = "Correo electrónico"
            cell.datoPerfil.text = user!.email!
            cell.contentView.layer.masksToBounds = true
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prototipo1", for: indexPath) as! CeldaPerfil1TableViewCell
            cell.titulo.text = "Número de teléfono"
            if user!.telf != nil {
                cell.datoPerfil.text = user!.telf!
            } else {
                cell.datoPerfil.text = "Añade tu número de teléfono"
            }
            cell.contentView.layer.masksToBounds = true
            return cell
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prototipo1", for: indexPath) as! CeldaPerfil1TableViewCell
            cell.titulo.text = "Fecha de nacimiento"
            if user!.fecha_nac != nil {
                cell.datoPerfil.text = user!.fecha_nac!
            } else {
                cell.datoPerfil.text = "Añade tu fecha de nacimiento"
            }
            cell.contentView.layer.masksToBounds = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prototipo2", for: indexPath) as! CeldaPerfil2TableViewCell
            cell.parent = self //pasarle la instancia del controlador para poder instanciar otra pantalla desde un botón en la celda
            cell.dni.text = "Añade tu DNI o NIE"
            return cell
        }
    }
    
    //Indicar la navegación al formulario correspondiente desde cada celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "nombreViewController") as! NombreViewController
            vc.user = self.user
            vc.navigationItem.title = "Nombre y apellidos"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "emailController") as! EmailViewController
            vc.user = self.user
            vc.navigationItem.title = "Correo electrónico"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "telfViewController") as! TelfViewController
            vc.user = self.user
            vc.navigationItem.title = "Número de teléfono"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "fechaViewController") as! FechaNacViewController
            vc.user = self.user
            vc.navigationItem.title = "Fecha de nacimiento"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "dniViewController") as! DniViewController
            vc.user = self.user
            vc.navigationItem.title = "DNI o NIE"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
