//
//  QuizGender.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.09.22.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

enum QuizGender: String {
    case female = "Female"
    case male = "Male"
    
    /// Init QuizGender from Gender. Match female and male and return nil in case of other.
    /// - Parameter gender: Gender (.female, .male, .other)
    init?(_ gender: Gender?) {
        switch gender {
        case .female:
            self = .female
        case .male:
            self = .male
        case .none, .other:
            return nil
        }
    }
}
