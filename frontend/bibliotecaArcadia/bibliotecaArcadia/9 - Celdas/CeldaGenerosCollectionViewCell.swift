
//
//  CeldaPerfilPasswordTableViewCell.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 12/4/25.
//

import UIKit

//Celda para el collection view con la lista de géneros y subgéneros en la pantalla del libro individual
class CeldaGenerosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var fondo: UIView!
    @IBOutlet weak var labelGenero: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fondo.roundCorners(radius: 8)
        fondo.layer.masksToBounds = false
    }
}
