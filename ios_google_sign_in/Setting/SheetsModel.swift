//
//  SheetsViewModel.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 08.12.2022.
//

//
// Created by Рамиль Зиганшин on 24.10.2022.
//
// MARK: - Sheet
struct Sheet: Codable {
    let spreadsheetID: String
    let sheets: [SheetElement]
    let spreadsheetURL: String

    enum CodingKeys: String, CodingKey {
        case spreadsheetID = "spreadsheetId"
        case sheets
        case spreadsheetURL = "spreadsheetUrl"
    }
}

// MARK: - SheetElement
struct SheetElement: Codable {
    let properties: Properties
}

// MARK: - Properties
struct Properties: Codable {
    let title: String
}
