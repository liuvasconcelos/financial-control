//
//  SignInViewController.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 18/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    var signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.configureSignUpButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .blue
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
        
//        let billsList = BillController()
//        self.navigationController?.pushViewController(billsList, animated: true)
    }
    
}
