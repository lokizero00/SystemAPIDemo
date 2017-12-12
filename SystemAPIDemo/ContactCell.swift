//
//  ContactCell.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/6.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Contacts

class ContactCell: UITableViewCell {
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var nickL: UILabel!
    @IBOutlet weak var phoneL: UILabel!
    @IBOutlet weak var emailL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellWithContact(contact:CNContact){
        nameL.text="\(contact.givenName) - \(contact.familyName)"
        nickL.text="\(contact.nickname)"
        if let phone=contact.phoneNumbers.first {
            phoneL.text="\(CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)) : \(phone.value.stringValue)"
        }else{
            phoneL.text="暂无"
        }
        
        if let email=contact.emailAddresses.first {
            emailL.text="\(CNLabeledValue<NSString>.localizedString(forLabel: email.label!)) : \(email.value)"
        }else{
            emailL.text="暂无"
        }
    }    
}
