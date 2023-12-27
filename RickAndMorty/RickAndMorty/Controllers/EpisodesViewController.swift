//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Fernando Gutiérrez on 26/12/23.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    @IBOutlet weak var episodeTableView: UITableView! {
        didSet {
            episodeTableView.register(UINib(nibName: "EpisodeCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var episodePageLabel: UILabel!
    
    var numberPage: Int = 1
    
    let restClient = RESTClient<PaginaterResponse<Episode>>(client: Client("https://rickandmortyapi.com"))
    
    var episodes: [Episode]? {
        didSet {
            episodeTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        episodeTableView.dataSource = self
        episodeTableView.delegate = self
        episodePageLabel.text = "Page: \(numberPage)"
        restClient.show("/api/episode",page: "1") { response in
            print(response.results)
            self.episodes = response.results
        }
    }
    
    @IBAction func previousEpisodePagePressed(_ sender: UIButton) {
        numberPage -= 1
        if numberPage == 0{
            numberPage = 1
        }
        let page = String(numberPage)
        restClient.show("/api/episode", page: page) { response in
            self.episodes = response.results
        }
        episodePageLabel.text = "Page: \(numberPage)"
    }
    
    @IBAction func nextEpisodePagePressed(_ sender: UIButton) {
        numberPage += 1
        if numberPage > 3 {
            numberPage = 1
        }
        let page = String(numberPage)
        restClient.show("/api/episode", page: page) { response in
            self.episodes = response.results
        }
        episodePageLabel.text = "Page: \(numberPage)"
    }
    
}

extension EpisodesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? EpisodeCustomTableViewCell
        
        cell?.episodeNameLabel.text = "Name: " + (episodes?[indexPath.row].name ?? "unknown")
        cell?.episodeAirLabel.text = "Date: " + (episodes?[indexPath.row].air_date ?? "unknown")
        cell?.episodeCodeLabel.text = "Ep. Code: " + (episodes?[indexPath.row].episode ?? "unknown")
        
        return cell!
    }
    
    
}

extension EpisodesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
