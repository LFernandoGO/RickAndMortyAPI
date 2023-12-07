//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberPageLabel: UILabel!
    
    var numberPage: Int = 1
    
    let restClient = RESTClient<PaginaterResponse<Character>>(client: Client("https://rickandmortyapi.com"))
    
    var characters: [Character]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        numberPageLabel.text = "Page: \(numberPage)"
        restClient.show("/api/character",page: "1") { response in
            //print(response.results)
            self.characters = response.results
        }
       
    }
    
    
    @IBAction func backPageButtonAction(_ sender: UIButton) {
        numberPage -= 1
        if numberPage == 0{
            numberPage = 1
        }
        let page = String(numberPage)
        restClient.show("/api/character", page: page) { response in
            self.characters = response.results
        }
        numberPageLabel.text = "Page: \(numberPage)"
    }
    
    @IBAction func nextPageButtonAction(_ sender: UIButton) {
        numberPage += 1
        if numberPage > 42 {
            numberPage = 1
        }
        let page = String(numberPage)
        restClient.show("/api/character", page: page) { response in
            self.characters = response.results
        }
        numberPageLabel.text = "Page: \(numberPage)"
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = characters?[indexPath.row].name
        cell.detailTextLabel?.text = characters?[indexPath.row].species
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


