//
//  MovieModelTests.swift
//  MovieModelTests
//
//  Created by Joseph Zhu on 2/4/2023.
//

import XCTest
import CoreData

import Foundation

@MainActor
final class MoviesModelTests: XCTestCase {
    var sut: MoviesModel!
    var mockApiService: MockApiService!

    class MockApiService: ApiService {
        var searchMoviesCalled = false
        
        override func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], ApiServiceError>) -> Void) {
            searchMoviesCalled = true
            completion(.success([]))
        }
    }
    
    override func setUp() {
        let dataController = DataController()

        let moc = dataController.container.viewContext
        moc.automaticallyMergesChangesFromParent = true

        let mockApiService = MockApiService()
        self.mockApiService = mockApiService
        
        sut = MoviesModel(service: mockApiService, moc: moc)
    }

    override func tearDown() {
        sut = nil
        mockApiService = nil
    }

    func testSearchMovies() async {
        XCTAssertFalse(mockApiService.searchMoviesCalled)
        await sut.searchMovies(query: "test", page: 1)

        XCTAssertTrue(mockApiService.searchMoviesCalled)
    }
    
    func testIsFavorite() async {
        let movie1 = MovieCopy(id: 1, title: "Test Movie 1", release_date: "2023-01-03", poster_path: "/test_poster_path3.jpg", backdrop_path: "/test_backdrop_path3.jpg", overview: "Test Movie 3 Overview", popularity: 10.0, vote_average: 7.5, vote_count: 1000, image: nil, backdrop: nil)
        let movie2 = MovieCopy(id: 2, title: "Test Movie 2", release_date: "2023-01-04", poster_path: "/test_poster_path4.jpg", backdrop_path: "/test_backdrop_path4.jpg", overview: "Test Movie 4 Overview", popularity: 10.0, vote_average: 7.5, vote_count: 1000, image: nil, backdrop: nil)
        
        sut.addFavorite(movie1)
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            print("Error on Task.sleep")
        }
        
        XCTAssertTrue(sut.isFavorite(movie1), "The movie1 should be marked as a favorite after adding to favorites.")
        XCTAssertFalse(sut.isFavorite(movie2), "The movie2 should not be marked as a favorite since it was not added to favorites.")
    }
    
    func testAddFavorite() {
        let movie = MovieCopy(id: 3, title: "Test Movie", release_date: "2023-01-01", poster_path: "/test_poster_path.jpg", backdrop_path: "/test_backdrop_path.jpg", overview: "Test Movie Overview", popularity: 10.0, vote_average: 7.5, vote_count: 1000, image: nil, backdrop: nil)
        
        sut.addFavorite(movie)
        
        XCTAssertTrue(sut.isFavorite(movie), "The movie should be marked as a favorite after adding to favorites.")
    }
}
