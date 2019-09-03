//
//  ExtString.swift
//  Lc
//
//  Created by Luciano Calderano on 2018
//  Copyright © 2018 Lc. All rights reserved.
//

import Foundation

public extension String {
    func substringLeft (numOfChar: Int) -> String {
        return substring(from: 0, to: numOfChar - 1)
    }
    func substringRight (numOfChar: Int) -> String {
        return substring(from: self.count - numOfChar, to: self.count - 1)
    }
    func substring(from: Int, numOfChar: Int) -> String {
        return substring(from: from, to: from + numOfChar - 1)
    }
    func substring(from: Int, to: Int) -> String {
        if self.isEmpty { return "" }
        let max = self.count - 1
        if from > max || to > max || from > to { return "" }
        let ini = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to)
        return String(self[ini...end])
    }
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, comment: comment)
    }
    
    func left (lenght l: Int) -> String {
        if (l < 1) {
            return ""
        }
        let fine = l < count ? l : count
        return range(0, fine: fine)
    }
    
    func mid (startAtChar iniz: Int, lenght l: Int = 0) -> String {
        if iniz > count {
            return ""
        }
        let i = (iniz < 1) ? 0 : iniz - 1
        let f = (l == 0 || (i + l) > count) ? count : (i + l)
        return range(i, fine: f)
    }
    
    func right (l: Int) -> String {
        if (l < 1) {
            return ""
        }
        var iniz = count - l;
        if iniz < 0 {
            iniz = 0
        }
        return range(iniz, fine: count)
    }
    
    private func range (_ iniz: Int, fine: Int) -> String {
        let ini = index(startIndex, offsetBy: iniz)
        let end = index(startIndex, offsetBy: fine)
        let s = self[ini..<end]
        return String(s)
    }
    
}
