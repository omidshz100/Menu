//
//  @Extentions.swift
//  Menu
//
//  Created by Omid Shojaeian Zanjani on 01/04/24.
//

import Foundation


extension Array {
    func separateArray(into numberOfArrays: Int) -> [[Element]] {
        guard numberOfArrays > 0 else { return [] }
        let subArraySize = Swift.max((self.count + numberOfArrays - 1) / numberOfArrays, 1)
        var separatedArrays = [[Element]]()
        var startIndex = self.startIndex
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: subArraySize, limitedBy: self.endIndex) ?? self.endIndex
            let subArray = Array(self[startIndex..<endIndex])
            separatedArrays.append(subArray)
            startIndex = endIndex
        }
        return separatedArrays
    }
}
