//
//  ContactManager.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/6.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Contacts

class ContactManager:NSObject {
    //将联系人管理类声明为单例类，管理所有联系人的操作
    static let shared:ContactManager={
        let contactManager=ContactManager()
        return contactManager
    }()
    
    //联系人数组
    var contactsList=[CNContact]()
    
    //所有联系人
    func fetchContacts(){
        //创建通讯录对象
        let store=CNContactStore()
        var allContacts=[CNContact]()
        let keys = [CNContactGivenNameKey,CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey,CNContactNicknameKey]
        
        //检索联系人，通过匹配条件返回数组
//        let predicate = CNContact.predicateForContacts(matchingName: "loki")
//        do{
//            allContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
//        }catch{
//            print(error.localizedDescription)
//        }
        
        //遍历所有联系人
        let request=CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do{
            try store.enumerateContacts(with: request, usingBlock: {
                (contact:CNContact,stop:UnsafeMutablePointer<ObjCBool>) -> Void in
               allContacts.append(contact)
            })
        }catch{
            print(error.localizedDescription)
        }
        
        contactsList=allContacts
    }
    
    //新增
    func addContact(contact:CNMutableContact) -> Bool {
        //创建通讯录对象
        let store=CNContactStore()
        
        //添加联系人请求
        let saveRequest=CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do{
            //写入联系人
            try store.execute(saveRequest)
            return true
        }catch{
            print(error.localizedDescription)
            return false
        }
    }
    
    //编辑
    func editContactcontact(contact:CNMutableContact) -> Bool {
        let store=CNContactStore()
        let editRequest=CNSaveRequest()
        editRequest.update(contact)
        
        do{
            try store.execute(editRequest)
            return true
        }catch{
            print(error.localizedDescription)
            return false
        }
    }
    
    //删除
    func deleteContact(_index:Int) -> Bool{
        let store=CNContactStore()
        let deleteRequest=CNSaveRequest()
        
        let contactToDelete=contactsList[_index].mutableCopy() as! CNMutableContact
        deleteRequest.delete(contactToDelete)
        contactsList.remove(at: _index)
        
        do{
            //删除联系人
            try store.execute(deleteRequest)
            return true
        }catch{
            print(error.localizedDescription)
            return false
        }
    }
}
