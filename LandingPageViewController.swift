//
//  LandingPageViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit
import FirebaseAuth

class LandingPageViewController: UIViewController {
    
    // UI Elements
    private let welcomeLabel = UILabel()
    private let userEmailLabel = UILabel()
    private let carouselScrollView = UIScrollView()
    private let carouselStackView = UIStackView()
    private let pageControl = UIPageControl()
    
    // Features data
    private let features = [
        ("Start Session", "🎮", "Begin your gaming adventure"),
        ("How To Play", "📚", "Learn the rules and mechanics"),
        ("Game Ranking", "🏆", "View rankings and leaderboards"),
        ("Training", "🤖", "Admin view for training")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHamburgerMenu()
        loadUserInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        // Configure welcome label
        welcomeLabel.text = "Games of the General Arbiter"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        
        // Configure user email label
        userEmailLabel.font = UIFont.systemFont(ofSize: 16)
        userEmailLabel.textAlignment = .center
        userEmailLabel.textColor = .secondaryLabel
        
        // Configure carousel scroll view
        carouselScrollView.isPagingEnabled = true
        carouselScrollView.showsHorizontalScrollIndicator = false
        carouselScrollView.delegate = self
        
        // Configure stack view for carousel
        carouselStackView.axis = .horizontal
        carouselStackView.distribution = .fillEqually
        carouselStackView.spacing = 0
        
        // Configure page control
        pageControl.numberOfPages = features.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        
        // Add subviews
        view.addSubview(welcomeLabel)
        view.addSubview(userEmailLabel)
        view.addSubview(carouselScrollView)
        view.addSubview(pageControl)
        carouselScrollView.addSubview(carouselStackView)
        
        // Setup constraints
        [welcomeLabel, userEmailLabel, carouselScrollView, carouselStackView, pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
        setupCarouselCards()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Welcome label
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // User email label
            userEmailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userEmailLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            userEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userEmailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Carousel scroll view
            carouselScrollView.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 60),
            carouselScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselScrollView.heightAnchor.constraint(equalToConstant: 300),
            
            // Carousel stack view
            carouselStackView.topAnchor.constraint(equalTo: carouselScrollView.topAnchor),
            carouselStackView.leadingAnchor.constraint(equalTo: carouselScrollView.leadingAnchor),
            carouselStackView.trailingAnchor.constraint(equalTo: carouselScrollView.trailingAnchor),
            carouselStackView.bottomAnchor.constraint(equalTo: carouselScrollView.bottomAnchor),
            carouselStackView.heightAnchor.constraint(equalTo: carouselScrollView.heightAnchor),
            carouselStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CGFloat(features.count)),
            
            // Page control
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: carouselScrollView.bottomAnchor, constant: 20),
        ])
    }
    
    private func setupHamburgerMenu() {
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(hamburgerMenuTapped)
        )
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func setupCarouselCards() {
        for (index, feature) in features.enumerated() {
            let cardView = createFeatureCard(
                title: feature.0,
                icon: feature.1,
                description: feature.2,
                index: index
            )
            carouselStackView.addArrangedSubview(cardView)
            
            // Set width constraint after adding to hierarchy
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
    }
    
    private func createFeatureCard(title: String, icon: String, description: String, index: Int) -> UIView {
        let containerView = UIView()
        
        let cardView = UIView()
        cardView.backgroundColor = .systemGray6
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 8
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 60)
        iconLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        let button = UIButton(type: .system)
        button.setTitle("Explore", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = index
        button.addTarget(self, action: #selector(featureButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel, button])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        cardView.addSubview(stackView)
        containerView.addSubview(cardView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Card view within container (with margins)
            cardView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            // Stack view within card
            stackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -40),
            
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        return containerView
    }
    
    private func loadUserInfo() {
        if let user = Auth.auth().currentUser {
            userEmailLabel.text = "Welcome, \(user.email?.components(separatedBy: "@").first ?? "User")!"
        }
    }
    
    @objc private func hamburgerMenuTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Profile", style: .default) { _ in
            self.showAlert(title: "Profile", message: "Profile management will be implemented here!")
        })
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            self.showAlert(title: "Settings", message: "Settings will be implemented here!")
        })
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.logoutTapped()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    @objc private func pageControlChanged() {
        let page = pageControl.currentPage
        let offset = CGPoint(x: CGFloat(page) * carouselScrollView.frame.width, y: 0)
        carouselScrollView.setContentOffset(offset, animated: true)
    }
    
    @objc private func featureButtonTapped(_ sender: UIButton) {
        let feature = features[sender.tag]
        switch sender.tag {
        case 0: // Start Session
            let playerSetupVC = PlayerSetupViewController()
            navigationController?.pushViewController(playerSetupVC, animated: true)
        case 1: // How To Play
            showAlert(title: feature.0, message: "Game tutorial will be shown here...")
        case 2: // Game Ranking
            showAlert(title: feature.0, message: "Rankings and leaderboards will be shown here...")
        case 3: // Training
            showAlert(title: feature.0, message: "Admin training features will be shown here...")
        default:
            break
        }
    }
    
    private func logoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            showAlert(title: "Error", message: "Failed to logout: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension LandingPageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
    }
}
