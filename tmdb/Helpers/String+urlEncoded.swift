//
//  String+urlEncoded.swift
//  tmdb
//
//  Created by Joseph Zhu on 2/4/2023.
//

import Foundation

public extension String {
    func urlEncoded() -> String {
        self.replacingOccurrences(of: " ", with: "+")
    }
}
