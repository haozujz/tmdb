//
//  GridOfSearchResults.swift
//  tmdb
//
//  Created by Joseph Zhu on 2/4/2023.
//

import SwiftUI

struct GridOfSearchResults: View {
    @EnvironmentObject var moviesModel: MoviesModel
    @FetchRequest(sortDescriptors: []) var movieSearchResults: FetchedResults<MovieSearchResult>
    
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 36) {
            ForEach(
                movieSearchResults
            ) { movie in
                VStack {
                    NavigationLink(destination: MovieDetail(movie: movie), label: { MovieCard(movie: movie, scale: 0.6) })
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

            if movieSearchResults.isEmpty {
            Text("No search results")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 100)
            }
            
            // Enable pagination
            if !movieSearchResults.isEmpty && !moviesModel.isPaginationLimitReached {
                VStack(alignment: .center) {
                    Color.clear
                    ProgressView()
                        .task {
                            await moviesModel.paginate()
                        }
                }
                .position(x: UIScreen.main.bounds.width / 2)
            }
        }
        .padding(.horizontal)
    }
}

struct GridOfSearchResults_Previews: PreviewProvider {
    static var previews: some View {
        GridOfSearchResults()
            .environmentObject(MoviesModel(service: ApiService(), moc: DataController().container.viewContext))
    }
}


