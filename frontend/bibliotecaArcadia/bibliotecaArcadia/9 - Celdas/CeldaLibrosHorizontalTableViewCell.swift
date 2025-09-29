//
//  CeldaLibrosHorizontalTableViewCell.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 11/4/25.
//

import UIKit

//Celda del libro para la tabla de libros prestados o en préstamo
class CeldaLibrosHorizontalTableViewCell: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var codPedido: UILabel!
    @IBOutlet weak var devolucion: UILabel!
    @IBOutlet weak var portada: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        portada.roundCorners(radius: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//Celda del libro para la tabla de libros deseados o en espera
class Celda2LibrosHorizontalTableViewCell: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var publicacion: UILabel!
    @IBOutlet weak var portada: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        portada.roundCorners(radius: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//Celda del libro para la tabla en pantalla de resultados
class CeldaResultadosTableViewCell: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var publicacion: UILabel!
    @IBOutlet weak var portada: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        portada.roundCorners(radius: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
