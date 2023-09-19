//
//  StringEx.swift
//  GreenCoimbatore
//
//  Created by Kunal on 23/03/23.
//

import UIKit

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
