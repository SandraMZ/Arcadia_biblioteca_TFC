//
//  GenericResponse.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 17/4/25.
//

import Foundation

struct GenericResponse: Decodable {
    let success: Int
    let message: String
    let validator: Validator?
    let nItems: Int?
    let originalDate: String?
    let extendedDate: String?
}
