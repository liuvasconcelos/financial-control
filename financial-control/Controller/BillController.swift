//
//  BillController.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class BillController: UITableViewController {
    
    var groupedBills = [GroupedBills]()
    
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
        self.tableView.separatorStyle = .none
    }
    
    func fetchData() {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        
        let bill1 = Bill(id: 1, title: "Conta 01", value: 10.0, expireDate: tomorrow, category: "Pessoal", status: "Pago")
        let bill2 = Bill(id: 2, title: "Conta 02", value: 20.0, expireDate: tomorrow, category: "Pessoal", status: "Não pago")
        let bill3 = Bill(id: 3, title: "Conta 03", value: 10.0, expireDate: tomorrow, category: "Pessoal", status: "Não pago")
        let bill4 = Bill(id: 4, title: "Conta 04", value: 10.0, expireDate: Date(), category: "Pessoal", status: "Pago")
        let bill5 = Bill(id: 5, title: "Conta 05", value: 10.0, expireDate: Date(), category: "Pessoal", status: "Não pago")
        let bill6 = Bill(id: 6, title: "Conta 06", value: 10.0, expireDate: yesterday, category: "Pessoal", status: "Não pago")

        let groupedBills1 = GroupedBills(date:  tomorrow,
                                         bills: [bill1, bill2, bill3].map({ return BillViewModel(bill: $0)}))
        let groupedBills2 = GroupedBills(date:  Date(),
                                         bills: [bill4, bill5].map({ return BillViewModel(bill: $0)}))
        let groupedBills3 = GroupedBills(date:  yesterday,
                                         bills: [bill6].map({ return BillViewModel(bill: $0)}))
        
        groupedBills = [groupedBills1, groupedBills2, groupedBills3].sorted(by: { $0.date < $1.date })
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedBills[section].bills.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedBills.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let billHeader = BillHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: BillHeader.headerHeight))
        billHeader.configureHeader(date: groupedBills[section].date)
        
        return billHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BillHeader.headerHeight
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(BillCell.cellHeight)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BillCell.identifier(), for: indexPath) as? BillCell else {
            return UITableViewCell()
        }
        
        cell.billViewModel = groupedBills[indexPath.section].bills[indexPath.row]

        return cell
    }
    
}
