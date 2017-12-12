//
//  AddContactViewController.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/5.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Contacts

class AddContactViewController: UIViewController {
    @IBOutlet weak var familyNameText:UITextField!
    @IBOutlet weak var givenNameText:UITextField!
    @IBOutlet weak var nickNameText:UITextField!
    @IBOutlet weak var userImageView:UIImageView!
    @IBOutlet weak var mobileNumberText:UITextField!
    @IBOutlet weak var emailText:UITextField!
    
    @IBOutlet weak var addContactButton:UIButton!
    
    let contactManager=ContactManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor=UIColor.white
        addContactButton.addTarget(self, action: #selector(self.addContactButtonClicked), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addContactButtonClicked(){
        //创建CNMutableContact类型的实例
        let contactToAdd=CNMutableContact()
        
        //设置姓名
        contactToAdd.familyName=familyNameText.text!
        contactToAdd.givenName=givenNameText.text!
        
        //设置昵称
        contactToAdd.nickname=nickNameText.text!
        
        //设置头像
        let image=userImageView.image
        contactToAdd.imageData=UIImagePNGRepresentation(image!)
        
        //设置电话
        let mobileNumber=CNPhoneNumber(stringValue: mobileNumberText.text!)
        let mobileValue=CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
        contactToAdd.phoneNumbers=[mobileValue]
        
        //设置邮箱
        let email=CNLabeledValue(label: CNLabelHome, value: emailText.text! as NSString)
        contactToAdd.emailAddresses=[email]
        
        if contactManager.addContact(contact: contactToAdd) {
            alertView(_content: "保存成功")
        }else{
            alertView(_content: "保存失败")
        }
        
    }
    
    //消息提示
    func alertView(_content:String) {
        let alertVC = UIAlertController(title: "消息", message: _content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
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
