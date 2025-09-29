//
//  NotifTableViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 17/4/25.
//

import UIKit
import Kingfisher

class NotifViewController: UIViewController {
    var arrayNotif: [NotificacionDB] = [] //para obtener el array de notifs. del HomeViewController y mostrarlo en el TableView
    var delegate: NotifDelegate? //para implementar el delegado
    
    @IBOutlet weak var messageConstraint: NSLayoutConstraint! //para mostrar u ocultar el mensaje según si el array está vacío
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mostrar el mensaje si no hay notificaciones, esconderlo si las hay
        if arrayNotif.count == 0 {
            messageConstraint.constant = 44
        } else {
            messageConstraint.constant = 0
        }
        
        //Delegate y DataSource de la tabla
        tableView.delegate = self
        tableView.dataSource = self
        
        //Al cargarse esta vista, notificar a la vista anterior gracias al delegate de que las notificaciones han sido leídas y se puede eliminar el badge
        delegate?.eliminarNotif(notiVista: true)
    }
}

//Extensión para configurar la lista utilizando UITableView
extension NotifViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Limitar el número de notificaciones que se muestran a 15
        if arrayNotif.count < 15 {
            return arrayNotif.count
        } else {
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaNotificacion", for: indexPath) as! CeldaNotificacionTableViewCell
        let item =  self.arrayNotif[indexPath.item]
        
        cell.notificacion.text = item.mensaje
        cell.fecha.text = formatDate(date: item.fecha!)
        
        //cargar la imagen de la portada. Si no hay, cargar un a imagen placeholder
        if item.portada != nil && item.portada != "" {
            cell.portada.kf.setImage(with: URL(string: item.portada!)!)
        } else {
            cell.portada.image = UIImage(named: "libro_placeholder")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let libro = storyboard.instantiateViewController(withIdentifier: "libroViewController") as! LibroViewController
        libro.id = self.arrayNotif[indexPath.item].id_libro
        self.navigationController?.pushViewController(libro, animated: true)
    }
}
