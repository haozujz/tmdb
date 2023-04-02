//
//  MovieProtocol.swift
//  tmdb
//
//  Created by Joseph Zhu on 2/4/2023.
//

import Foundation
import SwiftUI

protocol MovieProtocol: Identifiable {
    var id: Int32 { get }
    var title: String? { get }
    var release_date: String? { get }
    var poster_path: String? { get }
    var backdrop_path: String? { get }
    var overview: String? { get }
    var popularity: Float { get }
    var vote_average: Float { get }
    var vote_count: Float { get }
    var image: Data? { get }
    var backdrop: Data? { get }
}
