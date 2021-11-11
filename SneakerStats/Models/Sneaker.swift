//
//  Sneaker.swift
//  SneakerStats
//
//  Created by Kuba Florek on 02/07/2020.
//

import SwiftUI

struct Result: Codable {
    let count: Int
    let results: [sneaker]
}

struct Media: Codable {
    let imageUrl: String?
    let smallImageUrl: String?
    let thumbUrl: String?
    
    var thumb: CGImage?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl, smallImageUrl, thumbUrl
    }
}

struct sneaker: Identifiable, Codable {
    let id: String?
    let brand: String?
    let colorway: String?
    let gender: String?
    let releaseDate: String?
    let retailPrice: Int?
    let styleId: String?
    let shoe: String?
    let name: String?
    let title: String?
    let year: Int?
    var media: Media
}
