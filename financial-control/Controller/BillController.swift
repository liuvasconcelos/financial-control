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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Adicionar", style: .plain, target: self, action: #selector(openAddButtonScreen))
        navigationItem.rightBarButtonItem?.tintColor = .white
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BillController.handleModalDismissed),
                                               name: NSNotification.Name(rawValue: "modalIsDimissed"),
                                               object: nil)
    }
    
    @objc func handleModalDismissed() {
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "logoBlue")
        
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "Passivos"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    func setupTableView() {
        self.tableView.register(BillCell.self, forCellReuseIdentifier: BillCell.identifier())
        self.tableView.separatorStyle  = .none
        self.tableView.backgroundColor = UIColor(named: "veryLightGray")
        self.tableView.allowsSelection = false
    }
    
    @objc func openAddButtonScreen() {
        let addBillVC = AddBillController()
        
        if #available(iOS 13.0, *) {
            self.present(addBillVC, animated: true, completion: nil)
        } else  {
            self.navigationController?.pushViewController(addBillVC, animated: true)
        }
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
    
    fileprivate func showError(message: String = "Ocorreu algum erro ao tentar acessar as contas.", toReload: Bool = true) {
        let alert  = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: toReload ? "Cancelar" : "Ok", style: .cancel, handler: nil)
        let reload = UIAlertAction(title: "Recarregar", style: .default) { (_) in
            self.fetchData()
        }
        
        alert.addAction(cancel)
        if toReload { alert.addAction(reload) }
        
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
            let addBillVC = AddBillController()
            addBillVC.currentBill = self.groupedBills[indexPath.section].bills[indexPath.row]
            if #available(iOS 13.0, *) {
                self.present(addBillVC, animated: true, completion: nil)
            } else  {
                self.navigationController?.pushViewController(addBillVC, animated: true)
            }
        }
        
        action.backgroundColor = .orange
        return action
    }
    
    fileprivate func deleteBill(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
       let action = UIContextualAction(style: .normal,
                                       title: "Deletar") { (contextAction: UIContextualAction,
                                                            sourceView: UIView,
                                                            completionHandler: (Bool) -> Void) in
            let alert = UIAlertController(title:   "Deletar conta",
                                         message: "Tem certeza que deseja deletar esta conta?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Deletar", style: .destructive) { (_) in
                self.delete(bill: self.groupedBills[indexPath.section].bills[indexPath.row] )
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
       }
       
       action.backgroundColor = .red
       return action
    }
    
    fileprivate func delete(bill: BillViewModel) {
        apiDataSource.deleteBillWith(id: bill.id) { (callback) in
            callback.onSuccess { (_) in
                self.fetchData()
            }
            callback.onFailed { (_) in
                self.showError(message: "Ocorreu algum erro ao tentar excluir.", toReload: false)
            }
        }
    }
    
    fileprivate func undoPaymentOfBill(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
       let action = UIContextualAction(style: .normal,
                                       title: "Desfazer") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
           let bill = self.groupedBills[indexPath.section].bills[indexPath.row]
           self.apiDataSource.changeStatus(id: bill.id, status: "Não Pago") { (callback) in
               callback.onSuccess { (_) in
                   self.fetchData()
               }
               callback.onFailed { (_) in
                   self.showError(message: "Ocorreu algum erro ao tentar desfazer pagamento.", toReload: false)
               }
            }
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
            let bill = self.groupedBills[indexPath.section].bills[indexPath.row]
            self.apiDataSource.changeStatus(id: bill.id, status: "Pago") { (callback) in
                callback.onSuccess { (_) in
                    self.fetchData()
                }
                callback.onFailed { (_) in
                    self.showError(message: "Ocorreu algum erro ao tentar pagar.", toReload: false)
                }
             }
        }
        
        action.backgroundColor = UIColor(named: "darkBlue")
        return action
    }

}
