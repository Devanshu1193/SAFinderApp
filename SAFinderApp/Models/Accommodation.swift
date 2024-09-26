//
//  Accommodation.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-09-24.
//

import Foundation

enum Section {
    case main
}

struct Accommodations: Codable{
    var results: [Accommodation]
}

struct Accommodation: Codable, Hashable{
    var id: Int
    var image: String?
    var address: String
    var rent: Double
    var phone_number: String
    var description: String
    
//    func getImage() -> String? {
//        if image == nil {
//            return nil
//        }
//        return "https://dsuthar.scweb.ca/ios/api.json?\(image!)"
//    }
}
