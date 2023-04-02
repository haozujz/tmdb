//
//  SearchBarView.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var moviesModel: MoviesModel
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 8)
                    .foregroundColor(.gray)
                
                TextField("Search Movies", text: $moviesModel.searchText)
                    .accessibility(identifier: "searchBar")
                    .onSubmit {
                        Task {
                            await moviesModel.searchMovies(query: moviesModel.searchText, page: 1)
                        }
                    }
                    
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.vertical)
                    .padding(.trailing, 8)
                    .opacity(!moviesModel.searchText.isEmpty ? 1.0 : 0.0)
                    .onTapGesture {
                        moviesModel.searchText = ""
                    }
                    .accessibility(identifier: "clearButton")
                    .accessibilityLabel("Clear search text")
                    
            }
            .frame(height: 36.0)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Material.regular)
                        .frame(height: 36.0)
                        .clipped()
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(.gray.opacity(0.1))
                        .frame(height: 36.0)
                        .clipped()
                }
            )
        }
    }
}

