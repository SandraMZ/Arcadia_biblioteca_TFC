//
//  CeldaPerfilPasswordTableViewCell.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 12/4/25.
//

import UIKit

//Celda para el "botón" que lleva al formulario de cambiar contraseña
class CeldaPerfilPasswordTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        cardView.layer.masksToBounds = false
        cardView.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//Estilo de celda genérico para los "botones" que llevan a los formularios para cambiar los datos del perfil
class CeldaPerfil1TableViewCell: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var datoPerfil: UILabel!
    
    //View
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        cardView.layer.masksToBounds = false
        cardView.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//Estilo de celda para el "botón" que llevan al formulario para cambiar el dni. Tiene un botón integrado para mostrar el modal de información
class CeldaPerfil2TableViewCell: UITableViewCell {
    @IBOutlet weak var dni: UILabel!
    var parent: UIViewController?
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.backgroundColor = .white
        cardView.roundCorners(radius: 8)
        cardView.layer.masksToBounds = false
        cardView.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Botón para abrir el modar
    @IBAction func btnAbrirModal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "modalDNI")
        
        //Si es un iPhone, se muestra como modal
        if UIDevice.current.model == "iPhone" || UIDevice.current.model == "iPhone Simulator"{
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
        
        if parent != nil {
            parent!.present(modal, animated: true)
        }
    }

}
