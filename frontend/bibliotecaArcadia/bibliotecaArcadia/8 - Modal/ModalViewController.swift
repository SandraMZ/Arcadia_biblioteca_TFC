//
//  ModalViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 12/4/25.
//

import UIKit

class ModalViewController: UIViewController {
    @IBOutlet weak var btnHeight: NSLayoutConstraint! //botón para cerrar el modal que sólo se muestra en los dispositivos móviles cuando están girados
    
    //Constraints para ajustar el texto según el ancho de la pantalla en dispositivos iPhone
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Ajustar los constraints
        self.updateConstraints()
    }
    
    //Ajustar los constraints al girar el dispositivo
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints()
        })
    }

    //Cerrar el modal al pulsar el botón
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ModalViewController {
    //Ajustar los constraints para modificar el tamaño del texto según el ancho de la pantalla y mostrar el botón de dismiss según la orientación y el dispositivo que se esté usando
    func updateConstraints() {
        if UIDevice.current.model == "iPhone" || UIDevice.current.model == "iPhone Simulator"{
            if UIScreen.main.bounds.width >= 960{
                self.constraintLeading.constant = 260
                self.constraintTrailing.constant = 260
            } else if UIScreen.main.bounds.width >= 568 {
                self.constraintLeading.constant = 160
                self.constraintTrailing.constant = 160
            } else {
                self.constraintLeading.constant = 40
                self.constraintTrailing.constant = 40
            }
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientation = windowScene.interfaceOrientation
            if (UIDevice.current.model == "iPhone" || UIDevice.current.model == "iPhone Simulator") && (orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portraitUpsideDown) {
                btnHeight.constant = 40
            } else {
                btnHeight.constant = 0
            }
        }
    }
}
