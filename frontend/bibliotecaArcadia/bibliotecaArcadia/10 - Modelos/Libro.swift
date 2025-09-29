//
//  File.swift
//  bibliotecaArcadia
//
//  Created by Sandra MZ on 16/4/25.
//

import Foundation

enum Encuadernacion: String, Decodable {
    case tapaDura = "Tapa dura";
    case tapaBlanda = "Tapa blanda";
    case deBolsillo = "De bolsillo";
    case vacio = "";
}

struct ResLibro: Decodable {
    let devolucion: String?
    let cod_pedido: String?
    let libro: Libro
    let autores: [Autor]
}

struct ResLibroID: Decodable {
    let success: Int
    let message: String
    let status: Int?
    let received: Int?
    let onWishlist: Int?
    let onWaitingList: Int?
    let book: Libro?
    let authors: [Autor]?
    let otherBooks: [ResLibro]?
    let genres: [Genero]?
    let subgenres: [Subgenero]?
}

struct Libro: Decodable {
    let id: String
    let titulo: String
    let subtitulo: String?
    let editorial: String?
    let isbn_13: String
    let idioma: String
    let n_paginas: Int
    let publicacion: String
    let descripcion: String
    let encuadernacion: Encuadernacion?
    let imagen: String?
    let disponibles: Int
    let prestados: Int
}

struct Autor: Decodable {
    let id: Int
    let nombre: String
}
