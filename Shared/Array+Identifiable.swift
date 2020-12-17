//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Anton Makeev on 05.12.2020.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching element: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == element.id {
                return index
            }
        }
        return nil
    }
}

