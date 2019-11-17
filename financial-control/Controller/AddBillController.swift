//
//  AddBillController.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 17/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class AddBillController: UIViewController {
    
    var currentBill: BillViewModel?
    
    let screenTitle   = UILabel()
    let titleLabel    = UILabel()
    let valueLabel    = UILabel()
    let categoryLabel = UILabel()
    let dateLabel     = UILabel()
    
    let titleTextField    = UITextField()
    let valueTextField    = UITextField()
    let categoryTextField = UITextField()
    let dateTextField     = UITextField()
    
    let addButton = UIButton()
    
    let apiDataSource = BillApiDataSource.getInstance()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .yellow
        self.addLayout()
        self.addTouch()
    }
    
    fileprivate func addTouch() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(touch)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func addLayout() {
        self.anchorLabel(label: screenTitle, order: 0, text: "Cadastro de contas")
        self.anchorLabel(label: titleLabel, order: 1, text: "Título:")
        self.anchorLabel(label: valueLabel, order: 2, text: "Valor:")
        self.anchorLabel(label: categoryLabel, order: 3, text: "Categoria:")
        self.anchorLabel(label: dateLabel, order: 4, text: "Data de vencimento:")

        self.anchorTextField(field: titleTextField, order: 0)
        self.anchorTextField(field: valueTextField, order: 1, numeric: true)
        self.anchorTextField(field: categoryTextField, order: 2)
        self.anchorTextField(field: dateTextField, order: 3)
        
        if let bill = currentBill {
            self.fillWithEditionInformation(bill: bill)
        }
        self.addAccount()
    }
    
    fileprivate func anchorLabel(label: UILabel, order: CGFloat, text: String) {
        view.addSubview(label)
        label.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: 30 + (order * 60), left: 16, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 32, height: 30))
        label.text = text
    }
    
    fileprivate func anchorTextField(field: UITextField, order: CGFloat, numeric: Bool = false) {
        view.addSubview(field)
        field.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: 120 + (order * 60), left: 16, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 32, height: 30))
        field.keyboardType    = numeric ? .decimalPad : .default
        field.backgroundColor = .green
    }
    
    fileprivate func addAccount() {
        view.addSubview(addButton)
        addButton.backgroundColor = .blue
        addButton.setTitle("Salvar", for: .normal)
        addButton.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16),
                         size:    CGSize(width: 0, height: 16))
        addButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc func save() {
        let billToSave = Bill(id:         currentBill != nil ? currentBill?.id ?? 0 : 0,
                              title:      titleTextField.text ?? "",
                              value:      Double(valueTextField.text ?? "") ?? 0,
                              expireDate: dateTextField.text ?? "",
                              category:   categoryTextField.text ?? "",
                              status:     currentBill != nil ? currentBill?.status ?? "" : "")
        
        apiDataSource.saveAccount(bill: billToSave,
                                  edition: currentBill != nil) { (callback) in
            callback.onSuccess { (_) in
                DispatchQueue.main.async {
                    if #available(iOS 13.0, *) {
                        self.dismiss(animated: true) {
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
                        }
                    } else  {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            callback.onFailed { (_) in
                DispatchQueue.main.async {
                    self.showError()
                }
            }
        }
    }
    
    fileprivate func showError(message: String = "Ocorreu algum erro ao tentar salvar a conta.", toReload: Bool = true) {
        let alert  = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: toReload ? "Cancelar" : "Ok", style: .cancel, handler: nil)
        let reload = UIAlertAction(title: "Recarregar", style: .default) { (_) in
            self.save()
        }
        
        alert.addAction(cancel)
        if toReload { alert.addAction(reload) }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func fillWithEditionInformation(bill: BillViewModel) {
        titleTextField.text    = bill.title
        valueTextField.text    = bill.value
        categoryTextField.text = bill.category
        dateTextField.text     = bill.date
    }
}
