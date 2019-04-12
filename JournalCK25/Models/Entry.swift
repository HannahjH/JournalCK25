//
//  Entry.swift
//  JournalCK25
//
//  Created by Hannah Hoff on 4/8/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    let title: String
    let body: String
    let timestamp: Date
    let recordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
        
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.titleKey] as? String,
            let body = ckRecord[EntryConstants.bodyKey] as? String,
            let timestamp = ckRecord[EntryConstants.timestampKey] as? Date else {return nil}
        
        self.init(title: title, body: body, timestamp: timestamp, recordID: ckRecord.recordID)
        
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordType, recordID: entry.recordID)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.body, forKey: EntryConstants.bodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
    }
}

struct EntryConstants {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    static let recordType = "Entry"
}
