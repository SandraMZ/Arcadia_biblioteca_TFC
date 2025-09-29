//
//  MotivoExtensionModal.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 25/4/25.
//

import UIKit

class MotivoExtensionModal: UIViewController {
    //Delegate y variable para intercambiar información con la pantalla anterior
    var delegate: MotivoDelegate?
    var mensaje: String?
    
    @IBOutlet weak var txtMotivo: UITextView!
    @IBOutlet weak var heightTextView: NSLayoutConstraint! //para modificar la altura del textView
    
    //Constraints para ajustar el formulario al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Cambiar el estilo del TextView para que sea parecido al de un TextField
        txtMotivo.roundCorners()
        txtMotivo.layer.borderWidth = 1
        txtMotivo.layer.borderColor = UIColor.systemGray5.cgColor
        txtMotivo.text = mensaje ?? ""
        
        //cambiar los constraints según el ancho de las pantallas
        updateConstraints(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
    
    //cambiar los constraints al girar el dispositivo
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        })
    }
    
    //Gestión del teclado
    override func viewWillAppear(_ animated: Bool) {
        self.keyboardWhenTappedAround() //cerrar el teclado al pulsar fuera del mismo
        
        //mover el View al aparecer y ocultarse el teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Quitar los Observers del teclado al desaparecer la vista
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Botón para enviar el motivo al formulario principal
    @IBAction func sendMotivo(_ sender: Any) {
        //pasarle los datos a la función del delegate
        delegate?.recibirMotivo(txtMotivo.text ?? "")
        //ir a la pantalla anterior
        self.navigationController?.popViewController(animated: true)
    }
}

extension MotivoExtensionModal {
    //Cambiar la altura del TextView al aparecer el teclado virtual
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > (UIScreen.main.bounds.height * 0.1){
            if self.heightTextView.constant > UIScreen.main.bounds.size.height - keyboardSize.height - 50 {
                if UIDevice.current.model == "iPad" || UIDevice.current.model == "iPad Simulator" {
                    self.heightTextView.constant = UIScreen.main.bounds.size.height - keyboardSize.height - 160
                } else {
                    self.heightTextView.constant = UIScreen.main.bounds.size.height - keyboardSize.height - 65
                }
            }
        }
    }
    
    //Volver a la altura original del textView al desaparecer el teclado virtual
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > (UIScreen.main.bounds.height * 0.1){
            self.heightTextView.constant = 300
        }
    }
}
