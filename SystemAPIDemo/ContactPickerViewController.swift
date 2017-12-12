//
//  AddressBookViewController.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/1.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import ContactsUI

class ContactPickerViewController: UIViewController ,CNContactPickerDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var selectContactButton:UIButton!
    @IBOutlet weak var resultTableView:UITableView!
    
    var allResults:Dictionary<Int,[String]>?
    var tbHeaders:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title="选取联系人"
        self.view.backgroundColor=UIColor.white
        
        selectContactButton.isEnabled=false
        self.resultTableView.dataSource=self
        self.resultTableView.delegate=self
        
        selectContactButton.addTarget(self, action: #selector(self.selectContacts), for: .touchUpInside)
        
        noContatsResult()
        checkAccess()
    }
    
    func checkAccess() {
        CNContactStore().requestAccess(for: .contacts, completionHandler: {
            (isRight,error) in
            if isRight{
                DispatchQueue.main.async {
                    self.selectContactButton.isEnabled=true
                }
            }else{
                self.alertView(_content: "没有权限")
            }
        })
    }
    
    @objc func selectContacts(){
       let contactPicker=CNContactPickerViewController()
        contactPicker.delegate=self
        //设置联系人过滤条件，不符合的联系人将无法选取
//        contactPicker.predicateForEnablingContact=NSPredicate(format: "givenName CONTAINS %@ && phoneNumbers.@count > 0", "D")
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey,CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allResults![section]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tbHeaders?[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tbHeaders!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idenfify="contactResultCell"
        var cell=resultTableView.dequeueReusableCell(withIdentifier: idenfify)
        
        if cell == nil {
            cell=UITableViewCell(style: .default, reuseIdentifier: idenfify)
            
            cell?.textLabel?.font=UIFont.systemFont(ofSize: 14)
            cell?.selectionStyle = .gray
            cell?.accessoryType = .disclosureIndicator
        }
        
        cell?.textLabel?.text=allResults![indexPath.section]?[indexPath.row]
        
        return cell!;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //方法A，实现此方法，则方法B失效
    //单联系人选择，当用户从列表里选择联系人后，触发此方法，并不进入联系人详情页
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        initTableViewData()
        
        let lastName=contact.familyName
        let firstName=contact.givenName
        
        self.tbHeaders?.append("第1组联系人")
        self.allResults![0]?=["姓名：\(firstName)-\(lastName)"]
        
        let phones=contact.phoneNumbers
        for phone in phones{
            let phoneLabel=CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
            let phoneValue=phone.value.stringValue
            self.allResults![0]?.append("\(phoneLabel)：\(phoneValue)")
        }
        
        resultTableView.reloadData()
    }
    
    func initTableViewData(){
        self.allResults?.removeAll()
        self.tbHeaders?.removeAll()
    }
    
    func noContatsResult(){
        self.allResults =  [
            0:[String]([
                "暂无数据"])
        ];
        self.tbHeaders = [
            "无联系人"
        ]
    }
    
//    //方法B，需要注释方法A和C才能有效
//    //选择联系人后，将进入详情页，当点击相应联系人属性时，触发此方法
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
//        let contact = contactProperty.contact
//
//        let phoneNumber = contactProperty.value as! CNPhoneNumber
//
//        print(contact.givenName)
//
//        print(phoneNumber.stringValue)
//    }
    
    //方法C，实现此方法，则方法A失效
    //多联系人选择
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        initTableViewData()
        
        if contacts.count>0{
            for contact in contacts {
                let lastName=contact.familyName
                let firstName=contact.givenName
                let c_index=contacts.index(of: contact)
                
                self.tbHeaders?.append("第\((c_index!+1))组联系人")
                self.allResults![c_index!]=["姓名：\(firstName)-\(lastName)"]
                
                let phones=contact.phoneNumbers
                for phone in phones{
                    let phoneLabel=CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
                    let phoneValue=phone.value.stringValue
                    self.allResults![c_index!]?.append("\(phoneLabel)：\(phoneValue)")
                }
            }
        }else{
            noContatsResult()
        }
        
        resultTableView.reloadData()
    }
    
    //消息提示
    func alertView(_content:String) {
        let alertVC = UIAlertController(title: "消息", message: _content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            /**
             写确定后操作
             */
        })
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
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
