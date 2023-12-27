//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import UIKit

class CharacterViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "CharacterCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    }
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

extension CharacterViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CharacterCustomTableViewCell
        
        cell?.characterNameLabel.text = "Name: " + (characters?[indexPath.row].name ?? "")
        cell?.characterStatusLabel.text = "Status: " + (characters?[indexPath.row].status ?? "")
        cell?.characterSpeciesLabel.text = "Specie: " + (characters?[indexPath.row].species ?? "")
        cell?.characterGenderLabel.text = "Gender: " + (characters?[indexPath.row].gender ?? "")
        
        // Image
        if let urlString = characters?[indexPath.row].image as? String {
            if let imageURL = URL(string: urlString) {
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell?.characterImage.image = image
                    }
                }
            }
        }
        
        return cell!
    }
}

extension CharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


