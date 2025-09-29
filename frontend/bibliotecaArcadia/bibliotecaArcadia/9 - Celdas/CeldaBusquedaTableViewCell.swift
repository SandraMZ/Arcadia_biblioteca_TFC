//
//  CeldaGenerosTableViewCell.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 18/4/25.
//

import UIKit

//Celda para la tabla de géneros en la pantalla de búsquedas
class CeldaGenerosTableViewCell: UITableViewCell {
    @IBOutlet weak var lblGenero: UILabel!
    @IBOutlet weak var imgGenero: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//Celda para la tabla de búsquedas anteriores
class CeldaBusquedaTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSearch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
