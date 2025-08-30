//
//  ForgotPasswordViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    private let emailTextField = UITextField()
    private let resetButton = UIButton()
    private let backToLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Reset Password"
        
        // Configure email text field
        emailTextField.placeholder = "Enter your email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        // Configure reset button
        resetButton.setTitle("Send Reset Email", for: .normal)
        resetButton.backgroundColor = .systemOrange
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 8
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        
        // Configure back button
        backToLoginButton.setTitle("Back to Login", for: .normal)
        backToLoginButton.setTitleColor(.systemBlue, for: .normal)
        backToLoginButton.addTarget(self, action: #selector(backToLoginTapped), for: .touchUpInside)
        
        // Add to view
        [emailTextField, resetButton, backToLoginButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            backToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backToLoginButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 20),
        ])
    }
    
    @objc private func resetTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address")
            return
        }
        
        resetButton.setTitle("Sending...", for: .normal)
        resetButton.isEnabled = false
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.resetButton.setTitle("Send Reset Email", for: .normal)
                self?.resetButton.isEnabled = true
                
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self?.showAlert(title: "Success", message: "Password reset email sent! Check your inbox.")
                }
            }
        }
    }
    
    @objc private func backToLoginTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
