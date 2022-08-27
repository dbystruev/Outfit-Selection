//
//  LoggableViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 10.06.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

/// Base view controller for all that logs viewDidAppear(), viewDidDissapear(), and viewDidLoad() events
open class LoggableViewController: UIViewController {
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debug("✅", className, navigationStack)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debug("⛔️", className, navigationStack)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        debug("👍", className, navigationStack)
    }

    private var navigationStack: String {
        "\n📚\(navigationStack(of: navigationController)) >\(navigationStack(of: self))"
    }
    
    private func navigationStack(of viewController: UIViewController?) -> String {
        let controllers = viewController?.navigationController?.viewControllers ?? []
        let names = controllers.map { $0
            .className
            .replacingOccurrences(of: "ViewController", with: "")
            .replacingOccurrences(of: "Controller", with: "")
        }
        return names.isEmpty ? "" : " \(names.count) \(names)"
    }
}
