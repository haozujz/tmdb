//
//  Movie.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import Foundation

// The object returned upon tmdb api call
struct Response: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let release_date: String
    let poster_path: String?
    let backdrop_path: String?
    let overview: String
    let popularity: Float?
    let vote_average: Float?
    let vote_count: Float?
}

// Access a mock Movie object for testing
extension Movie {
    static func mock() -> Movie {
        Movie(id: 123, title: "Luther: The Fallen Sun", release_date: "2222-22-22", poster_path: "/xsW7M4b4gawgFKCzcXHL2MSeswj.jpg", backdrop_path: "/eN6R6mb3ntHwA3y3MhSwpP78ljN.jpg", overview: "A gruesome serial killer is terrorizing London while brilliant but disgraced detective John Luther sits behind bars. Haunted by his failure to capture the cyber psychopath who now taunts him, Luther decides to break out of prison to finish the job by any means necessary.", popularity: 8, vote_average: 10, vote_count: 10)
    }
}

// Access a mock object conforming to MovieProtocol for testing
extension Movie {
    static func mockWithMovieProtocol() -> any MovieProtocol {
        let mock = Movie.mock()
        
        let object = MovieCopy(
            id: Int32(mock.id),
            title: mock.title,
            release_date: mock.release_date,
            poster_path: mock.poster_path,
            backdrop_path: mock.backdrop_path,
            overview: mock.overview,
            popularity: mock.popularity ?? 0,
            vote_average: mock.vote_average ?? 0,
            vote_count: mock.vote_count ?? 0,
            image: nil,
            backdrop: nil)
        
        return object
    }
}

// An object conforming to MovieProtocol, intended to be used to copy CoreData entities as to be independant from CoreData and not affect or be affected by the original
struct MovieCopy: MovieProtocol {
    var id: Int32
    var title: String?
    var release_date: String?
    var poster_path: String?
    var backdrop_path: String?
    var overview: String?
    var popularity: Float
    var vote_average: Float
    var vote_count: Float
    var image: Data?
    var backdrop: Data?
}

// Sample JSON of movie data returned upon api call
/*
{
        "adult": false,
        "backdrop_path": "/eN6R6mb3ntHwA3y3MhSwpP78ljN.jpg",
        "genre_ids": [53, 80, 28, 9648],
        "id": 722149,
        "original_language": "en",
        "original_title": "Luther: The Fallen Sun",
        "overview": "A gruesome serial killer is terrorizing London while brilliant but disgraced detective John Luther sits behind bars. Haunted by his failure to capture the cyber psychopath who now taunts him, Luther decides to break out of prison to finish the job by any means necessary.",
        "popularity": 259.578,
        "poster_path": "/xsW7M4b4gawgFKCzcXHL2MSeswj.jpg",
        "release_date": "2023-02-24",
        "title": "Luther: The Fallen Sun",
        "video": false,
        "vote_average": 6.894,
        "vote_count": 393
    }
*/

//Example api call url: "https://api.themoviedb.org/3/search/movie?api_key=8bb4929a43eddbd339300eb39b330d4b&language=en-US&include_adult=false&query=a+frozen+rooster&page=1"
// Complete poster path for a sample movie: https://image.tmdb.org/t/p/w500/xsW7M4b4gawgFKCzcXHL2MSeswj.jpg
// Complete backdrop path for a sample movie: https://image.tmdb.org/t/p/w500/eN6R6mb3ntHwA3y3MhSwpP78ljN.jpg

