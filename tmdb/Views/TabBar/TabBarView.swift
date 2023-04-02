//
//  TabBarView.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

struct NavTabView: View {
    @State private var currentTab: TabBarItem = .search
    
    enum TabBarItem {
        case search, favorites
        
        var icon: String {
            switch self {
            case .search: return "magnifyingglass"
            case .favorites: return "heart.fill"
            }
        }
    }
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .selected)
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $currentTab) {
                SearchView()
                    .tag(.search as TabBarItem)
                    .tabItem {
                        Image(systemName: TabBarItem.search.icon)
                        Text("Search")
                    }
                
                FavoritesView()
                    .tag(.favorites as TabBarItem)
                    .tabItem {
                        Image(systemName: TabBarItem.favorites.icon)
                        Text("Favorites")
                    }
            }
            .accentColor(.blue)
        }
    }
}

