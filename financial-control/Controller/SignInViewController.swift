//
//  SignInViewController.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 18/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    let apiDataSource = AuthApiDataSource.getInstance()
    
    var emailLabel    = UILabel()
    var passwordLabel = UILabel()
    
    var emailTextField    = UITextField()
    var passwordTextField = UITextField()
    
    var signInButton = UIButton()
    var signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.addLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .blue
        
        emailTextField.text    = "email@email.com"
        passwordTextField.text = "123456"
        
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
        anchorLabel(label: emailLabel, order: 0, text: "E-mail:")
        anchorLabel(label: passwordLabel, order: 1, text: "Senha:")
        
        anchorTextField(field: emailTextField, order: 0)
        anchorTextField(field: passwordTextField, order: 1)
        
        passwordTextField.isSecureTextEntry = true
        
        self.configureSignInButton()
        self.configureSignUpButton()
    }
    
    fileprivate func anchorLabel(label: UILabel, order: CGFloat, text: String) {
        view.addSubview(label)
        label.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: 100 + (order * 60), left: 16, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 32, height: 30))
        label.text = text
    }
    
    fileprivate func anchorTextField(field: UITextField, order: CGFloat) {
        view.addSubview(field)
        field.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: 130 + (order * 60), left: 16, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 32, height: 30))
        field.keyboardType    = .default
        field.backgroundColor = .green
    }
    
    fileprivate func configureSignInButton() {
        signInButton.setTitle("Entrar", for: .normal)
        signInButton.backgroundColor = .clear
        signInButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(signInButton)
        signInButton.anchor(leading:  view.leadingAnchor,
                            bottom:   view.bottomAnchor,
                            trailing: view.trailingAnchor,
                            padding:  UIEdgeInsets(top: 0, left: 16, bottom: 200, right: 16),
                            size:     CGSize(width: 0, height: 50))
    }
    
    @objc func login() {
        let email    = emailTextField.text
        let password = passwordTextField.text
        
        if !(email?.isEmpty ?? true) && !(password?.isEmpty ?? true) {
            apiDataSource.login(email: email ?? "", password: password ?? "") { (callback) in
                callback.onSuccess { (_) in
                    DispatchQueue.main.async {
                        // Salvar usuário localmente
                        
                        self.goToListOfBills()
                    }
                }
                
                callback.onFailed { (_) in
                    DispatchQueue.main.async {
                        self.showError(message: "E-mail ou senha incorretos.")
                    }
                }
            }
            
        } else {
            self.showError()
        }
    }
    
    fileprivate func goToListOfBills() {
        let billsList = BillController()
        self.navigationController?.pushViewController(billsList, animated: true)
    }
    
    fileprivate func showError(message: String = "Todos os campos tem que estar preenchidos.") {
        let alert  = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func configureSignUpButton() {
        signUpButton.setTitle("Cadastrar", for: .normal)
        signUpButton.backgroundColor = .clear
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(leading:  view.leadingAnchor,
                            bottom:   view.bottomAnchor,
                            trailing: view.trailingAnchor,
                            padding:  UIEdgeInsets(top: 0, left: 16, bottom: 64, right: 16),
                            size:     CGSize(width: 0, height: 50))
    }
    
    @objc func goToSignUp() {
        let signUpView = SignUpViewController()

        self.navigationController?.pushViewController(signUpView, animated: true)
    }
    
}
