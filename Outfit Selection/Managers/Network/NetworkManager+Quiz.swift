//
//  NetworkManager+Quiz.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.09.22.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

// MARK: - Quiz from Airtable
extension NetworkManager {
    /// Call Quiz Airtable API
    /// - Parameters:
    ///   - gender: quiz gender – .female or .male
    ///   - completion: closure called after the request is finished, with quiz data if successfull, or with nil if not
    static func getQuiz(for gender: QuizGender?, completion: @escaping (_ quiz: Quiz?) -> Void) {
        NetworkManager.quiz?.get(gender?.rawValue ?? "", completion: completion)
    }
}
