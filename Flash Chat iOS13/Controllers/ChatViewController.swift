//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
        
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey"),
        Message(sender: "a@b.com", body: "Hello!"),
        Message(sender: "1@2.com", body: "What's up?"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.titleApp
        //hide the back button on navigation bar 
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)

        loadMessages()
    }
    
    func loadMessages() {
        messages = []
        //method to READ data from database
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            // as we are in a closure, we have to add SELF keyword to use array messages
                            self.messages.append(newMessage)
                            //DispatchQueue has to be used to update UI when it is inside a closure. It is going to update the main thread instead of the background one.
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                //take the last record of the tableview to show
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            //method to SEND data to database
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField:   messageBody,
                K.FStore.dateField:  Date().timeIntervalSince1970 //take the current data
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    //DispatchQueue has to be used to update UI when it is inside a closure. It is going to update the main thread instead of the background one.
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
                
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //return to the welcome screen
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    

}

//protocol responsible for POPULATING the table view
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let currentUserEmail = Auth.auth().currentUser?.email
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //This is a message from the current user.
        if message.sender == currentUserEmail {
            cell.leftImageView.isHidden = true
            cell.rightImageVIew.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageVIew.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }

        return cell
    }
}

//protocol responsible for INTERECTIONS with the user in the table view
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TO DO something when pressed at the cell write the code here.
    }
}
