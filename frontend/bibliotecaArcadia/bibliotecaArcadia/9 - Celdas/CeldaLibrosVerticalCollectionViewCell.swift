//
//  CeldaLibrosVerticalCollectionViewCell.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 11/4/25.
//

import UIKit

//Celda para el collection view con la lista de libros recomendados en la pantalla de inicio
class CeldaLibrosVerticalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        portada.roundCorners(radius: 6)
    }
}

//Celda para el collection view con la lista de libros deseados en la pantalla de inicio
class Celda2LibrosVerticalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        portada.roundCorners(radius: 6)
    }
}

//Celda para el collection view con la lista de libros más popularea en la pantalla de inicio
class Celda3LibrosVerticalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        portada.roundCorners(radius: 6)
    }
}

//Celda para el collection view con la lista de libros del género de literatura y ficción en la pantalla de inicio
class Celda4LibrosVerticalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        portada.roundCorners(radius: 6)
    }
}

//Celda para el collection view con la lista de libros del mismo autor en la pantalla del libro individual
class Celda5LibrosVerticalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        portada.roundCorners(radius: 6)
    }
}
