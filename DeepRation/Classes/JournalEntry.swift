//
//  JournalEntry.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/8/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import Foundation
import CloudKit

class JournalEntry: Codable {
    var date: Date = Date(timeIntervalSinceNow: 0) { didSet { updateRecord() }}
    var text: String? { didSet { updateRecord() }}
    
    static let recordZone: String = "JournalZone"
    static let recordType: String = "JournalEntries"
    static let keys = (date: "date", entry: "entry")
    var record: CKRecord?
    
    init(date: Date = Date(timeIntervalSince1970: 0), entry: String = "") {
        self.date = date
        self.text = entry
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try values.decode(String.self, forKey: .text)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        self.date = try formatter.date(from: values.decode(String.self, forKey: .date)) ?? Date(timeIntervalSince1970: 0)
    }
    
    convenience init(record: CKRecord) {
        self.init()
        self.record = record
        
        if let date = record.value(forKey: JournalEntry.keys.date) as? Date {
            self.date = date
        }
        
        self.text = record.value(forKey: JournalEntry.keys.entry) as? String
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.text, forKey: .text)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        try container.encode(formatter.string(from: self.date), forKey: .date)
    }
    
    // MARK: DECODABLE
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case text = "text"
    }
    
    // MARK: JOURNAL FUNCTIONS
    
    func updateRecord() {
        DeepRationManager.shared.updateJournalEntry(entry: self, completion: nil)
    }
}
