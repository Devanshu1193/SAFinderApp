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
    
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self 
    }


}

// MARK: - Extensions
extension ViewController: UITableViewDelegate{
    
}
