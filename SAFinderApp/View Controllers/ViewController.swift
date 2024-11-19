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
        
        tableView.delegate = self
        
        // Create the URL and fetch accommodations
        if let url = createAccommodationURL(){
            fetchAccommodations(from: url)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createDataSnapshot()
    }
    
    // MARK: - Loading the images and accmmodation listings
    func createAccommodationURL() -> URL? {
        // URL string pointing to the JSON API
        let urlString = "https://dsuthar.scweb.ca/ios/newApi.json"
        return URL(string: urlString)
    }
    
    // MARK: - TableView Datasource
    // Diffable data source for handling table view data updates
    lazy var tableDataSource = UITableViewDiffableDataSource<Section, Accommodation>(tableView: tableView) {
        tableView, indexPath, itemIdentifier in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "houseCell", for: indexPath) as! AccommodationTableViewCell
        
        // Check if the accommodation is already stored
        let stored = App.accommodationStore.allHouses.first {
            $0.id == itemIdentifier.id
        }
    
        // Set the accommodation details in the cell
        cell.houseAddress.text = stored?.address ?? itemIdentifier.address
        cell.houseRent.text = "$" + String(format: "%.2f", stored?.rent ?? itemIdentifier.rent)
    
        // Fetch and set the accommodation image
        if let image = itemIdentifier.image {
            cell.houseImageView.setImage(url: image)
        }
        return cell
    }
    
    // MARK: - Snapshot
    // Create a data snapshot for the table view
    func createDataSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Accommodation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(accommodations)
        snapshot.reloadItems(accommodations)
        tableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Fetch Accommodation Listings data from API
    func fetchAccommodations(from url: URL){
        print(url)
        let accommodationTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            if let dataError = error {
                print("Error has occurred - \(dataError.localizedDescription)")
            }else {
                do{
                    // Ensure the received data is not nil
                    guard let someData = data else {
                        return
                    }
                    
                    // Decode the JSON response and populate the movie list
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode([Accommodation].self, from: someData)
                    self.accommodations = downloadedResults
                    
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
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the selected accommodation
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        let selectedAccommodation = accommodations[selectedIndex.row]
        
        // Check if the accommodation is already stored
        let stored = App.accommodationStore.allHouses.first {
            $0.id == selectedAccommodation.id
        }
        
        // Pass the accommodation to the DetailViewController
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.accommodation = stored ?? selectedAccommodation
    }
}

// MARK: - Delegate Methods
extension ViewController: UITableViewDelegate{
    // Handle new row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - A Custom Slide-In Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let initialTransform = CGAffineTransform(translationX: -tableView.bounds.width, y: 0)
        cell.transform = initialTransform
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row),options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}


extension UIImageView {
    // Fetch an image from a URL and set it in the image view
    func setImage(url: String) {
        guard let imageUrl =  URL(string: url) else {
            print("Can't make a url from \(url)")
            return
        }
        
        // Download the image data
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in
            
            // Handle the fetched image data and set it to the image view in the cell
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        imageFetchTask.resume()
    }
}
