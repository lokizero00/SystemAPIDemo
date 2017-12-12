//
//  EditContactViewController.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/7.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Contacts

//设置代理，用于跳转返回传值
protocol UpdateContactDetailDelegate:NSObjectProtocol {
    //方法名与上一个Controller的代理传值方法一致
    func updateContactDetail(contact:CNContact)
}

class EditContactViewController: UIViewController {
    @IBOutlet weak var familyNameText:UITextField!
    @IBOutlet weak var givenNameText:UITextField!
    @IBOutlet weak var nickNameText:UITextField!
    @IBOutlet weak var userImageView:UIImageView!
    @IBOutlet weak var mobileNumberText:UITextField!
    @IBOutlet weak var emailText:UITextField!
    
    @IBOutlet weak var editContactButton:UIButton!
    
    //存放要编辑的联系人
    var contactToEdit:CNMutableContact?
    
    //定义一个代理，在跳转前由上一个Controller实例化
    var delegate:UpdateContactDetailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        editContactButton.addTarget(self, action: #selector(self.editContactButtonClicked), for: .touchUpInside)
    }
    
    //显示前调用，用于更新界面
    override func viewWillAppear(_ animated: Bool) {
        showContactDetails()
    }
    
    func showContactDetails(){
        if let _contact=contactToEdit {
            familyNameText.text=_contact.familyName
            givenNameText.text=_contact.givenName
            nickNameText.text=_contact.nickname
            if let phone=_contact.phoneNumbers.first {
                mobileNumberText.text=phone.value.stringValue
            }
            
            if let email=_contact.emailAddresses.first {
                emailText.text=email.value as String
            }
        }
    }
    
    @objc func editContactButtonClicked(){
        contactToEdit?.familyName=familyNameText.text!
        contactToEdit?.givenName=givenNameText.text!
        contactToEdit?.nickname=nickNameText.text!
        let image=userImageView.image
        contactToEdit?.imageData=UIImagePNGRepresentation(image!)
        let mobileNumber=CNPhoneNumber(stringValue: mobileNumberText.text!)
        let mobileValue=CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
        contactToEdit?.phoneNumbers=[mobileValue]
        
        //设置邮箱
        let email=CNLabeledValue(label: CNLabelHome, value: emailText.text! as NSString)
        contactToEdit?.emailAddresses=[email]
        
        if ContactManager.shared.editContactcontact(contact: contactToEdit!) {
            //判断代理是否为空
            if delegate != nil{
                //通过代理调用之前Controller的方法，将参数回传
                delegate?.updateContactDetail(contact: contactToEdit! as CNContact)
            }
            alertView(_content: "编辑成功")
        }else{
            alertView(_content: "编辑失败")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
