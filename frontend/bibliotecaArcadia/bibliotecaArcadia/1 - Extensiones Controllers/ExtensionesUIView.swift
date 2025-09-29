//
//  ExtensionesUIView.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 24/5/25.
//

import UIKit

extension UIView {
    //MARK: Cambiar estilo de una vista
    //Añadir sombra
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
          self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.2
    }
    
    //Hacer los bordes redondeados
    func roundCorners(radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    //MARK: Manejar TextFields
    //array con todos los TextFields que contiene la vista
    var textFieldsInView: [UITextField] {
        return subviews
        .filter({ !($0 is UITextField) })
        .reduce((subviews.compactMap{$0 as? UITextField}), { sum, current in
            return sum + current.textFieldsInView
        })
    }
    
    //UITextFiled que tiene el foco
    var selectedTextField: UITextField? {
        return textFieldsInView.filter{ $0.isFirstResponder }.first
    }
}
