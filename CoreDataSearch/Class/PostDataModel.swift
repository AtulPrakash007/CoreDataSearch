//
//  PostDataModel.swift
//  CoreDataSearch
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit

class PostDataModel: NSObject {
    var pName: String!
    var cName: String!
    var pDescription: String!
    var isLocation: Bool!
    
    static let shared = PostDataModel()
    
    override init() {
        self.pName = ""
        self.cName = ""
        self.pDescription = ""
        self.isLocation = false
    }
    
    func resetAll(){
        self.pName = ""
        self.cName = ""
        self.pDescription = ""
        self.isLocation = false
    }
}

struct SearchDataModel {
    var pName: String = ""
    var cName: String = ""
    var pDescription: String = ""
    var isLocation: Bool
}
