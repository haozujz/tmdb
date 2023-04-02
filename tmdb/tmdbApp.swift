//
//  tmdbApp.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

@main
struct tmdbApp: App {
    @StateObject private var dataController: DataController
    @StateObject private var moviesModel: MoviesModel

    init() {
        let dataController = DataController()
        
        let moc = dataController.container.viewContext
        moc.automaticallyMergesChangesFromParent = true
        let moviesModel = MoviesModel(service: ApiService(), moc: moc)
        
        self._dataController = StateObject(wrappedValue: dataController)
        self._moviesModel = StateObject(wrappedValue: moviesModel)
    }
    
    var body: some Scene {
        WindowGroup {
           NavTabView()
                .environmentObject(moviesModel)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
