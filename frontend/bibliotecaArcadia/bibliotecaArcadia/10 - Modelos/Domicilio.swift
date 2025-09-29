//
//  File.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 13/4/25.
//

import Foundation

struct ResDomicilio: Decodable {
    let success: Int
    let message: String
    let address: Domicilio?
}
struct Domicilio: Decodable {
    let id: Int
    let id_usuario: Int
    let direccion: String
    let piso: String?
    let puerta: String?
    let provincia: String
    let localidad: String
    let cod_postal: String
}
