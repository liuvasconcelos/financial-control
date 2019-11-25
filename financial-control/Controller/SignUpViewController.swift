//
//  SignUpViewController.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 18/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let apiDataSource = AuthApiDataSource.getInstance()
    
    let titleLabel    = UILabel()
    let nameLabel     = UILabel()
    let emailLabel    = UILabel()
    let passwordLabel = UILabel()
    
    let nameTextField     = UITextField()
    let emailTextField    = UITextField()
    let passwordTextField = UITextField()
    
    let saveButton   = UIButton()
    let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        self.addLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(named: "darkBlue")
        addTouch()
    }
    
    fileprivate func addTouch() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(touch)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func addLayout() {
        self.addTitle()
        
        anchorLabel(label: nameLabel, order: 0, text: "Nome:")
        anchorLabel(label: emailLabel, order: 1, text: "E-mail:")
        anchorLabel(label: passwordLabel, order: 2, text: "Senha:")
        
        anchorTextField(field: nameTextField, order: 0)
        anchorTextField(field: emailTextField, order: 1)
        anchorTextField(field: passwordTextField, order: 2)
        
        passwordTextField.isSecureTextEntry = true
        
        addButton()
        
        if #available(iOS 13.0, *) {} else  {
            self.addCancelButton()
        }
    }
    
    fileprivate func addTitle() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top:     view.topAnchor,
                          leading: view.leadingAnchor,
                          padding: UIEdgeInsets(top: 60, left: 32, bottom: 0, right: 0),
                          size:    CGSize(width: view.frame.width - 32, height: 30))
        titleLabel.text      = "Cadastrar"
        titleLabel.font      = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .lightGray
    }
    
    fileprivate func anchorLabel(label: UILabel, order: CGFloat, text: String) {
        view.addSubview(label)
        label.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: 150 + (order * 60), left: 32, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 64, height: 30))
        label.text = text
        label.textColor = .lightGray
    }
    
    fileprivate func anchorTextField(field: UITextField, order: CGFloat) {
        view.addSubview(field)
        field.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: 180 + (order * 60), left: 32, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 64, height: 30))
        field.keyboardType    = .default
        field.setBottomBorder(backgroundColor: UIColor(named: "darkBlue")!, shadowColor: .lightGray)
        field.textColor = .lightGray
    }
    
    fileprivate func addButton() {
        view.addSubview(saveButton)
        saveButton.backgroundColor = UIColor(named: "logoBlue")
        saveButton.setTitle("Cadastrar", for: .normal)
        saveButton.setTitleColor(UIColor(named: "darkBlue"), for: .normal)
        saveButton.layer.cornerRadius = 5
        
        saveButton.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 32, bottom: 100, right: 32),
                          size:    CGSize(width: 0, height: 30))
        saveButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    fileprivate func addCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle("Desisti, voltar para o login :)", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        cancelButton.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 32, bottom: 50, right: 32),
                          size:    CGSize(width: 0, height: 30))
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signUp() {
        let name     = nameTextField.text
        let email    = emailTextField.text
        let password = passwordTextField.text
        
        if !(name?.isEmpty ?? true) && !(email?.isEmpty ?? true) && !(password?.isEmpty ?? true) {
            if isValidEmail(emailStr: email ?? "")  {
                apiDataSource.saveUser(name: name ?? "", email: email ?? "", password: password ?? "") { (callback) in
                    callback.onSuccess { (_) in
                        self.goToListOfBills()
                    }
                    callback.onFailed { (_) in
                        DispatchQueue.main.async {
                            self.showError(message: "Erro ao tentar cadastrar usuário.")
                        }
                    }
                }
            } else {
              self.showError(message: "E-mail inválido.")
            }
            
        } else {
            self.showError()
        }
    }
    
    fileprivate func goToListOfBills() {
        DispatchQueue.main.async {
            let billsList = BillController()
            self.navigationController?.pushViewController(billsList, animated: true)
        }
    }
    
    fileprivate func showError(message: String = "Todos os campos tem que estar preenchidos.") {
        let alert  = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}
