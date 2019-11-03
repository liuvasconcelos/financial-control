//
//  BillController.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class BillController: UITableViewController {
    
    var bills  = [Bill]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupTableView()
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .black
    }

    func setupTableView() {
        self.tableView.register(BillCell.self, forCellReuseIdentifier: BillCell.identifier())
    }
    
    func fetchData() {
        bills = [Bill(id: 1, title: "Conta 01", value: 10.0, expireDate: Date() + 1),
                 Bill(id: 2, title: "Conta 02", value: 20.0, expireDate: Date())]
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(BillCell.cellHeight)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BillCell.identifier(), for: indexPath) as? BillCell else {
            return UITableViewCell()
        }
        
        cell.bill = bills[indexPath.row]

        return cell
    }
    
    
}
