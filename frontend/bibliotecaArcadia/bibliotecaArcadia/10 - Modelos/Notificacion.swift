//
//  Notificacion.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 17/4/25.
//

import Foundation

struct Notificacion: Decodable {
    let id: Int
    let mensaje: String
    let fecha: String
    let portada: String?
    let id_usuario: Int
    let id_libro: String
}
