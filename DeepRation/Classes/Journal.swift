//
//  Journal.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/11/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import Foundation
import CloudKit

class Journal: Decodable {
    static var shared = Journal()
    
    var entries: [JournalEntry] = []
    var onUpdate: ((Bool) -> Void)? // Called when journal is updated
    
    // MARK: INITIALIZERS
    init() {
        self.entries = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.entries = try values.decode([JournalEntry].self, forKey: .entries)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.entries, forKey: .entries)
    }
    
    enum CodingKeys: String, CodingKey {
        case entries = "entries"
    }
    
    // MARK: FUNCTIONALITY
    
    // Gets number of entries in journal, creates entry for today if none yet
    var numberOfEntries: Int {
        if !self.containsEntryForToday {
            self.insertOrUpdateNewEntry(JournalEntry(date: Date(), entry: ""))
        }
        
        return entries.count
    }
    
    // Check if journal has an entry for today
    var containsEntryForToday: Bool {
        return indexOfDate(Date(timeIntervalSinceNow: 0)) != nil
    }
    
//    var lastEntryBeforeToday: JournalEntry {
//        if containsEntryForToday {
//            return entries[entries.count-2]
//        } else {
//            return entries[entries.count-1]
//        }
//    }
    
    // Gets index of journal entry with given date
    func indexOfDate(_ date: Date) -> Int? {
        for i in 0..<entries.count {
            if entries[i].date.isInSameDayAs(date: date) {
                return i
            }
        }
        return nil
    }

    // MARK: JOURNAL ACCESS FUNCTIONS
    // MARK: MAKE THIS SAFE
    func getEntryAt(index: Int) -> JournalEntry {
        // If first entry is not from today, insert a blank
        if entries.count <= 0 { return JournalEntry() }
        let firstEntry = entries[0]
        let calendar = Calendar.current
        if !calendar.isDateInToday(firstEntry.date) {
            let newJournalEntry = JournalEntry(date: Date(timeIntervalSinceNow: 0), entry: "")
            entries.insert(newJournalEntry, at: 0)
        }
        
        return entries[index]
    }
    
    func getEntryAt(date: Date) -> JournalEntry? {
        for i in 0..<entries.count {
            if entries[i].date.isInSameDayAs(date: date) {
                return entries[i]
            }
        }
        
        return nil
    }
    
    // MARK: JOURNAL EDITING
    func updateEntry(entry: JournalEntry) {
        if let i = indexOfDate(entry.date) {
            entries[i] = entry
            onUpdate?(true)
        }
        
        onUpdate?(false)
    }
    
    func insertOrUpdateNewEntry(_ newEntry: JournalEntry) {
        if self.indexOfDate(newEntry.date) != nil {
            updateEntry(entry: newEntry)
            return
        }
        
        entries.append(newEntry)
        entries.sort(by: { $0.date > $1.date })
        
        onUpdate?(true)
    }
    
    // MARK: CLOUD UPDATING FUNCTIONS
    func fetchEntriesFromCloud() {
        DeepRationManager.shared.getJournalEntries(limit: 50) { (entries, error) in
            if let error = error {
                print("Error getting journals: \(error)")
            }
            
            entries.forEach {
                print("Entry at: \($0.date).. \($0.text as Any)")
            }
            entries.forEach({ entry in
                self.insertOrUpdateNewEntry(entry)
            })
        }
    }
}
