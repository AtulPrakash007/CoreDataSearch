//
//  ViewController.swift
//  CoreDataSearch
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var submitLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var submitButtom: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    var isSearchProject: Bool = true
    var searchActive: Bool = false
    var searchString: String = ""
    var projects = [Projects]()
    
    //MARK: - Core Data Variable
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
            PostDataModel.shared.resetAll()
        } else {
            submitLabel.isHidden = true
            postLabel.isHidden = false
            searchBar.isHidden = true
            topLabel.isHidden = false
            searchBar.text = nil
            searchActive = false
        }
        tableView.reloadData()
    }
    
    func dataPrint() {
        print(PostDataModel.shared.pName!)
        print(PostDataModel.shared.cName!)
        print(PostDataModel.shared.pDescription!)
        print(PostDataModel.shared.isLocation!)
    }
    
    func validateData() -> Bool {
        guard PostDataModel.shared.pName! != "", PostDataModel.shared.cName! != "",  PostDataModel.shared.pDescription! != "" else {
            return false
        }
        return true
    }
    
    func saveData() {
        let project = Projects(context: context)
        project.name = PostDataModel.shared.pName!
        project.company = PostDataModel.shared.cName!
        project.discription = PostDataModel.shared.pDescription!
        project.isLocation = PostDataModel.shared.isLocation!
        
        do {
            try context.save()
            PostDataModel.shared.resetAll()
            tableView.reloadData()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchData() {
        do {
            projects = try context.fetch(Projects.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        print(projects.count)
    }
    
    //MARK: - Button Action
    
    @IBAction func searchAction(_ sender: UIButton) {
        if !isSearchProject {
            isSearchProject = true
            viewSetup()
        }
//        fetchData()
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        guard let firstSubView = searchBar.subviews.first else { return }
        
        firstSubView.subviews.forEach {
            ($0 as? UITextField)?.clearButtonMode = .never
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (searchBar.text?.isEmpty)! {
            searchBar.enablesReturnKeyAutomatically = true
        }else {
            
            //Search text from core data
            //refresh table view
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        
        do {
            let fetchRequest : NSFetchRequest<Projects> = Projects.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", searchText)
            projects = try context.fetch(fetchRequest)
        }
        catch {
            print ("fetch task failed", error)
        }
        
        if(projects.count == 0){
            if searchText == "" {
                searchActive = false;
            }else{
                searchActive = true
            }
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Projects")
//        fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", searchText)
//        projects = try! context.fetch(fetchRequest) as! [Projects]
//        print(projects.count)
//        for project in projects {
//            print(project.name ?? "Nothing")
//        }
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchProject {
            if searchActive {
                return projects.count
            }else {
                return 0
            }
        }else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if isSearchProject {
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            let resultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultTableViewCell.self), for: indexPath) as! ResultTableViewCell
            
            let project = projects[indexPath.row]
            
            resultCell.pNameLabel.text = project.name
            resultCell.cNameLabel.text = project.company
            resultCell.pDescLabel.text = project.discription
            if project.isLocation {
                resultCell.locationLabel.text = "Show location on Map"
            }else {
                resultCell.locationLabel.text = "No location found"
            }
            
            cell = resultCell
        }else {
            tableView.separatorStyle = .none

            let tfCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TFTableViewCell.self), for: indexPath) as! TFTableViewCell
            let tvCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVTableViewCell.self), for: indexPath) as! TVTableViewCell
            let cbCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CBTableViewCell.self), for: indexPath) as! CBTableViewCell
            let btnCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BtnTableViewCell.self), for: indexPath) as! BtnTableViewCell
            
            switch indexPath.row {
            case 0:
                tfCell.headerLabel.text = "Person Name"
                tfCell.textField.text = PostDataModel.shared.pName
                tfCell.textField.placeholder = "Enter Person Name"
                tfCell.textField.tag = indexPath.row
                tfCell.textField.delegate = self
                cell = tfCell
            case 1:
                tfCell.headerLabel.text = "Company"
                tfCell.textField.text = PostDataModel.shared.cName
                tfCell.textField.placeholder = "Enter Company Name"
                tfCell.textField.tag = indexPath.row
                tfCell.textField.delegate = self
                cell = tfCell
            case 2:
                tvCell.textView.delegate = self
                tvCell.textView.text = "Enter Description"
                tvCell.textView.textColor = UIColor.lightGray
                cell = tvCell
            case 3:
                cbCell.delegate = self
                cell = cbCell
            case 4:
                btnCell.delegate = self
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
        
        let kActualText = (textField.text ?? "") + string
        switch textField.tag
        {
        case 0:
            PostDataModel.shared.pName = kActualText
        case 1:
            PostDataModel.shared.cName = kActualText
        default:
            print("It is nothing");
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let kActualText = (textView.text ?? "") + text
        PostDataModel.shared.pDescription = kActualText
        
        return true
    }
    
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.view.endEditing(true);
        return true;
    }
}

//MARK: - CBProtocol

extension ViewController: CBProtocol {
    func cbSelected(_ yes: Bool) {
        print(yes)
        PostDataModel.shared.isLocation = yes
    }
}

//MARK: - BtnDelegate

extension ViewController: BtnDelegate {
    func saveBtnDelegate() {
        print("Save Action")
        dataPrint()
        if validateData() {
            saveData()
        }
    }
}
