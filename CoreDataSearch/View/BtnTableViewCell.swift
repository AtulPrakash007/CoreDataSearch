//
//  BtnTableViewCell.swift
//  CoreDataSearch
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit

protocol BtnDelegate: class {
    func saveBtnDelegate()
}

class BtnTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate: BtnDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        delegate.saveBtnDelegate()
    }
}
