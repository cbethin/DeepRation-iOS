//
//  JournalTableViewController.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/8/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {

    var selectedJournalEntry: JournalEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        extendedLayoutIncludesOpaqueBars = true

        self.clearsSelectionOnViewWillAppear = true
        
        self.navigationController?.navigationBar.barTintColor = .white
        
        Journal.shared.onUpdate = self.onJournalEntriesUpdate
        Journal.shared.fetchEntriesFromCloud()
        print("USING UID: \(DeepRationManager.shared.uid!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Journal.shared.numberOfEntries
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalEntryCell") as? JournalEntryCell
        cell?.journalEntry = Journal.shared.getEntryAt(index: indexPath.row)
        return cell!
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toJournalEntryView":
            if let vc = segue.destination as? JournalEntryViewController,
                let selectedJournalEntry = selectedJournalEntry {
                vc.dateOfEntry = selectedJournalEntry.date
            }
        default:
            print("Nope")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJournalEntry = Journal.shared.getEntryAt(index: indexPath.row)
        performSegue(withIdentifier: "toJournalEntryView", sender: self)
    }
    
    // User Profile functions
    func onJournalEntriesUpdate(didComplete: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
