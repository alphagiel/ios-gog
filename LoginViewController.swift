//
//  LoginViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // UI Elements
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let signupButton = UIButton()
    private let forgotPasswordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure email text field
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        // Configure password text field
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        // Configure login button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        // Configure signup button
        signupButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signupButton.setTitleColor(.systemBlue, for: .normal)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        // Configure forgot password button
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.setTitleColor(.systemBlue, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        
        // Add to view and setup layout
        [emailTextField, passwordTextField, loginButton, signupButton, forgotPasswordButton].forEach {
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
            
            // Login button
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Signup button
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            
            // Forgot password button
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 10),
        ])
    }
    
    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter email and password")
            return
        }
        
        // Show loading state
        loginButton.setTitle("Logging in...", for: .normal)
        loginButton.isEnabled = false
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.loginButton.setTitle("Login", for: .normal)
                self?.loginButton.isEnabled = true
                
                if let error = error {
                    self?.showAlert(title: "Login Failed", message: error.localizedDescription)
                } else {
                    // Login successful - navigate to main app
                    self?.loginSuccessful()
                }
            }
        }
    }
    
    @objc private func signupTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc private func forgotPasswordTapped() {
        let forgotPasswordVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func loginSuccessful() {
        let landingPageVC = LandingPageViewController()
        navigationController?.pushViewController(landingPageVC, animated: true)
    }
}
