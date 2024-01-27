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
    
    var numberPage: Int = 1
    
    let restClient = RESTClient<PaginaterResponse<Character>>(client: Client("https://rickandmortyapi.com"))
    
    var characters: [Character]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isLoadingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        restClient.show("/api/character",page: "1") { response in
            //print(response.results)
            self.characters = response.results
        }
       
    }
    
    func loadMoreData() {
        guard !isLoadingData else {
            return
        }

        isLoadingData = true
        let nextPage = numberPage + 1
        let page = String(nextPage)
        restClient.show("/api/character", page: page) { response in
            self.characters?.append(contentsOf: response.results)
            self.tableView.reloadData()
            self.numberPage = nextPage
            self.isLoadingData = false
        }
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

extension CharacterViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndexPath = indexPaths.last else {
            return
        }

        let lastIndex = lastIndexPath.row
        let totalRows = tableView.numberOfRows(inSection: 0)

        // Verifica si el último índice prefetch coincide con el último índice de la tabla
        if lastIndex == totalRows - 1 {
            loadMoreData()
        }
    }
}


