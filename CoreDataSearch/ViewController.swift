//
//  ViewController.swift
//  CoreDataSearch
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var submitLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var submitButtom: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    var isSearchProject: Bool = true
    var isSearchOn: Bool = false
    
    //MARK: - View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        registerTableViewCell()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Custom Function
    
    func registerTableViewCell() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: String(describing: TFTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TFTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: TVTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TVTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: CBTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CBTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: BtnTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BtnTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ResultTableViewCell.self))
        
    }
    
    func viewSetup() {
        if isSearchProject {
            submitLabel.isHidden = false
            postLabel.isHidden = true
            searchBar.isHidden = false
            topLabel.isHidden = true
        } else {
            submitLabel.isHidden = true
            postLabel.isHidden = false
            searchBar.isHidden = true
            topLabel.isHidden = false
        }
    }
    
    //MARK: - Button Action
    
    @IBAction func searchAction(_ sender: UIButton) {
        if !isSearchProject {
            isSearchProject = true
            viewSetup()
        }
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        if isSearchProject {
            isSearchProject = false
            viewSetup()
        }
    }
}

//MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchProject {
            return 0
        }else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if isSearchProject {
            let resultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultTableViewCell.self), for: indexPath) as! ResultTableViewCell
            
            cell = resultCell
        }else {
            let tfCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TFTableViewCell.self), for: indexPath) as! TFTableViewCell
            let tvCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVTableViewCell.self), for: indexPath) as! TVTableViewCell
            let cbCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CBTableViewCell.self), for: indexPath) as! CBTableViewCell
            let btnCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BtnTableViewCell.self), for: indexPath) as! BtnTableViewCell
            
            switch indexPath.row {
            case 0:
                tfCell.headerLabel.text = "Person Name"
                tfCell.textField.placeholder = "Enter Person Name"
                tfCell.textField.tag = indexPath.row
                tfCell.textField.delegate = self
                cell = tfCell
            case 1:
                tfCell.headerLabel.text = "Company"
                tfCell.textField.placeholder = "Enter Company Name"
                tfCell.textField.tag = indexPath.row
                tfCell.textField.delegate = self
                cell = tfCell
            case 2:
                tvCell.textView.delegate = self
                
                cell = tvCell
            case 3:
                
                cell = cbCell
            case 4:
                
                cell = btnCell
            default:
                print("No Any Cell; Error Occured")
            }
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.view.endEditing(true);
        return true;
    }
}
