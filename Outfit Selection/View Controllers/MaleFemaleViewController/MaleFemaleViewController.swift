//
//  MaleFemaleViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class MaleFemaleViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var stackView: UIStackView!
    
    // MARK: - Properties
    let bundleFolders = ["Top Left", "Bottom Left", "Top Right", "Middle Right", "Bottom Right"]
    var images = [[UIImage]]()
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
        updateUI(with: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(with: size)
    }
    
    // MARK: - UI Methods
    func loadImages() {
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("Images.bundle")
        for folder in bundleFolders {
            let folderURL = assetURL.appendingPathComponent(folder)
            let files = try! fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let imageNames = files.map({ $0.lastPathComponent }).sorted()
            images.append(imageNames.compactMap {
                UIImage(named: "\(folder)/\($0)", in: Bundle(url: assetURL), compatibleWith: nil)
            })
        }
    }
    
    func updateUI(with size: CGSize) {
        let isVertical = size.width < size.height
        stackView.axis = isVertical ? .vertical : .horizontal
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "OutfitSegue" else { return }
        let navigationController = segue.destination as! UINavigationController
        let outfitController = navigationController.viewControllers[0] as! OutfitViewController
        outfitController.images = images
    }
    
    // MARK: - Actions
    @IBAction func femaleSelected(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "OutfitSegue", sender: nil)
    }
    
    @IBAction func maleSelected(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "OutfitSegue", sender: nil)
    }
}
