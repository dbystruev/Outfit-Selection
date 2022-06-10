//
//  LoggableTableViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 10.06.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

/// Base view controller for all that logs viewDidAppear(), and viewDidDissapear() events
open class LoggableTableViewController: UITableViewController {
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debug("✅", className)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debug("⛔️", className)
    }
}
