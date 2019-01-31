//
//  DeepRationManager.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/28/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

struct JournalUpdate: Codable {
    var uid: String = ""
    var entry: JournalEntry = JournalEntry()
}

class DeepRationManager {
    static var shared = DeepRationManager()
    
    var profile: GIDProfileData?
    var uid: String!
    var journal = Journal()
    
    func getJournalEntries(limit: Int = 100, completion: @escaping ([JournalEntry], Error?)->Void) {
        do {
            let postBody = try JSONSerialization.data(withJSONObject: ["uid": uid, "limit": limit])
            sendPostRequest(url: "https://charlesbethin.com/getJournalEntries", body: postBody) { (data, response, error) in
                do {
                    print("GOT JOURNAL")
                    let journal = try JSONDecoder().decode(Journal.self, from: data)
                    completion(journal.entries, nil)
                } catch {
                    completion([], error)
                }
            }
        } catch { print("Error getting journals \(error)") }
    }
    
    func updateJournalEntry(entry: JournalEntry, completion: ((JournalEntry)->Void)?) {
        do {
            let postBody = try JSONEncoder().encode(JournalUpdate(uid: uid, entry: entry))
            sendPostRequest(url: "https://charlesbethin.com/updateJournalEntry", body: postBody, callback: nil)
        } catch { print("Error updating journal: \(error)")}
    }
    
    func signInUser(withIDToken idToken: String) {
        do {
            let postBody = try JSONSerialization.data(withJSONObject: ["token": idToken] as [String: Codable])
            sendPostRequest(url: "https://charlesbethin.com/signinUser", body: postBody) { (data, response, error) in
                let responseString = String(data: data, encoding: .utf8)
                self.uid = responseString
                print("Response String: \(self.uid as Any)")
                
                UserDefaults.standard.set(responseString!, forKey: "deepration-uid")
            }
        } catch {
            print("Error signing in user: \(error)")
        }
    }
    
    func sendPostRequest(url: String, body: Data, callback: ((Data, URLResponse?, Error?)->Void)?) {
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error signing in user: \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Failed HTTP status: \(httpStatus.statusCode), \(String(data: data, encoding: .utf8) ?? "No error value")")
                return;
            }
            
            callback?(data, response, error);
        }
        
        task.resume()
    }
    
}

