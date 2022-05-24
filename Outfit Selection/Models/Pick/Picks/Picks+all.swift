//
//  Picks+all.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 23.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension Picks {
    static var all: Picks = [
        Pick(.hello, limit: 0, subtitles: ["We picked up items for you", "Based on your preferences and lifestyle"], title: "Hello, "),
        Pick(.newItems, filters: [.gender, .brands], subtitles: ["Daily updated"], title: "New items for you"),
        Pick(.newItems, filters: [.gender, .brands, .sale, .daily, .random], subtitles: ["Daily updated"], title: "Your favorite brands on sale"),
        Pick(.newItems, limit: 0, subtitles: ["Discover personalized recommendations", "Based on your favourite occasions and brands "] , title: "Made for you"),
        Pick(.occasion(""), filters: [.gender, .brands, .occasion], title: "Your personalized pick for "),
        Pick(.brand(""), filters: [.gender, .brand, .occasions], title: "New Arrivals From "),
        Pick(.newItems, limit: 0, title: "Discover fashion"),
        Pick(.newItems, filters: [.gender, .brands, .occasions, .random], limit: 30, title: "Daily 30 — selected by AI "),
        Pick(.newItems, filters: [.gender, .excludeBrands, .occasions], title: "Discover new brands"),
        Pick(.newItems, filters: [.gender, .additionalBrands, .excludeBrands, .occasions], title: "You may like"),
        Pick(.category(""), filters: [.gender, .brands, .category, .random], limit: 30, title: " lover")
    ]
}
