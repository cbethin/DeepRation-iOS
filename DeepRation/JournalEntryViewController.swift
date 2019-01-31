//
//  JournalEntryViewController.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/8/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import UIKit

class JournalEntryViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var entryTextView: UITextView!
    
    var dateOfEntry: Date?
    
    var entry: JournalEntry? {
        if let date = dateOfEntry {
            return Journal.shared.getEntryAt(date: date)
        }
        
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
        self.navigationItem.largeTitleDisplayMode = .always
        
        if let entry = entry {
            self.navigationItem.title = entry.date.getAsCommonString()
            self.entryTextView.text = entry.text
            
            if entry.date.isDateInToday && (entry.text == "" || entry.text == nil) {
                self.entryTextView.text = "Write something..."
                self.entryTextView.textColor = #colorLiteral(red: 0.5960784314, green: 0.6274509804, blue: 0.6352941176, alpha: 1)
            }
        }
        
        entryTextView.delegate = self
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.entryTextView.text == "Write something..." {
            self.entryTextView.text = ""
            self.entryTextView.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let entry = entry else { return true }
        
        entry.text = entryTextView.text
        Journal.shared.updateEntry(entry: entry)
        return true
    }
}
