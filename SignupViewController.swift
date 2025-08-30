//
//  SignupViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    // UI Elements
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let signupButton = UIButton()
    private let backToLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Sign Up"
        
        // Configure email text field
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        // Configure password text field
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        // Configure confirm password text field
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true
        
        // Configure signup button
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .systemGreen
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.layer.cornerRadius = 8
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        // Configure back to login button
        backToLoginButton.setTitle("Already have an account? Login", for: .normal)
        backToLoginButton.setTitleColor(.systemBlue, for: .normal)
        backToLoginButton.addTarget(self, action: #selector(backToLoginTapped), for: .touchUpInside)
        
        // Add to view
        [emailTextField, passwordTextField, confirmPasswordTextField, signupButton, backToLoginButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Email text field
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password text field
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Confirm password text field
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Signup button
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Back to login button
            backToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backToLoginButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20),
        ])
    }
    
    @objc private func signupTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Error", message: "Password must be at least 6 characters")
            return
        }
        
        // Show loading state
        signupButton.setTitle("Creating Account...", for: .normal)
        signupButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.signupButton.setTitle("Sign Up", for: .normal)
                self?.signupButton.isEnabled = true
                
                if let error = error {
                    self?.showAlert(title: "Signup Failed", message: error.localizedDescription)
                } else {
                    // Account created successfully
                    self?.signupSuccessful()
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

    private func signupSuccessful() {
        showAlert(title: "Success", message: "Account created successfully! You are now logged in.")
        navigationController?.popToRootViewController(animated: true)
    }
}
