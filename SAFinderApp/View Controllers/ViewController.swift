//
//  ViewController.swift
//  SAFinderApp
//
//  Created by Devanshu Suthar on 2024-09-19.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var accommodations : [Accommodation] = []
    
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self 
    }
    
    // MARK: - Loading the images and accmmodation listings
    func createAccommodationURL(from searchString: String) -> URL? {
        var urlString = "https://dsuthar.scweb.ca/ios/api.json"
        return URL(string: urlString)
    }
    
    // MARK: - Datasource Methods and properties
    
    
    
    // Create a data snapshot and apply it to the table view's data source
    func createDataSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Accommodation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(accommodations)
        
    }
    
    // MARK: - Fetch Accommodation Listings from API
    func fetchAccommodations(from url: URL){
        print(url)
        let accommodationTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            if let dataError = error {
                print("Error has occurred - \(dataError.localizedDescription)")
            }else {
                do{
                    guard let someData = data else {
                        return
                    }
                    
                    // Decode the JSON response and populate the movie list
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode(Accommodations.self, from: someData)
                    self.accommodations = downloadedResults.results
                    
                    // Update the UI with the fetched movies
                    DispatchQueue.main.async {
                        self.createDataSnapshot()
                    }
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("\(value) wasn't found. \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(let context) {
                    print("data is corrupted. \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let value, let context) {
                    print("type mismatch with \(value). \(context.debugDescription)")
                } catch DecodingError.keyNotFound(let value, let context) {
                    print("No key found for \(value). \(context.debugDescription)")
                }catch{
                    print("A decoding error has occurred \(error.localizedDescription)")
                }
                
            }
        }
        accommodationTask.resume()
    }


}

// MARK: - Extensions
extension ViewController: UITableViewDelegate{
    
}
