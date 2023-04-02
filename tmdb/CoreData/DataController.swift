//
//  DataController.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MovieDataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error)")
            } else {
                print("Core Data loaded")
            }
        }
    }
}
