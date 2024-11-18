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
        let urlString = "https://dsuthar.scweb.ca/ios/newApi.json"
        return URL(string: urlString)
    }
    
    // MARK: - Datasource Methods and properties
    lazy var tableDataSource = UITableViewDiffableDataSource<Section, Accommodation>(tableView: tableView) {
        tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "houseCell", for: indexPath) as! AccommodationTableViewCell
        
        let stored = App.accommodationStore.allHouses.first {
            $0.id == itemIdentifier.id
        }
    
        cell.houseAddress.text = stored?.address ?? itemIdentifier.address
        cell.houseRent.text = "$" + String(format: "%.2f", stored?.rent ?? itemIdentifier.rent)
    
        // Fetch and set the movie poster image
        if let image = itemIdentifier.image {
            cell.houseImageView.setImage(url: image)
        }
        return cell
    }
    
    
    // Create a data snapshot and apply it to the table view's data source
    func createDataSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Accommodation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(accommodations)
        snapshot.reloadItems(accommodations)
        tableDataSource.apply(snapshot, animatingDifferences: true)
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
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        let selectedAccommodation = accommodations[selectedIndex.row]
        
        let stored = App.accommodationStore.allHouses.first {
            $0.id == selectedAccommodation.id
        }
        
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.accommodation = stored ?? selectedAccommodation
    }
}

// MARK: - Extensions
extension ViewController: UITableViewDelegate{
    // Handle new row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - A Custom Slide in Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let initialTransform = CGAffineTransform(translationX: -tableView.bounds.width, y: 0)
        cell.transform = initialTransform
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row),options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}


extension UIImageView {
    // Custom function to fetch images from a URL and set them in the appropriate cell
    func setImage(url: String) {
        guard let imageUrl =  URL(string: url) else {
            print("Can't make a url from \(url)")
            return
        }
        
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
