//
//  Accommodation.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-09-24.
//

import Foundation

// Enum representing sections in the DiffableDataSource
enum Section {
    case main
}

// A struct to encapsulate the results from the API response
struct Accommodations: Codable{
    var results: [Accommodation]
}

// A model for individual accommodation details
struct Accommodation: Codable, Hashable{
    var id: Int
    var image: String?
    var address: String
    var rent: Double
    var phone_number: String
    var description: String
}
