//
//  BusquedaViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 18/4/25.
//

import UIKit

class BusquedaViewController: UIViewController {
    @IBOutlet weak var textfieldBusqueda: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    //constraints para ajustar el formulario de búsqueda al ancho de la pantalla
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    
    var arrayBusquedas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegate y DataSource del TableView
        tableview.delegate = self
        tableview.dataSource = self
        
        //Modificar los constraints del botón según el ancho de la pantalla
        self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
    }
    
    //Modificar los constraints al girar la pantalla
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraints(constraintLeading: self.constraintLeading, constraintTrailing: self.constraintTrailing)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Obtener el array de las búsquedas anteriores de UserDefaults
        arrayBusquedas = UserDefaults.standard.stringArray(forKey: "busquedasAnteriores") ?? []
        tableview.reloadData() //recargar la tabla
        
        //Definir el Delegate del TextField
        self.defineTextFieldsDelegate()
    }
    
    @IBAction func search(_ sender: Any) {
        //Hacer la búsqueda si el campo de búsqueda no está vacío
        if textfieldBusqueda.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            goToResults()
        }
    }
}

extension BusquedaViewController {
    //ir a la pantalla de los resultados
    func goToResults() {
        //Guardar en el array la búsqueda nueva. Si ya estaba en el array, se pasa a la primera posición
        if !arrayBusquedas.contains(textfieldBusqueda.text!) {
            arrayBusquedas.insert(textfieldBusqueda.text!, at: 0)
            UserDefaults.standard.set(arrayBusquedas, forKey: "busquedasAnteriores")
        } else {
            arrayBusquedas.removeAll { $0 == textfieldBusqueda.text! }
            arrayBusquedas.insert(textfieldBusqueda.text!, at: 0)
            UserDefaults.standard.set(arrayBusquedas, forKey: "busquedasAnteriores")
        }
        
        //Navegar a la pantalla de resultados
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultadosViewController") as! ResultadosViewController
        resultsVC.title = "Resultados"
        resultsVC.busqueda = textfieldBusqueda.text!
        textfieldBusqueda.text = ""
        self.navigationController?.pushViewController(resultsVC, animated: true)
    }
}

//Delegado de los TextFields
extension BusquedaViewController: UITextFieldDelegate {
    func defineTextFieldsDelegate(){
        view.textFieldsInView.forEach{ $0.delegate = self }
    }
    
    //Hacer la búsqueda al hacer intro en el TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textfieldBusqueda.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            goToResults()
        }
        
        return true
    }
}

//Tabla para mostrar las búsquedas anteriores
extension BusquedaViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Se pueden mostrar un máximo de 7 búsquedas anteriores
        if arrayBusquedas.count > 7 {
            return 7
        } else {
            return arrayBusquedas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaSearch", for: indexPath) as! CeldaBusquedaTableViewCell
        cell.lblSearch.text = arrayBusquedas[indexPath.row]
        return cell
    }
    
    //Al pulsar sobre una celda, ir a la pantalla de resultados
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Pasar la búsqueda elegida a la primera posición
        let busqueda = arrayBusquedas[indexPath.row]
        arrayBusquedas.removeAll { $0 == busqueda }
        arrayBusquedas.insert(busqueda, at: 0)
        UserDefaults.standard.set(arrayBusquedas, forKey: "busquedasAnteriores")
        
        //ir a la pantalla de resultados
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultadosViewController") as! ResultadosViewController
        resultsVC.title = "Resultados"
        resultsVC.busqueda = busqueda
        textfieldBusqueda.text = ""
        self.navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    //Eliminar una búsqueda anterior del array al hacer swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar"){ (action, sourceView, completionHandler) in
            self.arrayBusquedas.remove(at: indexPath.item)
            UserDefaults.standard.set(self.arrayBusquedas, forKey: "busquedasAnteriores")
            
            self.tableview.reloadData()
            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(red: 249/255, green: 112/255, blue: 88/255, alpha: 1.0)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}
