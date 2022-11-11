//
//  Auth.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 03.11.2022.
//

let account = "ios_google_sign_in_app.com"
let service = "token"

struct Auth:Codable {
    let accessToken: String
    let refreshToken:String
}
