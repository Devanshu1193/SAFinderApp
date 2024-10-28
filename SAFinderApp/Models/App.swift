//
//  App.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-10-28.
//

import Foundation

class App {
    public static var accommodationStore: AccommodationStore {
        let store = AccommodationStore()
        store.getHouses()
        return store
    }
}
