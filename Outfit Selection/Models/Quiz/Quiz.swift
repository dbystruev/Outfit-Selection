//
//  Quiz.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.09.22.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//
//  This file was generated from JSON Schema using quicktype, do not modify it directly.
//  To parse the JSON, add this file to your project and do:
//
//  let quiz = try? newJSONDecoder().decode(Quiz.self, from: jsonData)

import Foundation

// MARK: - Quiz
struct Quiz: Codable {
    let records: [Record]
}

// MARK: - Record
struct Record: Codable {
    let id, createdTime: String
    let fields: Fields
}

// MARK: - Fields
struct Fields: Codable {
    let fieldsRequired: Required
    let title: String
    let options, inputType: String?
    let id: Int
    let helper, helperType: String?
    let images: [String]?
    let urlFromImages: [String]?

    enum CodingKeys: String, CodingKey {
        case fieldsRequired = "Required"
        case title = "Title"
        case options = "Options"
        case inputType = "Input Type"
        case id
        case helper = "Helper"
        case helperType = "Helper Type"
        case images = "Images"
        case urlFromImages = "URL (from Images)"
    }
}

enum Required: String, Codable {
    case no = "No"
    case yes = "Yes"
}
