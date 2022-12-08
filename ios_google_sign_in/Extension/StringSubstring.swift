//
//  StringSubstring.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 01.12.2022.
//

extension String {
    func findStartPos(search: String) -> Index? {
        if let range: Range<String.Index> = self.range(of: search) {
            let index: Int = self.distance(from: self.startIndex, to: range.lowerBound)
            return Index(utf16Offset: index, in: self)
        }
        return nil
    }

    func findEndPos(search: String) -> Index? {
        if let range: Range<String.Index> = self.range(of: search) {
            let index: Int = self.distance(from: self.startIndex, to: range.lowerBound)
            return Index(utf16Offset: index + search.count, in: self)
        }
        return nil
    }

    func substring(start: Index, end: Index) -> String {
        return String(self[start..<end])
    }

    func substring(start: Index) -> String {
        return String(self[start...])
    }

    func substring(end: Index) -> String {
        return String(self[..<end])
    }
}
