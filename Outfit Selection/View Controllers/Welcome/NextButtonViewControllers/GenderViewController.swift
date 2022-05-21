//
//  GenderViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31/07/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import Firebase
import GoogleSignIn
import UIKit

class GenderViewController: NextButtonViewController {
    
    // MARK: - Outlets
    /// Gender selection buttons stack view
    @IBOutlet weak var buttonStackView: UIStackView!
    
    /// Label with text "Get Outfit is a personalised styling platform"
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = WhiteLabel.Text.Gender.description
            descriptionLabel.textColor = WhiteLabel.Color.Text.label
        }
    }
    
    /// Female, male, and other buttons
    @IBOutlet var genderButtons: [GenderButton]! {
        didSet {
            genderButtons.forEach {
                $0.setTitleColor(Global.Color.Button.Gender.titleColor, for: .normal)
            }
        }
    }
    
    /// Final position of logo
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.image = Global.Image.logo
        }
    }
    
    /// Initial position of logo
    @IBOutlet weak var startingLogoImageView: UIImageView! {
        didSet {
            startingLogoImageView.image = Global.Image.logo
        }
    }
    
    // MARK: - Stored Properties
    /// Flag which indicates if this is the first appearance of this view controller (true) or we came back from navigation stack (false)
    var firstAppearance = true
    
    // The handler for the auth state listener, to allow cancelling later.
    private var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Inherited Properties
    /// Make status bar text light
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Custom Methods
    /// Performs segue to brands view controller
    /// - Parameter gender: gender to pass to brands view controller
    func performSegueToBrandsViewController(gender: Gender) {
        // Save the gender — don't update Gender.current as it is used to reload items
        Gender.current = gender
        
        // Segue to brands view controller
        performSegue(withIdentifier: BrandsViewController.segueIdentifier, sender: self)
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WhiteLabel.Color.Background.light
        
        // Start auth listener
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            // Make shure the current auth user in not nil
            guard let user = user else { return }
            
            // Update current user
            User.update(
                debugmode: false,
                displayName: user.displayName,
                email: user.email ?? "",
                gender: Gender.current?.description ?? "",
                isLoggedIn: true,
                phone: user.phoneNumber,
                photoURL: user.photoURL?.absoluteString,
                uid: Int(user.uid)
            )
            
            // Get hash email curren user
            let currentEmailHash = User.hash(user.email ?? "")
            
            // Filter user where emailHash equals currentEmailHash
            let userContains = Users.all.first { $0.emailHash == currentEmailHash }
            
            debug("INFO: Welcome back dear", user.displayName)
            
            // Get debugmode and it not equal false
            guard userContains?.debugmode == true else { return }

            // Set current user ebugmode = true
            User.current.debugmode = true
            debug("INFO: Debug mode for \(String(describing: User.current.email)) ON")
        }
        
        if UserDefaults.hasAnswerQuestions {
            guard let navigationController = navigationController else { return }
            
            // Start loading items
            NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
            
            NavigationManager.shared.pushViewControllers(
                name: "Welcome",
                identities: ["BrandsViewController", "OccasionsViewController"],
                navigationController: navigationController,
                animated: false)
            
            // Transition to progress
            performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: nil)
            self.buttonStackView.isHidden = true
        }
    }
    
    // MARK: - Inherited Methods
    /// Hides toolbar and navigation bar before the view is added to a view hierarchy
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide toolbar at the bottom
        navigationController?.isToolbarHidden = true
        
        // Hide navigation bar on top
        navigationController?.isNavigationBarHidden = true
    }
    
    /// Return navigation controller bar style back to normal
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove auth listener
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    /// Animate logo to the new position, hide description and unhide button stack view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate only if we came from logo screen
        guard firstAppearance else { return }
        
        firstAppearance = false
        
        // Animate logo image view shift and description label fading
        UIView.animate(withDuration: 1) {
            self.descriptionLabel.alpha = 0
            self.startingLogoImageView.frame = self.logoImageView.frame
        } completion: { _ in
            // Hide outlets from the logo screen
            self.descriptionLabel.isHidden = true
            self.startingLogoImageView.isHidden = true
            
            // Show outlets at the gender screen
            self.buttonStackView.alpha = 0
            self.buttonStackView.isHidden = false
            self.logoImageView.isHidden = false
            
            // Animate button stack view unfading
            UIView.animate(withDuration: 1) {
                self.buttonStackView.alpha = 1
            }
        }
    }
    
    // MARK: - Actions
    /// Called when the female button is tapped
    /// - Parameter sender: the gesture recognizer which was tapped
    @IBAction func femaleSelected(_ sender: GenderButton) {
        performSegueToBrandsViewController(gender: .female)
    }
    
    /// Called when the male button is tapped
    /// - Parameter sender: the gesture recognizer which was tapped
    @IBAction func maleSelected(_ sender: GenderButton) {
        performSegueToBrandsViewController(gender: .male)
    }
    
    @IBAction func otherSelected(_ sender: GenderButton) {
        performSegueToBrandsViewController(gender: .other)
    }
    
}
