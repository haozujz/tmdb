//
//  ApiServiceTests.swift
//  ApiServiceTests
//
//  Created by Joseph Zhu on 2/4/2023.
//

import XCTest

final class ApiServiceTests: XCTestCase {
    private var sut: ApiService!
    
    override func setUpWithError() throws {
        sut = ApiService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testImageUrlValidPath() {
        let path = "/path_to_image.jpg"
        let url = sut.imageUrl(for: path)
        XCTAssertNotNil(url, "URL should not be nil")
    }
    
    func testImageUrlInvalidPath() {
        let url = sut.imageUrl(for: nil)
        XCTAssertNil(url, "URL should be nil")
    }
    
    func testImageUrlStringValidPath() {
        let path = "/path_to_image.jpg"
        let urlString = sut.imageUrlString(for: path)
        XCTAssertFalse(urlString.isEmpty, "URL string should not be empty")
    }
    
    func testDownloadImageDataValidUrl() {
        let expectation = self.expectation(description: "Valid URL")
        let imageUrlString = "https://image.tmdb.org/t/p/w500/xsW7M4b4gawgFKCzcXHL2MSeswj.jpg"
        sut.downloadImageData(url: imageUrlString) { data in
            XCTAssertFalse(data.isEmpty, "Data should not be empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSearchMoviesValidQuery() {
        let expectation = self.expectation(description: "Valid query")
        sut.searchMovies(query: "Frozen", page: 1) { result in
            switch result {
            case .success(let movies):
                XCTAssertFalse(movies.isEmpty, "Movies should not be empty")
            case .failure:
                XCTFail("Request should succeed")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSearchMoviesEmptyQuery() {
        let expectation = self.expectation(description: "Empty query")
        sut.searchMovies(query: "", page: 1) { result in
            switch result {
            case .success(let movies):
                XCTAssertTrue(movies.isEmpty, "Movies should be empty")
            case .failure:
                XCTFail("Request should succeed")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
