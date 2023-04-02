//
//  NSManagedObjectContext+executeAndMergeChanges.swift
//  tmdb
//
//  Created by Joseph Zhu on 2/4/2023.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    // Executes the given `NSBatchDeleteRequest` and directly merges the changes to update the given managed object context and in-memory objects
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}

