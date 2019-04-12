//
//  EntryController.swift
//  JournalCK25
//
//  Created by Hannah Hoff on 4/8/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    // shared instance. We want one consistent source of truth
    static let shared = EntryController()
    private init() {}
    
    var entries: [Entry] = []
    
    func save(entry: Entry, completion: @escaping (Bool) -> ()) {
        let record = CKRecord(entry: entry)
        CKContainer.default().privateCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            }
            guard let record = record,
                let entry = Entry(ckRecord: record) else { completion(false); return }
            self.entries.append(entry)
            completion(true)
            
        }
    }
    
    func addEntryWith(title: String, body: String, completion: @escaping (Bool) -> Void) {
        let entry = Entry(title: title, body: body)
        save(entry: entry, completion: completion)
    }
    
    func fetchEntries(completion: @escaping (Bool) -> ()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordType, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            }
            guard let records = records else { completion(false); return }
            let entries = records.compactMap{ Entry(ckRecord: $0)}
            self.entries = entries
            completion(true)
            
        }
    }
}
