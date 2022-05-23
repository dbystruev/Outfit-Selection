//
//  FeedCollectionViewController+Picks.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 23.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension FeedCollectionViewController {
    
    // MARK: - Methods
    /// The make expand emptty pick types (.occasion(" "), .brand(" "), .category(" "))
    /// - Parameter picks: Picks with empty PickType
    /// - Returns: array Picks aftert expand all empty PickType
    func expand(picks: Picks) -> Picks {
        var expandedPiks: Picks = []
        
        for pick in picks {
            switch pick.type {
            case .hello:
                var pick = Pick(.hello, subtitles: pick.subtitles, title: pick.title)
                if currentUser.isLoggedIn == true {
                    let userName = User.current.displayName ?? ""
                    pick = Pick(.hello, subtitles: pick.subtitles, title: pick.title + userName )
                }
                
                expandedPiks.append(pick)
                
            case .occasion(""):
                let picks = pickOccasion(pick: pick)
                expandedPiks += picks
                
            case .brand(""):
                let picks = pickBrand(pick: pick)
                expandedPiks += picks
                
            case .category(""):
                let picks = pickCategory(pick: pick)
                expandedPiks += picks
                
            default:
                expandedPiks.append(pick)
            }
        }
        
        return expandedPiks
    }
    
    // MARK: - Private Methods
    /// Private method for make expanded (.brand)
    /// - Parameter pick: pick with empty (.brand) PickType for expand
    /// - Returns: array with picks
    private func pickBrand(pick: Pick) -> Picks {
        let selectrdBrands = Brands.selected
        let picks = selectrdBrands.map { Pick(.brand($0.value.name), filters: pick.filters, title: pick.title + $0.value.name) }
        return picks
    }
    
    /// Private method for make expanded (.category)
    /// - Parameter pick: pick with empty (.category) PickType for expand
    /// - Returns: array with picks
    func pickCategory(pick: Pick) -> Picks {
        let selectedCategories = Categories.byID
        let picks = selectedCategories.map { Pick(.category($0.value.name), filters: pick.filters, limit: pick.limit, title: $0.value.name + pick.title) }
        return picks
    }

    /// Private method for make expanded (.occasion)
    /// - Parameter pick: pick with empty (.occasion) PickType for expand
    /// - Returns: array with picks
    private func pickOccasion(pick: Pick) -> Picks {
        let selectrdOccasion = Occasions.selectedUniqueTitle
        let picks = selectrdOccasion.map { Pick(.occasion($0.title), filters: pick.filters, subtitles: pick.subtitles, title: pick.title + $0.title) }
        return picks
    }
    
}
