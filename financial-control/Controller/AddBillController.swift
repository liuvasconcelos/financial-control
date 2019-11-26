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
    
    let datePicker = UIDatePicker()
    
    let apiDataSource = BillApiDataSource.getInstance()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(named: "darkBlue")
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
        self.anchorLabel(label: screenTitle, order: 0, text: "Cadastro de contas", title: true)
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
        self.addDatePicker()
    }
    
    fileprivate func anchorLabel(label: UILabel, order: CGFloat, text: String, title: Bool = false) {
        view.addSubview(label)
        
        var topAnchorValue = 30 + (order * 60) + 116
        
        if #available(iOS 13.0, *) {
            topAnchorValue = 30 + (order * 60)
        }
        
        label.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: topAnchorValue, left: 32, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 64, height: 30))
        label.text      = text
        label.textColor = .lightGray
        
        if title {
            label.font = .systemFont(ofSize: 26, weight: .bold)
        }
    }
    
    fileprivate func anchorTextField(field: UITextField, order: CGFloat, numeric: Bool = false) {
        var topAnchorValue = 120 + (order * 60) + 116
        
        if #available(iOS 13.0, *) {
            topAnchorValue = 120 + (order * 60)
        }
        
        view.addSubview(field)
        field.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: topAnchorValue, left: 32, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 64, height: 30))
        field.keyboardType    = numeric ? .decimalPad : .default
        field.setBottomBorder(backgroundColor: UIColor(named: "darkBlue")!, shadowColor: .lightGray)
        field.textColor = .lightGray
    }
    
    fileprivate func addAccount() {
        view.addSubview(addButton)
        addButton.backgroundColor     = UIColor(named: "logoBlue")
        addButton.layer.cornerRadius = 5
        addButton.setTitle("Salvar", for: .normal)
        addButton.anchor(leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 32, bottom: 16, right: 32),
                         size:    CGSize(width: 0, height: 30))
        addButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    fileprivate func addDatePicker() {
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton   = UIBarButtonItem(title: "Feito", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelDatePicker))

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

      dateTextField.inputAccessoryView = toolbar
      dateTextField.inputView          = datePicker

    }
    
    @objc func donedatePicker() {
       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
       dateTextField.text   = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
    }

    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func save() {
        let emptyValues = titleTextField.text?.isEmpty ?? false || valueTextField.text?.isEmpty ?? false || dateTextField.text?.isEmpty ?? false || categoryTextField.text?.isEmpty ?? false
        
        if emptyValues {
            self.showError(message: "Todos os campos tem que estar preenchidos.", toReload: false)
            return
        }
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
