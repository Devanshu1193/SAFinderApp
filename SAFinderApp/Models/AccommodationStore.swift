//
//  AccommodationStore.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-10-10.
//

import Foundation
import UIKit

class AccommodationStore {
    
    // MARK: - Properties
//    private var watchListMovies = Set<Movie>()
    private var houses: [Accommodation] = []
    
    var numHouses: Int {
        return houses.count
    }
    
    var allHouses: [Accommodation]{
        return houses
    }
    
    // MARK: Get Document Directory Location
    var documentDirectory: URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(path[0])
        return path[0]
    }
    
    func alreadyInList(house: Accommodation) -> Bool {
        if (houses.contains { $0.id == house.id }) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Removing and Adding Movies
    func addNewHouse(house: Accommodation){
        houses.append(house)
        saveHouses()
    }
    
    func removeHouse(house: Accommodation){
        for (index, storedHouse) in houses.enumerated(){
            if storedHouse.id == house.id {
                houses.remove(at: index)
                saveHouses()
                return
            }
        }
    }
    
    
    // MARK: - Persistence
    func save(to url: URL){
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(houses)
            try jsonData.write(to: url)
        } catch {
            print("Error encoding the JSON - \(error.localizedDescription)")
        }
    }
    
    func retrieve(from url: URL){
        do{
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            houses = try jsonDecoder.decode([Accommodation].self, from: jsonData)
        } catch {
            print("Error decoding the JSON - \(error.localizedDescription)")
        }
    }
    
    func saveHouses(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("favHouses.json")
        save(to: fileName)
    }
    
    func getHouses(){
        guard let documentDirectory = documentDirectory else { return }
        let fileURL = documentDirectory.appendingPathComponent("favHouses.json")
        retrieve(from: fileURL)
    }
    
    func fetchImage(withIdentifier id: String) -> UIImage?{
        if let imagePath = documentDirectory?.appendingPathComponent(id), let imageFromDisk = UIImage(contentsOfFile: imagePath.path){
            return imageFromDisk
        }
         return nil
    }
   
    func deleteImage(withIdentifier id: String){
        guard let documentDirectory = documentDirectory else {
            return
        }
        
        let fileName = documentDirectory.appendingPathComponent(id)
        do{
            try FileManager.default.removeItem(at: fileName)
        } catch{
            print("Error deleting - \(error.localizedDescription)")
        }
    }
}
