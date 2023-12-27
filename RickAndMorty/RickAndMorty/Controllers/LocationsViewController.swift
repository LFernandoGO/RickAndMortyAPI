//
//  LocationsViewController.swift
//  RickAndMorty
//
//  Created by Fernando Gutiérrez on 26/12/23.
//

import UIKit

class LocationsViewController: UIViewController {
    
    @IBOutlet weak var locationsTableView: UITableView! {
        didSet {
            locationsTableView.register(UINib(nibName: "LocationCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var locationsPageLabel: UILabel!
    
    var numberPage: Int = 1
    
    let restClient = RESTClient<PaginaterResponse<Location>>(client: Client("https://rickandmortyapi.com"))
    
    var locations: [Location]? {
        didSet {
            locationsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
        locationsPageLabel.text = "Page: \(numberPage)"
        restClient.show("/api/location",page: "1") { response in
            print(response.results)
            self.locations = response.results
        }
    }
    
    @IBAction func previousPageButtonPressed(_ sender: UIButton) {
        numberPage -= 1
        if numberPage == 0{
            numberPage = 1
        }
        let page = String(numberPage)
        restClient.show("/api/location", page: page) { response in
            self.locations = response.results
        }
        locationsPageLabel.text = "Page: \(numberPage)"
    }
    
    @IBAction func nextPageButtonPressed(_ sender: UIButton) {
        numberPage += 1
        if numberPage > 7 {
            numberPage = 1
        }
        let page = String(numberPage)
        restClient.show("/api/location", page: page) { response in
            self.locations = response.results
        }
        locationsPageLabel.text = "Page: \(numberPage)"
    }
    
}

extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LocationCustomTableViewCell
        
        cell?.locationNameLabel.text = "Name: " + (locations?[indexPath.row].name ?? "")
        cell?.locationTypeLabel.text = "Type: " + (locations?[indexPath.row].type ?? "")
        cell?.locationDimensionLabel.text = "Dimension: " + (locations?[indexPath.row].dimension ?? "")
        
        return cell!
    }
    
    
}

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
