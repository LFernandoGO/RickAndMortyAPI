//
//  EpisodeCustomTableViewCell.swift
//  RickAndMorty
//
//  Created by Fernando Gutiérrez on 26/12/23.
//

import UIKit

class EpisodeCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeAirLabel: UILabel!
    @IBOutlet weak var episodeCodeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
