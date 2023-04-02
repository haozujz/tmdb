//
//  FavoritesView.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var moviesModel: MoviesModel
    @FetchRequest(sortDescriptors: []) var movieFavorites: FetchedResults<MovieFavorite>
    
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("bg")
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: true) {
                    GridOfFavorites()
                        .padding(.top, 20)
                }
                .allowsHitTesting(movieFavorites.isEmpty ? false : true)
            }
            .navigationTitle("Favorites")
            .toolbarBackground(Color.clear, for: .navigationBar)
        }
        
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(MoviesModel(service: ApiService(), moc: DataController().container.viewContext))
    }
}
