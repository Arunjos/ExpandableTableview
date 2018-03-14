//
//  HomeViewController.swift
//  ExpandableTableView
//
//  Created by user on 12/03/18.
//  Copyright © 2018 Arun's Technologies. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: properties
    @IBOutlet weak var listTableView: UITableView!
    var tableData:TableData?
    let cellReuseIdentifier = "ContentCellIdentifier"
    var indexesOfExpandCells = [Int]()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    //MARK: didload methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableData()
        initializeTableView()
        intializeNotifications()
        addActivityIndicator()
        startActivityIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: initialize methods
    func initializeTableView(){
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    func intializeNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func initializeTableData(){
        let getApiController = GetAPIController(url:"https://baconipsum.com/api/?type=all-meat&paras=20", parameters: nil)
        getApiController.performRequest(completionHandler:{(error, response) in
            if error == nil{
                self.tableData = TableData().getTableContentFromData(tableContentData: response)
                print(self.tableData?.contentList ?? "")
                self.listTableView.reloadData()
            }else{
                print(error ?? "")
            }
            self.stopActivityIndicator()
        })
    }
    
    //MARK: tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableData?.contentList?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? ListTableViewCell
        
        cell?.hideActionHandler = {(index) in
            self.indexesOfExpandCells = self.indexesOfExpandCells.filter{$0 != index}
            let selectedIndexPath = IndexPath(item: index, section: 0)
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        cell?.readMoreActionHandler = {(index) in
            self.indexesOfExpandCells.append(index)
            let selectedIndexPath = IndexPath(item: index, section: 0)
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        
        if self.indexesOfExpandCells.contains(indexPath.row) {
            cell?.setupCellForExpand(listData: tableData ?? TableData(), index:indexPath.row)
        }else{
            cell?.setupCellForCollapse(listData:tableData ?? TableData(), index:indexPath.row)
        }
        return cell ?? ListTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if self.indexesOfExpandCells.contains(indexPath.row){
            return UITableViewAutomaticDimension
        }else{
            return 55
        }
    }
    
    //MARK: activity indicator methods
    func addActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
    }
    
    func startActivityIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    //MARK: device rotation
    @objc func deviceRotated(){
        listTableView.reloadData()
    }
}
