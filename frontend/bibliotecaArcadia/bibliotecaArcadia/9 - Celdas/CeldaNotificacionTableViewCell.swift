//
//  CeldaNotificacionTableViewCell.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 17/4/25.
//

import UIKit

//Celda para la tabla de las notificaciones
class CeldaNotificacionTableViewCell: UITableViewCell {
    @IBOutlet weak var notificacion: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        portada.roundCorners(radius: 4)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

