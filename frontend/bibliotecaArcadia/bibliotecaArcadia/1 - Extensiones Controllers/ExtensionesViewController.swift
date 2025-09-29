//
//  ExtensionesViewController.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 24/5/25.
//

import UIKit
import CoreData

//Para no tener que reescribir las siguientes funciones en todas las pantallas que las vayan a usar, se definen dentro de una extensión de UIViewController y se llaman cuando sea necesario
extension UIViewController {
    //MARK: Iniciar y cerrar la app
    //Función para pasar al menú con el TabBarController desde las pantallas de autenticación (ViewController, LoginViewController y RegistroViewController)
    func abrirApp(token: String, user: User){
        UserDefaults.standard.set(token, forKey: "token") //guardar el token en la memoria de la app. Necesario en LoginViewController y RegistroViewController
        if let userDB = getUserDB(){
            self.updateUserDB(userDB: userDB, user: user) //si ya hay un usuario guardado en CoreData, actualizarlo al iniciar sesión (por si se han cambiado sus datos en otro dispositivo)
        } else {
            self.guardarUser(user: user) //si no hay un usuario en CoreData, se crea uno nuevo
        }
        
        //Redirigir al controlador con el TabBar
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menu = storyboard.instantiateViewController(withIdentifier: "menuController") as! UITabBarController
        menu.modalPresentationStyle = .fullScreen
        self.present(menu, animated: true)
    }
    
    //función para volver a la primera pantalla. Se utiliza al cerrar sesión o eliminar la cuenta
    func cerrarApp(){
        UserDefaults.standard.removeObject(forKey: "token")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "initNavigationController") as! UINavigationController
        login.modalPresentationStyle = .fullScreen
        self.present(login, animated: true)
    }
    
    //MARK: Manejar el usuario guardado en CoreData
    //Guardar un usuario nuevo en la base de datos local del dispositivo
    func guardarUser(user: User){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserDB", in: managedContext)!
        let userDB = NSManagedObject(entity: entity, insertInto: managedContext)
        userDB.setValue(user.id, forKey: "id")
        userDB.setValue(user.nombre, forKey: "nombre")
        userDB.setValue(user.apellidos, forKey: "apellidos")
        userDB.setValue(user.email, forKey: "email")
        userDB.setValue(user.dni, forKey: "dni")
        if user.fecha_nac != nil && user.fecha_nac != ""{
            //Pasar el string recibido de la API a Date y guardar la fecha en CoreData en formato dd/mm/YYYY
            let dateString = self.formatDate(date: user.fecha_nac!)
            userDB.setValue(dateString, forKey: "fecha_nac")
        } else {
            userDB.setValue(user.fecha_nac, forKey: "fecha_nac")
        }
        userDB.setValue(user.telf, forKey: "telf")
        userDB.setValue(user.pfp, forKey: "pfp")
        userDB.setValue(user.id_domicilio, forKey: "id_domicilio")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No se ha podido guardar el usuario. \(error), \(error.userInfo)")
        }
    }
    
    //Conseguir el usuario guardado en el CoreData del dispositivo
    func getUserDB()->UserDB?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDB> = UserDB.fetchRequest()
        do {
            let userDB = try managedContext.fetch(fetchRequest)
            return userDB.first
        } catch let error as NSError {
            print("No se han podido obtener los datos. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //Update de los datos del usuario en CoreData con los datos del usuario devuelto por la API
    func updateUserDB(userDB:UserDB, user:User){
        guard UIApplication.shared.delegate is AppDelegate else { return }
        
        userDB.setValue(user.id, forKey: "id")
        userDB.setValue(user.nombre, forKey: "nombre")
        userDB.setValue(user.apellidos, forKey: "apellidos")
        userDB.setValue(user.email, forKey: "email")
        userDB.setValue(user.dni, forKey: "dni")
        if user.fecha_nac != nil && user.fecha_nac != ""{
            //Pasar el string recibido de la API a Date y guardar la fecha en CoreData en formato dd/mm/YYYY
            let dateString = self.formatDate(date: user.fecha_nac!)
            userDB.setValue(dateString, forKey: "fecha_nac")
        } else {
            userDB.setValue(user.fecha_nac, forKey: "fecha_nac")
        }
        userDB.setValue(user.telf, forKey: "telf")
        userDB.setValue(user.pfp, forKey: "pfp")
        userDB.setValue(user.id_domicilio, forKey: "id_domicilio")
        
        do{
            try userDB.managedObjectContext?.save()
        } catch let error as NSError {
            print("No se ha podido actualizar el usuario al iniciar sesión. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Manejar las notificaciones guardadas en CoreData
    //Conseguir las notificaciones guardadas en coreData
    func getNotifDB()->[NotificacionDB]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NotificacionDB> = NotificacionDB.fetchRequest()
        do {
            let notifs = try managedContext.fetch(fetchRequest)
            return notifs
        } catch let error as NSError {
            print("No se han podido obtener los datos. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //guardar notificaciones en CoreData
    func guardarNotif(notif: Notificacion){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NotificacionDB", in: managedContext)!
        let notifDB = NSManagedObject(entity: entity, insertInto: managedContext)
        notifDB.setValue(notif.id, forKey: "id")
        notifDB.setValue(notif.mensaje, forKey: "mensaje")
        notifDB.setValue(notif.fecha, forKey: "fecha")
        notifDB.setValue(notif.id_libro, forKey: "id_libro")
        notifDB.setValue(notif.portada, forKey: "portada")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No se ha podido guardar la notificación. \(error), \(error.userInfo)")
        }
    }
    
    //borrar notificaciones en CoreData
    func deleteNotif(notif: NotificacionDB){
        let managedContext = notif.managedObjectContext
        managedContext?.delete(notif)
        
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("No se ha podido eliminar el objeto. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Formatear fechas
    //Pasar el string recibido de la API a Date y formatear la fecha para guardarla en CoreData con un formato legible para los campos de formulario en los que se vaya a mostrar
    func formatDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let date = formatter.date(from: date)
        
        let dateString = date?.formatted(date: .numeric, time: .omitted)
        
        return dateString ?? ""
    }
    
    //MARK: Ajustar constraints
    //Ajustar los constraints para modificar el tamaño de los botones según el ancho de la pantalla para las que tienen formularios
    func updateConstraints(constraintLeading: NSLayoutConstraint, constraintTrailing: NSLayoutConstraint){
        if UIScreen.main.bounds.width > 1180{
            constraintLeading.constant = 320
            constraintTrailing.constant = 320
        } else if UIScreen.main.bounds.width >= 960{
            constraintLeading.constant = 220
            constraintTrailing.constant = 220
        } else if UIScreen.main.bounds.width >= 568 {
            constraintLeading.constant = 120
            constraintTrailing.constant = 120
        } else {
            constraintLeading.constant = 24
            constraintTrailing.constant = 24
        }
    }
    
    //Ajustar los constraints para modificar el tamaño de los botones según el ancho de la pantalla para las que no tienen formularios
    func updateConstraintsNoForm(constraintLeading: NSLayoutConstraint, constraintTrailing: NSLayoutConstraint){
        if UIDevice.current.model == "iPad" || UIDevice.current.model == "iPad Simulator" {
            constraintLeading.constant = 40
            constraintTrailing.constant = 40
        } else {
            constraintLeading.constant = 24
            constraintTrailing.constant = 24
        }
    }
    
    //MARK: Ocultar el teclado al tocar el viewController
    func keyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
