//
//  ChatViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/16/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextHolder: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var msgs = ["hello !",
                "Hi, how are u men ?",
                "I'm fine wbu ?",
                "yeah, i'm fine, jsut doing my thing as always",
                "Keep it up fellas ;)",
                "For sure homie :D "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapSend(_ sender: Any) {
        self.view.endEditing(true)
        if nil != self.messageTextHolder.text {
            if self.messageTextHolder.text.count > 0 {
                addRecentSentMessage()
            }
        }
    }
    
    // append message to list
    func addRecentSentMessage() {
        msgs.append(self.messageTextHolder.text)
        self.messageTextHolder.text = ""
        let startIndex = msgs.count - 1
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            var indexPathsToInsert = [IndexPath]()
            indexPathsToInsert.append(IndexPath(row: startIndex, section: 0))
            self.tableView.insertRows(at: indexPathsToInsert, with: .bottom)
            self.tableView.endUpdates()
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - TableView delegate + dataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as! SentMessageCell
            cell.setUpMessageContent(msgs[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecievedMessageCell", for: indexPath) as! RecievedMessageCell
            cell.setUpMessageContent(msgs[indexPath.row])
            return cell
        }
    }
    
}
