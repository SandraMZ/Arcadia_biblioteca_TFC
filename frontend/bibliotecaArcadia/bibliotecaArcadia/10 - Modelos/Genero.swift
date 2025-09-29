//
//  Generos.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 18/4/25.
//

import Foundation

struct Genero: Decodable {
    let id: Int
    let nombre: String
}

struct Subgenero: Decodable {
    let id: Int
    let nombre: String
    let id_genero: Int
}
