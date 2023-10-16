//
//  PhotosModel.swift
//  LowkeyTestTask
//
//  Created by Saikal Toichueva on 16/10/23.
//

import Foundation

struct PhotosDTO: Encodable {
    let page: Int
    let perPage: Int
}

struct Photos: Decodable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
}

struct Photo: Decodable, Hashable {
    let id: Int
    let width: Int
    let height: Int
    let photographer: String
    let src: PhotoSource
}

extension Photo: Identifiable {}

struct PhotoSource: Decodable, Hashable {
    let original: String
    let medium: String
    let small: String
}
