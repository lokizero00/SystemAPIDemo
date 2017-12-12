//
//  ContactDetailViewController.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/7.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Contacts

//实现UpdateContactDetailDelegate代理，用于从编辑页回到详情页传值
class ContactDetailViewController: UIViewController,UpdateContactDetailDelegate {
    @IBOutlet weak var nameL:UILabel!
    @IBOutlet weak var nickL:UILabel!
    @IBOutlet weak var phoneL:UILabel!
    @IBOutlet weak var emailL:UILabel!
    
    //存放显示详情的联系人
    var contact:CNContact?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.eidtButtonClicked))
    }
    
    @objc func eidtButtonClicked(){
        let editCtl=EditContactViewController()
        editCtl.navigationItem.title="编辑"
        editCtl.contactToEdit=contact?.mutableCopy() as? CNMutableContact
        //将本身赋值给后一个Controller的代理
        editCtl.delegate=self
        navigationController?.pushViewController(editCtl, animated: true)
    }
    
    //显示前调用，用于更新界面
    override func viewWillAppear(_ animated: Bool) {
        showContactDetails()
    }
    
    func showContactDetails(){
        if let _contact=contact {
            nameL.text="\(_contact.givenName) - \(_contact.familyName)"
            nickL.text="\(_contact.nickname)"
            if let phone=_contact.phoneNumbers.first {
                phoneL.text="\(CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)) : \(phone.value.stringValue)"
            }else{
                phoneL.text="暂无"
            }
            
            if let email=_contact.emailAddresses.first {
                emailL.text="\(CNLabeledValue<NSString>.localizedString(forLabel: email.label!)) : \(email.value)"
            }else{
                emailL.text="暂无"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //代理方法，用于编辑Controller返回时的数据更新
    func updateContactDetail(contact:CNContact){
        self.contact=contact
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
