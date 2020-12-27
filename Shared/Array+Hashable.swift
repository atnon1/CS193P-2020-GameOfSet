//
//  Array+Hashable.swift
//  Game of SET (iOS)
//
//  Created by Anton Makeev on 19.12.2020.
//

import Foundation

extension Array where Element: Hashable {
    func areUnique() -> Bool {
        Set(self).count == self.count
    }
}
