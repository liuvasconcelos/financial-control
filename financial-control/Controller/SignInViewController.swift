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
    
    var logoImageView = UIImageView()
    
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
        
        view.backgroundColor          = .white
        emailTextField.placeholder    = "Insira seu email:"
        passwordTextField.placeholder = "Senha"
        
        emailTextField.text = "email@email.com"
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
        self.addLogoImage()

        anchorTextField(field: emailTextField, order: 0)
        anchorTextField(field: passwordTextField, order: 1)
        
        passwordTextField.isSecureTextEntry = true
        
        self.configureSignInButton()
        self.configureSignUpButton()
    }
    
    fileprivate func addLogoImage() {
        logoImageView.image = UIImage(named: "logo")
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor,
                             padding: UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0),
                             size: CGSize(width: 200, height: 66))
        logoImageView.anchorCenterX(anchorX: view.centerXAnchor)
    }
    
    fileprivate func anchorTextField(field: UITextField, order: CGFloat) {
        view.addSubview(field)
        field.anchor(top:     view.topAnchor,
                     leading: view.leadingAnchor,
                     padding: UIEdgeInsets(top: 300 + (order * 60), left: 32, bottom: 0, right: 0),
                     size:    CGSize(width: view.frame.width - 64, height: 30))
        field.keyboardType    = .default
        field.setBottomBorder()
    }
    
    fileprivate func configureSignInButton() {
        signInButton.setTitle("Entrar", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 14)
        signInButton.backgroundColor = UIColor(named: "logoBlue")
        signInButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signInButton.layer.cornerRadius = 5
        view.addSubview(signInButton)
        signInButton.anchor(top:      view.topAnchor,
                            leading:  view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding:  UIEdgeInsets(top: 430, left: 32, bottom: 0, right: 32),
                            size:     CGSize(width: 0, height: 32))
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
        signUpButton.setTitle("Não possui cadastro?", for: .normal)
        signUpButton.backgroundColor = .clear
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 14)
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top:      view.topAnchor,
                            leading:  view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding:  UIEdgeInsets(top: 460, left: 32, bottom: 0, right: 32),
                            size:     CGSize(width: 0, height: 30))
    }
    
    @objc func goToSignUp() {
        let signUpView = SignUpViewController()

        if #available(iOS 13.0, *) {
            self.present(signUpView, animated: true, completion: nil)
        } else  {
            self.navigationController?.pushViewController(signUpView, animated: true)
        }
      
    }
    
}
