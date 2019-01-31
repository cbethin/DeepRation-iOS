//
//  JournalEntryCell.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/8/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import UIKit

class JournalEntryCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    var journalEntry: JournalEntry? {
        didSet {
            setupJournalEntry()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        entryLabel.textColor = #colorLiteral(red: 0.5960784314, green: 0.6274509804, blue: 0.6352941176, alpha: 1)
        setupJournalEntry()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupJournalEntry() {
        guard let entry = journalEntry else { return }
        
        dateLabel.text = entry.date.getAsCommonString()
        
        if entry.text == nil || entry.text == "" {
            entryLabel.textColor = #colorLiteral(red: 0.5960784314, green: 0.6274509804, blue: 0.6352941176, alpha: 1)
            if entry.date.isDateInToday {
                entryLabel.text = "Write something..."
            } else {
                entryLabel.text = "Nothing written"
            }
        } else {
            entryLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            entryLabel.text = entry.text
        }
    }
}
