//
//  CBTableViewCell.swift
//  CoreDataSearch
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit

protocol CBProtocol: class {
    func cbSelected(_ yes: Bool)
}

class CBTableViewCell: UITableViewCell {
    @IBOutlet weak var cbButton: UIButton!
    weak var delegate: CBProtocol!
    var cbSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSetup()
    }

    func cellSetup() {
        cbButton.layer.borderColor = UIColor.gray.cgColor
        cbButton.layer.borderWidth = 1
        cbButton.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cbAction(_ sender: UIButton) {
        cbSelected = !cbSelected
        
        if cbSelected {
            cbButton.backgroundColor = UIColor.gray
        }else {
            cbButton.backgroundColor = UIColor.clear
        }
        
        delegate.cbSelected(cbSelected)
    }
    
}
