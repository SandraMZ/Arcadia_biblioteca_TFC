//
//  SubgenerosViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 18/4/25.
//

import UIKit

class SubgenerosViewController: UIViewController {
    //outlets para la tabla
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    
    //Vista a la que aplicarle sombra
    @IBOutlet weak var viewShadow: UIView!
    
    //constraints para ajustar los elementos según el dispositivo
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    var subgeneros: [Subgenero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y DataSource del TableView
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        //Añadir estilos al View que rodea la tabla
        viewShadow.layer.cornerRadius = 10
        viewShadow.addShadow()
        tableview.layer.cornerRadius = 10
        self.changeHeight()
        
        //Modificar los constraints según el dispositivo
        updateConstraintsNoForm(constraintLeading: constraintLeading, constraintTrailing: constraintTrailing)
    }
}

extension SubgenerosViewController {
    //Cambiar el tamaño de la tabla dependiendo del número de elementos que tenga
    func changeHeight(){
        tableview.rowHeight = 50
        tableviewHeightConstraint.constant = tableview.rowHeight * CGFloat(subgeneros.count + 1)
    }
}

//TableView para listar todos los subgéneros de un género
extension SubgenerosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subgeneros.count + 1 //se le añade una celda más para la opción de "Todo", que equivale a elegir todos los libros del género, sin filtrar por subgéneros
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaSubgenero", for: indexPath)
                
        var content = cell.defaultContentConfiguration()
        //La primera celda siempre tiene la opción de Todo. Las demás celdas se rellenan con los elementos del array
        if indexPath.row == 0 {
            content.text = "Todo"
        } else {
            content.text = self.subgeneros[indexPath.row-1].nombre
        }
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Si se pulsa la primera celda, se filtran los libros por el género
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultadosViewController") as! ResultadosViewController
            resultsVC.title = "Resultados"
            resultsVC.idGenero = self.subgeneros[0].id_genero
            self.navigationController?.pushViewController(resultsVC, animated: true)
        } else {
            //Si se pulsa cualquier otra celda, se filtran los libros por el subgénero elegido
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultadosViewController") as! ResultadosViewController
            resultsVC.title = "Resultados"
            resultsVC.idSubgenero = self.subgeneros[indexPath.row-1].id
            self.navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
}
