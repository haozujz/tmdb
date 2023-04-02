//
//  ApiService.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import Foundation

enum ApiServiceError: Error {
    case urlCreationError
    case requestError(Error)
    case httpResponseError
    case dataError
    case decodingError(Error)
}

class ApiService: ObservableObject {
    private let apiKey: String = "8bb4929a43eddbd339300eb39b330d4b"
    private let baseUrl: String = "https://api.themoviedb.org/3"
    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], ApiServiceError>) -> Void) {
        let urlString = "\(baseUrl)/search/movie?api_key=\(apiKey)&language=en-US&include_adult=false&query=\(query)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlCreationError))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.httpResponseError))
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    completion(.failure(.dataError))
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(Response.self, from: data)
                        completion(.success(decoded.results))
                    } catch let error {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func imageUrl(for path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "\(imageBaseUrl)\(path)")
    }
    
    func imageUrlString(for path: String) -> String {
        return "\(imageBaseUrl)\(path)"
    }
    
    func downloadImageData(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(data)
            } else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}



