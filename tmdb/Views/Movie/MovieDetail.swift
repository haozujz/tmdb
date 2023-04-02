//
//  MovieDetail.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

struct MovieDetail: View {
    @EnvironmentObject var moviesModel: MoviesModel
    @Environment(\.dismiss) private var dismiss
    let movie: any MovieProtocol
    
    let backdropHeight: CGFloat = 300
    
    @State private var idToReload = UUID()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("bg")
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                Spacer(minLength: backdropHeight + 70)
                
                VStack {
                    Text(movie.title ?? "Missing title")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 1)
                    Text(movie.release_date ?? "00-00-0000")
                        .font(.caption)
                        .opacity(0.8)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\((movie.vote_average ), specifier: "%.1f")")
                                .fontWeight(.semibold)
                            Text("User score")
                                .font(.caption)
                                .opacity(0.8)
                        }
        
                        Divider()
                            .frame(width: 4)
                            .padding(.horizontal, 10)
                        
                        VStack(alignment: .leading) {
                            Text("\((movie.vote_count ), specifier: "%.0f")")
                                .fontWeight(.semibold)
                            Text("Score count")
                                .font(.caption)
                                .opacity(0.8)
                        }
                        
                        Divider()
                            .frame(width: 4)
                            .padding(.horizontal, 10)
                        
                        VStack(alignment: .leading) {
                            Text("\((movie.popularity ), specifier: "%.2f")")
                                .fontWeight(.semibold)
                            Text("Popularity")
                                .font(.caption)
                                .opacity(0.8)
                        }
                    }
                    .frame(height: 60)
                    .padding(.vertical, 8)
                    
                    VStack(alignment: .leading) {
                        Text("OVERVIEW")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                        Text(movie.overview ?? "Missing overview")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 10)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.gray.opacity(0.2))
                    .padding(.top, 8)
                }
            }
            
            ZStack {
                ZStack {
                    Color.black

                    if let data = movie.backdrop, let uiImage = UIImage(data: data)  {
                        Image(uiImage: uiImage)
                            .resizable().scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: backdropHeight)
                            .opacity(0.5)
                    } else {
                        AsyncImage(url: moviesModel.service.imageUrl(for: movie.backdrop_path)) { phase in
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
                        .frame(width: UIScreen.main.bounds.width, height: backdropHeight)
                        .opacity(0.5)
                    }
                    
                }
                .clipShape(ConvexBottomShape(convexRadius: 30.0))
                .frame(width: UIScreen.main.bounds.width, height: backdropHeight)
                
                MovieCard(movie: movie)
                    .shadow(radius: 10, y: 10)
                    .offset(y: 60)
            }
            .padding(.bottom, 70)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.backward")
                    .fontWeight(.bold)
                    .shadow(color: Color.black, radius: 10, x: 0, y: 3)
                    .padding(10)
                    .padding(.horizontal, 3)
                    .foregroundColor(.white)
                    .background(Color.clear)
                    .onTapGesture {
                        dismiss()
                    }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: moviesModel.isFavorite(movie) ? "heart.fill" : "heart")
                    .fontWeight(.bold)
                    .shadow(color: Color.black, radius: 10, x: 0, y: 3)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.clear)
                    .onTapGesture {
                        if moviesModel.isFavorite(movie) {
                            moviesModel.removeFavorite(movie)
                        } else {
                            moviesModel.addFavorite(movie)
                        }
                        idToReload = UUID()
                    }
                    .id(idToReload)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            idToReload = UUID()
        }
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovieDetail(movie: Movie.mockWithMovieProtocol())
                .environmentObject(MoviesModel(service: ApiService(), moc: DataController().container.viewContext))
        }
    }
}

struct ConvexBottomShape: Shape {
    var convexRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // top-left
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // top-right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - convexRadius)) // right edge

        // Convex curve along the bottom edge
        let controlPoint = CGPoint(x: rect.midX, y: rect.maxY + convexRadius)
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - convexRadius), control: controlPoint)

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // left edge
        return path
    }
}



