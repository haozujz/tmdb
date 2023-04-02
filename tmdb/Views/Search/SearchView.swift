//
//  SearchView.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var moviesModel: MoviesModel
    @FetchRequest(sortDescriptors: []) var movieSearchResults: FetchedResults<MovieSearchResult>
    
    // Store ScrollViewReader's proxy to allow external access to `.scrollTo()`
    @State private var scrollProxy: ScrollViewProxy? = nil
    // Store ScrollView offset to enable hiding & showing of the button that scrolls to the top
    @State var scrollOffest: CGFloat = 0
    
    init() {
        // Make navigation bar background be transparent
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("bg")
                    .ignoresSafeArea()
                
                    ScrollViewReader { scrollProxy in
                        ScrollView(.vertical, showsIndicators: true) {
                            ZStack {
                                VStack {
                                    // Mark the top for ScrollReader's `.scrollTo()`
                                    Text("Top")
                                        .frame(height: 1)
                                        .opacity(0)
                                        .id("top")
                       
                                    GridOfSearchResults()
                                }
                                
                                // Detect scroll position
                                GeometryReader { proxy in
                                    let offset = proxy.frame(in: .named("scroll")).minY
                                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: offset)
                                }
                            }
                        }
                        .allowsHitTesting(movieSearchResults.isEmpty ? false : true)
                        .onAppear {
                            self.scrollProxy = scrollProxy
                        }
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            DispatchQueue.main.async {
                                scrollOffest = value
                            }
                        }
                    }
                
                // Allow scroll-to-top
                Button(action: {
                    withAnimation() {
                        scrollProxy?.scrollTo("top", anchor: .top)
                    }
                }, label: {
                    Image(systemName: "chevron.up")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.gray)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 6, y: 6)
                        .padding()
                })
                .frame(width: 12, height: 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 32)
                .padding(.bottom, 24)
                .buttonStyle(FlatButtonStyle())
                .opacity(scrollOffest > 0 ? 0.0 : 1.0)
                .onChange(of: moviesModel.lastSuccessfulQuery) { _ in
                    scrollProxy?.scrollTo("top", anchor: .top)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SearchBarView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(MoviesModel(service: ApiService(), moc: DataController().container.viewContext))
    }
}



