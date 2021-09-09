//
//  Occasion+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Occasion {
    
    // MARK: - Stored Properties
    /// All occasions, not selected by default
    static var all: [Occasion] = [
        Occasion("Daily"),
        Occasion("Basic"),
        Occasion("Trendy"),
        Occasion("Casual"),
        Occasion("Business"),
        Occasion("Cocktail"),
        Occasion("Party"),
        Occasion("Night"),
        Occasion("Zoom"),
        Occasion("Home"),
        Occasion("Photoshoot"),
        Occasion("Cute"),
        Occasion("Chic"),
        Occasion("Brunch"),
        Occasion("Eco-friendly"),
        Occasion("Date"),
        Occasion("School"),
        Occasion("College"),
        Occasion("B-day"),
        Occasion("Yoga"),
        Occasion("Street style"),
        Occasion("Summer"),
        Occasion("Winter"),
        Occasion("Barbecue"),
        Occasion("Boss"),
        Occasion("Startup"),
        Occasion("Mommy"),
        Occasion("Sport"),
        Occasion("Urban"),
        Occasion("Burning man"),
        Occasion("Coachella"),
        Occasion("Black Tie"),
        Occasion("Wedding"),
        Occasion("New Year"),
    ]
    
    static var names: [String] { all.map { $0.name } }
}
