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
    
    
    //MARK: didload methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableData()
        registerContentCell()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: initialize methods
    func registerContentCell(){
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
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
        })
    }
    
    //MARK: tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableData?.contentList?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? ListTableViewCell
        cell?.setupView(content:tableData?.contentList?[indexPath.row] ?? "")
        return cell ?? ListTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension;//Choose your custom row height
    }
    
    
}
