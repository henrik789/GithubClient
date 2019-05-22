//
//  UserTableViewCell.swift
//  GithubClient
//
//  Created by Henrik on 2019-05-22.
//  Copyright © 2019 Henrik. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static var identifier: String {
        return "UserTableViewCell"
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
