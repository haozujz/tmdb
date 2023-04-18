//
//  GridOfFavorites.swift
//  tmdb
//
//  Created by Joseph Zhu on 2/4/2023.
//

import SwiftUI

struct GridOfFavorites: View {
    @EnvironmentObject var moviesModel: MoviesModel
    @FetchRequest(sortDescriptors: []) var movieFavorites: FetchedResults<MovieFavorite>
    
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 36) {
            ForEach(
                movieFavorites
            ) { movie in
                let copy = MovieCopy(
                    id: movie.id,
                    title: movie.title,
                    release_date: movie.release_date,
                    poster_path: movie.poster_path,
                    backdrop_path: movie.backdrop_path,
                    overview: movie.overview,
                    popularity: movie.popularity,
                    vote_average: movie.vote_average,
                    vote_count: movie.vote_count,
                    image: movie.image,
                    backdrop: movie.backdrop)
                
                VStack {
                    NavigationLink(destination: MovieDetail(movie: copy), label: { MovieCard(movie: movie, scale: 0.6) })
                        .buttonStyle(FlatButtonStyle())
                    
                    VStack(spacing: 0) {
                        Text(movie.title ?? "")
                            .lineLimit(2)
                            .frame(height: 30)
                            .padding(.top, 2)
                        Text(movie.release_date ?? "")
                            .opacity(0.6)
                    }
                    .font(.system(size: 10))
                    .frame(width: 130, height: 20)
                    .padding(.top, 6)
                }
            }
            
            if movieFavorites.isEmpty {
            Text("No favorites")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 100)
            }
        }
        .padding(.horizontal)
    }
}

struct GridOfFavorites_Previews: PreviewProvider {
    static var previews: some View {
        GridOfFavorites()
            .environmentObject(MoviesModel(service: ApiService(), moc: DataController().container.viewContext))
    }
}
