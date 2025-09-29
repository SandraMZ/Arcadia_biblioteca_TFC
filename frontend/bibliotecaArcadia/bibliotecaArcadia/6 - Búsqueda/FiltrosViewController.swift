//
//  FiltrosViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 18/4/25.
//

import UIKit

class FiltrosViewController: UIViewController {
    @IBOutlet weak var viewShadows: UIView! //vista a la que se le va a aplicar sombra
    //Variables en las que se van a guardar las opciones seleccionadas de los friltros
    @IBOutlet weak var ordenarPor: UIButton!
    @IBOutlet weak var fechaPublicacion: UIButton!
    @IBOutlet weak var idioma: UIButton!
    
    //constraints para ajustar los elementos según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    //Delegate y variables para intercambiar información con la pantalla de resultados
    var delegate: FiltrosDelegate?
    var ordenarCode: Int = 0
    var idiomaString: String = ""
    var fechas: [String] = []
    var fecha: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Cambiar el estilo de la vista
        viewShadows.layer.cornerRadius = 10
        viewShadows.addShadow()
        //Configurar los menús de los pop-up buttons
        setButtonMenus()
        
        //Modificar los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
    
    //Botón para aplicar los filtros en la pantalla de resultados
    @IBAction func applyFilters(_ sender: Any) {
        //pasarle los datos seleccionados a la función del delegate
        delegate?.recibirFiltros(reciente: ordenarCode, fecha: fecha, idioma: idiomaString)
        
        //ir a la pantalla anterior en la navegación
        self.navigationController?.popViewController(animated: true)
    }
}

extension FiltrosViewController {
    //Rellenar los menús de opciones de los botones
    func setButtonMenus(){
        //filtro para elegir el orden
        ordenarPor.menu = UIMenu(children: [
                UIAction(title: "Sin ordenar", state: ordenarCode == 0 ? .on : .off){ action in
                    self.ordenarCode = 0
                },
                UIAction(title: "Fecha más reciente", state: ordenarCode == 1 ? .on : .off){ action in
                    self.ordenarCode = 1
                },
                UIAction(title: "Fecha menos reciente", state: ordenarCode == 2 ? .on : .off){ action in
                    self.ordenarCode = 2
                }
            ])
        ordenarPor.showsMenuAsPrimaryAction = true
        
        //filtro para elegir el idioma
        idioma.menu = UIMenu(children: [
                UIAction(title: "Todos", state: idiomaString == "" ? .on : .off){ action in
                    self.idiomaString = ""
                },
                UIAction(title: "Español", state: idiomaString == "es" ? .on : .off){ action in
                    self.idiomaString = "es"
                },
                UIAction(title: "Inglés", state: idiomaString == "en" ? .on : .off){ action in
                    self.idiomaString = "en"
                },
                UIAction(title: "Francés", state: idiomaString == "fr" ? .on : .off){ action in
                    self.idiomaString = "fr"
                }
            ])
        idioma.showsMenuAsPrimaryAction = true
        
        //filtro para elegir el año de publicación
        fechaPublicacion.menu = UIMenu(children: self.fechas.map({ fecha in
            return UIAction(title: fecha, state: self.fecha == fecha ? .on : .off){ action in
                    if fecha == "Ninguna"{
                        self.fecha = ""
                    } else{
                        self.fecha = fecha
                    }
                }
            })
        )
        fechaPublicacion.showsMenuAsPrimaryAction = true
    }
}
