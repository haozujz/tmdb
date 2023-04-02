//
//  MovieCard.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

struct MovieCard: View {
    @EnvironmentObject var moviesModel: MoviesModel

    let movie: any MovieProtocol
    let scale: CGFloat
    
    init(movie: any MovieProtocol, scale: CGFloat = 1.0) {
        self.movie = movie
        self.scale = scale
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Color.black

                if let data = movie.image, let uiImage = UIImage(data: data)  {
                    Image(uiImage: uiImage).resizable().scaledToFill()
                } else {
                    AsyncImage(url: moviesModel.service.imageUrl(for: movie.poster_path)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 50)
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            Text("|  Image not available   |")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray)
                        default:
                            Text("|  Image not available   |")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    }
                }

            }
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .frame(width: 180.0 * scale, height: 270.0 * scale)
            .shadow(radius: 10, y: 10)
        }
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieCard(movie: Movie.mockWithMovieProtocol())
            .environmentObject(MoviesModel(service: ApiService(), moc: DataController().container.viewContext))
    }
}

