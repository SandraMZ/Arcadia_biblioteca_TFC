//
//  UserResponse.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 9/4/25.
//

import Foundation

struct UserResponse: Decodable {
    let success: Int
    let message: String
    let validator: Validator?
    let token: String?
    let user: User?
    let address: Domicilio?
    let photo: String?
}

struct SanctionedResponse: Decodable {
    let sanctioned: Int
    let message: String
    let late_loans: [String]
}

struct Validator: Decodable {
    let nombre: [String]?
    let apellidos: [String]?
    let email: [String]?
    let password: [String]?
    let url: [String]?
    let telf: [String]?
    let fechaNac: [String]?
    let dni: [String]?
    let anteriorPass: [String]?
    let nuevaPass: [String]?
    let nuevaPass_confirmation: [String]?
    let direccion: [String]?
    let provincia: [String]?
    let localidad: [String]?
    let codPostal: [String]?
}

struct User: Decodable {
    let id: Int
    let nombre: String
    let apellidos: String
    let email: String
    let dni: String?
    let fecha_nac: String?
    let telf: String?
    let pfp: String?
    let id_domicilio: Int?
}
