//
//  Array+Equatable.swift
//  Game of SET (iOS)
//
//  Created by Anton Makeev on 19.12.2020.
//

import Foundation

extension Array where Element: Equatable {
    func areEqual() -> Bool {
        if let first = self.first {
            return self.allSatisfy {$0 == first}
        }
        return true
    }
}
