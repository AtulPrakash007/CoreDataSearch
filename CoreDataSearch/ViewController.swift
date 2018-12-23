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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var _fetchedResultsController: NSFetchedResultsController<Projects>? = nil

    var fetchedResultsController: NSFetchedResultsController<Projects>
    {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Projects> = Users.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1 //fetch last object
        //        fetchRequest.fetchBatchSize = 60
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
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
        tableView.reloadData()
        PostDataModel.shared.resetAll()
    }
    
    func dataPrint() {
        print(PostDataModel.shared.pName!)
        print(PostDataModel.shared.cName!)
        print(PostDataModel.shared.pDescription!)
        print(PostDataModel.shared.isLocation!)
    }
    
    func validateData() -> Bool {
        guard PostDataModel.shared.pName! == "", PostDataModel.shared.cName! == "",  PostDataModel.shared.pDescription! == "" else {
            return false
        }
        return true
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
        
        if (searchBar.text?.isEmpty)! {
            searchBar.enablesReturnKeyAutomatically = true
        }else {
            searchBar.resignFirstResponder()
            //Search text from core data
            //refresh table view
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if videoTitleSearch {
//            filteredTitle = titleArray.filter({ (text) -> Bool in
//                let tmp: NSString = text.title as NSString
//                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//                return range.location != NSNotFound
//            })
//        }else{
//            filteredUser = profileArray.filter({ (text) -> Bool in
//                let tmp: NSString = text.username as NSString
//                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//                return range.location != NSNotFound
//            })
//        }
//
//        if(filteredTitle.count == 0) || (filteredUser.count == 0){
//            if searchText == "" {
//                searchActive = false;
//            }else{
//                searchActive = true
//            }
//        } else {
//            searchActive = true;
//        }
        
        self.tableView.reloadData()
    }
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
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            let resultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultTableViewCell.self), for: indexPath) as! ResultTableViewCell
            
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
    }
}
