//
//  TVTableViewCell.swift
//  CoreDataSearch
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit

class TVTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSetup()
    }

    func cellSetup() {
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
