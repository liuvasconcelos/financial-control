//
//  BillController.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class BillController: UITableViewController {
    
    var groupedBills  = [GroupedBills]()
    let apiDataSource = BillApiDataSource.getInstance()
    
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
        apiDataSource.getAllBills { (callback) in
            callback.onSuccess { (response) in
                self.mapResponse(bills: response.bills ?? [])
            }
            callback.onFailed { (_) in
                self.showError()
            }
        }
    }
    
    fileprivate func mapResponse(bills: [Bill]) {
        let orderedBills = bills.sorted(by: { $0.expireDate.toDate() < $1.expireDate.toDate() })
        
        var organizingGroupedBills = [GroupedBills]()
        
        for bill in orderedBills {
            let expiredDate = bill.expireDate.toDate()
            
            let currentDates = organizingGroupedBills.map({ $0.date })
            
            if currentDates.contains(expiredDate) {
                let foundGroup = organizingGroupedBills.filter { (group) -> Bool in
                    group.date == expiredDate
                }.first
                
                organizingGroupedBills.removeAll { (group) -> Bool in
                    group.date == expiredDate
                }
                
                var currentBills = foundGroup?.bills ?? []
                currentBills.append(BillViewModel(bill: bill))
                organizingGroupedBills.append(GroupedBills(date:  expiredDate,
                                                           bills: currentBills))
            } else {
                organizingGroupedBills.append(GroupedBills(date:  expiredDate,
                                                           bills: [BillViewModel(bill: bill)]))
            }
        }

        groupedBills = organizingGroupedBills.sorted(by: { $0.date < $1.date })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    fileprivate func showError() {
        let alert  = UIAlertController(title: "Erro", message: "Ocorreu algum erro ao tentar acessar as contas.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let reload = UIAlertAction(title: "Recarregar", style: .default) { (_) in
            self.fetchData()
        }
        
        alert.addAction(cancel)
        alert.addAction(reload)
        
        self.present(alert, animated: true, completion: nil)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentBillIsNotPayed = groupedBills[indexPath.section].bills[indexPath.row].statusColor != .green
        let editAction            = editBill(forRowAtIndexPath: indexPath)
        let deleteAction          = deleteBill(forRowAtIndexPath: indexPath)
        let undoPayment           = undoPaymentOfBill(forRowAtIndexPath: indexPath)
        
        return currentBillIsNotPayed ? UISwipeActionsConfiguration(actions: [editAction, deleteAction]) : UISwipeActionsConfiguration(actions: [undoPayment])
    }
    
    fileprivate func editBill(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal,
                                        title: "Editar") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            print("EDITAR_____________________")
            // Open edit screen
        }
        
        action.backgroundColor = .orange
        return action
    }
    
    fileprivate func deleteBill(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
       let action = UIContextualAction(style: .normal,
                                       title: "Deletar") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
           print("DELETAR ___________________")
           // Open delete alert
       }
       
       action.backgroundColor = .red
       return action
    }
    
    fileprivate func undoPaymentOfBill(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
       let action = UIContextualAction(style: .normal,
                                       title: "Desfazer") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
           print("DESFAZR ___________________")
           // Open undo alert
       }
       
       action.backgroundColor = .red
       return action
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentBillIsNotPayed = groupedBills[indexPath.section].bills[indexPath.row].statusColor != .green
        let payAction             = payBill(forRowAtIndexPath: indexPath)
        
        return currentBillIsNotPayed ? UISwipeActionsConfiguration(actions: [payAction]) : nil
    }

    fileprivate func payBill(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal,
                                        title: "Pagar") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            print("PAGAR_____________________")
            // Open pay alert
        }
        
        action.backgroundColor = .blue
        return action
    }
}
