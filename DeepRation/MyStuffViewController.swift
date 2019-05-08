//
//  MyStuffViewController.swift
//  DeepRation
//
//  Created by Charles Bethin on 4/25/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import UIKit
import SafariServices

class MyStuffViewController: UITableViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        DeepRationManager.shared.updateResources()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateResources), name: DeepRationManager.ResourceUpdateNotification, object: nil)
    }
    
    @objc private func updateResources() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED RESOURCE: \(indexPath.row) -- \(DeepRationManager.shared.resources[indexPath.row].url)")
        if let url = URL(string: DeepRationManager.shared.resources[indexPath.row].url) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            
            self.present(safariVC, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DeepRationManager.shared.resources.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myStuffCell", for: indexPath)
        
        // Configure the cell...
        let resource = DeepRationManager.shared.resources[indexPath.row]
        cell.textLabel?.text = resource.title
        cell.detailTextLabel?.text = resource.text
        
        return cell
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}
