//
//  MoviesModel.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import Foundation
import CoreData

@MainActor
final class MoviesModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isPaginationLimitReached = false
    
    // Store lastSuccessfulQuery for pagination
    private(set) var lastSuccessfulQuery: String = ""
    // Store lastSubmittedQuery to show only results of the latest search
    private var lastSubmittedQuery: String = ""
    
    // Store currentPage for pagination
    private var currentPage: Int = 1
    // Store apiCallQueueCount to prevent pagination when search/pagination is already in progress
    private var apiCallQueueCount: Int = 0

    let service: ApiService
    let moc: NSManagedObjectContext
    
    init(service: ApiService, moc: NSManagedObjectContext) {
        self.service = service
        self.moc = moc
    }

    func searchMovies(query: String, page: Int) async {
        apiCallQueueCount += 1
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).urlEncoded()
        lastSubmittedQuery = trimmedQuery
        
        service.searchMovies(query: trimmedQuery, page: page) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let newMovies):
                // If paginating
                if page > 1 {
                    if newMovies.count == 0 {
                        self.isPaginationLimitReached = true
                        print("No more new movies to append or attempting to paginate with stored offline data, pagination disabled")
                    } else {
                        Task {
                            try await self.moc.perform {
                                for movie in newMovies {
                                    let entity = MovieSearchResult(context: self.moc)
                                    entity.id = Int32(movie.id)
                                    entity.title = movie.title
                                    entity.release_date = movie.release_date
                                    entity.overview = movie.overview
                                    entity.poster_path = movie.poster_path
                                    entity.backdrop_path = movie.backdrop_path
                                    entity.popularity = movie.popularity ?? 0
                                    entity.vote_average = movie.vote_average ?? 0
                                    entity.vote_count = movie.vote_count ?? 0
                                    
                                    if let posterPath = movie.poster_path {
                                        self.service.downloadImageData(url: self.service.imageUrlString(for: posterPath)) { imageData in
                                            entity.image = imageData
                                        }
                                    }
                                    
                                    if let backdropPath = movie.backdrop_path {
                                        self.service.downloadImageData(url: self.service.imageUrlString(for: backdropPath)) { imageData in
                                            //let _: Data = imageData
                                            entity.backdrop = imageData
                                        }
                                    }
                                }

                                try self.moc.save()
                                print("Saved pagination results to CoreData")
                            }
                        }

                        print("Paginated: \(newMovies.count) new movies appended")
                    }
    
                // If new search 
                } else {
                    if self.lastSubmittedQuery == trimmedQuery {
                        self.lastSuccessfulQuery = trimmedQuery
                        self.currentPage = 1
                        self.isPaginationLimitReached = false
                        
                        Task {
                            try await self.moc.perform {
                                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieSearchResult.fetchRequest()
                                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                                //  Note: `.execute(batchDeleteRequest)` will not automtically update in-memory objects following a deletion
                                try self.moc.executeAndMergeChanges(using: batchDeleteRequest)
                                
                                for movie in newMovies {
                                    let entity = MovieSearchResult(context: self.moc)
                                    entity.id = Int32(movie.id)
                                    entity.title = movie.title
                                    entity.release_date = movie.release_date
                                    entity.overview = movie.overview
                                    entity.poster_path = movie.poster_path
                                    entity.backdrop_path = movie.backdrop_path
                                    entity.popularity = movie.popularity ?? 0
                                    entity.vote_average = movie.vote_average ?? 0
                                    entity.vote_count = movie.vote_count ?? 0
                                    
                                    if let posterPath = movie.poster_path {
                                        self.service.downloadImageData(url: self.service.imageUrlString(for: posterPath)) { imageData in
                                            //let _: Data = imageData
                                            entity.image = imageData
                                        }
                                    }
                                    
                                    if let backdropPath = movie.backdrop_path {
                                        self.service.downloadImageData(url: self.service.imageUrlString(for: backdropPath)) { imageData in
                                            //let _: Data = imageData
                                            entity.backdrop = imageData
                                        }
                                    }
                                }

                                try self.moc.save()
                                print("Saved new search results to CoreData")
                            }
                        }
                    }
                }
            case.failure(let error):
                print("Error fetching movies: \(error)")
            }
            self.apiCallQueueCount -= 1
        }
    }
    
    func paginate() async {
        if apiCallQueueCount == 0 {
            currentPage += 1
            print("Paginating: New page number is \(currentPage)")
            await searchMovies(query: lastSubmittedQuery, page: currentPage)
        } else {
            print("Cancelled pagination: There is/are still \(apiCallQueueCount) in the apiCallQueueCount")
        }
    }

    func addFavorite(_ movie: any MovieProtocol) {
        let favorite = MovieFavorite(context: moc)
        favorite.id = movie.id
        favorite.title = movie.title
        favorite.release_date = movie.release_date
        favorite.overview = movie.overview
        favorite.poster_path = movie.poster_path
        favorite.backdrop_path = movie.backdrop_path
        favorite.popularity = movie.popularity
        favorite.vote_average = movie.vote_average
        favorite.vote_count = movie.vote_count
        
        if let posterPath = movie.poster_path {
            self.service.downloadImageData(url: self.service.imageUrlString(for: posterPath)) { imageData in
                //let _: Data = imageData
                favorite.image = imageData
            }
        }
        
        if let backdropPath = movie.backdrop_path {
            self.service.downloadImageData(url: self.service.imageUrlString(for: backdropPath)) { imageData in
                //let _: Data = imageData
                favorite.backdrop = imageData
            }
        }

        do {
            try moc.save()
            print("Added to favorites")
        } catch {
            print("Error adding favorite movie: \(error)")
        }
    }

    func removeFavorite(_ movie: any MovieProtocol) {
        let fetch = MovieFavorite.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", NSNumber(value: movie.id))
        
        do {
            let result = try moc.fetch(fetch)
                for r in result {
                    moc.delete(r)
                }
            
                try moc.save()
                print("Removed from favorites")
        } catch {
            print("Error on removing MovieFavorite in CoreData: \(error)")
        }
    }
    
    func isFavorite(_ movie: any MovieProtocol) -> Bool {
        let fetch = MovieFavorite.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", NSNumber(value: movie.id))
        
        do {
            let result = try moc.fetch(fetch)
            
            switch result.count {
            case 1: return true
            case 0: return false
            default:
                print("Error: There is may be more than one instance of this movie in favorites")
                return true
            }
        } catch {
            print("Error on checking Favorites in CoreData: \(error)")
            return false
        }
    }
}


