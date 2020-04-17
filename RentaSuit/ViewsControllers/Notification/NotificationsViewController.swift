//
//  NotificationsViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 11/15/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController, PickableValuesTextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var searchTextField: PickableDataTextField!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSet = [Notif]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSelector(self.searchTextField,dataSet: sortNotifSet, action: .done)
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //sortNotifSet
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        if indexPath.row == 0 {
            cell.createdAtLabel.text = "17-11-2018"
            cell.infoLabel.text = "accept_rent_request".localized
        }
        
        if indexPath.row == 1 {
            cell.createdAtLabel.text = "18-11-2018"
            cell.infoLabel.text = "reject_rent_request".localized
        }
        
        if indexPath.row == 2 {
            cell.createdAtLabel.text = "19-11-2018"
            cell.infoLabel.text = "product_pending_approval".localized
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3//dataSet.count
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            let vc = RentRequestViewController()
            //present from a view and rect
            vc.modalPresentationStyle = .popover //presentation style
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.frame
        }else{
            let vc = ReplyToNotificationViewController()
            //present from a view and rect
            vc.modalPresentationStyle = .popover //presentation style
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.frame
        }
    }
    
    
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
        sender.text = dataSet?.first
        sender.dataSet = (dataSet! as [AnyObject])
        sender.extras = action
        sender.pickableDelegate = self
    }
    func didSelectValue(sender: PickableValuesTextField, value: AnyObject?) {
        if value is String {
            sender.text = (value as! String)
        }
    }
    
    func didRequestNext(sender: PickableValuesTextField) {
        
    }
    
    func didRequestDone(sender: PickableValuesTextField) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
