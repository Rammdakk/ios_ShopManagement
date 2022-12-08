//
//  ArraySafeGet.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 07.12.2022.
//

extension Array {
    func get(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
