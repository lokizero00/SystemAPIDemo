//
//  MessagesViewController.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/8.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI

class MessagesViewController: UIViewController, MFMessageComposeViewControllerDelegate,CNContactPickerDelegate,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var messageContextTextView:UITextView!
    @IBOutlet weak var pickerContactButton:UIButton!
    @IBOutlet weak var phoneLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var sendEmailButton:UIButton!
    @IBOutlet weak var phoneCallButton:UIButton!
    @IBOutlet weak var sendSMSButton:UIButton!
    @IBOutlet weak var phoneErrorLabel:UILabel!
    @IBOutlet weak var emailErrorLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="短信&电话&邮件"
        self.view.backgroundColor=UIColor.white
        
        //错误标签
        phoneErrorLabel.isHidden=true
        emailErrorLabel.isHidden=true
        
        pickerContactButton.addTarget(self, action: #selector(self.pickerContactButtonClicked), for: .touchUpInside)
        sendSMSButton.addTarget(self, action: #selector(self.sendSMSButtonClicked), for: .touchUpInside)
        sendEmailButton.addTarget(self, action: #selector(self.sendEmailButtonClicked), for: .touchUpInside)
        phoneCallButton.addTarget(self, action: #selector(self.phoneCallButtonClicked), for: .touchUpInside)
        
        //检查权限
        checkAccess()
    }
    
    func checkAccess() {
        CNContactStore().requestAccess(for: .contacts, completionHandler: {
            (isRight,error) in
            if !isRight{
                DispatchQueue.main.async {
                    self.pickerContactButton.isEnabled=false
                }
                self.alertView(_content: "没有权限")
            }
        })
    }
    
    @objc func sendEmailButtonClicked(){
//        检测系统是否支持发送邮件
        if MFMailComposeViewController.canSendMail() {
            let picker=MFMailComposeViewController()
            picker.mailComposeDelegate=self
            
            //设置主题
            picker.setSubject("这是一封测试邮件")
            picker.setToRecipients(["\(emailLabel.text!)"])
            //设置抄送人
            picker.setCcRecipients(["lokizero0@live.com"])
            //设置密送人
            picker.setBccRecipients(["350633374@qq.com"])
            
            //添加图片附件
            let path=Bundle.main.path(forResource: "barIconBasic25.png", ofType: "")
            if let myData=NSData(contentsOfFile: path!) {
                picker.addAttachmentData(myData as Data, mimeType: "image/png", fileName: "swift.png")
            }
            //设置邮件正文内容--支持html
            picker.setMessageBody("\(messageContextTextView.text)", isHTML: false)
            self.present(picker, animated: true, completion: nil)
        }else{
            alertView(_content: "本设备不能发邮件")
        }
    }
    
    @objc func phoneCallButtonClicked(){
        let urlString="tel://\(phoneLabel.text!)"
        if let url=URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                //做后续处理
            })
        }
    }
    
    @objc func sendSMSButtonClicked(){
//        检测系统是否支持发送短信
        if MFMessageComposeViewController.canSendText() {
            let controller=MFMessageComposeViewController()
            
            //设置短信内容
            controller.body=messageContextTextView.text
            //设置收信人
            controller.recipients=["\(phoneLabel.text!)"]
            
            controller.messageComposeDelegate=self
            
            self.present(controller, animated: true, completion: nil)
        }else{
            self.alertView(_content: "本设备不能发送短信")
        }
    }
    
    @objc func pickerContactButtonClicked(){
        let contactPicker=CNContactPickerViewController()
        contactPicker.delegate=self
        //设置联系人过滤条件，不符合的联系人将无法选取
        //        contactPicker.predicateForEnablingContact=NSPredicate(format: "givenName CONTAINS %@ && phoneNumbers.@count > 0", "D")
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey,CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
        self.present(contactPicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .cancelled:
            alertView(_content: "邮件已取消")
        case .saved:
            alertView(_content: "邮件已保存")
        case .sent:
            alertView(_content: "邮件已发送")
        case .failed:
            alertView(_content: "邮件发送失败")
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if let phone=contact.phoneNumbers.first {
            phoneErrorLabel.isHidden=true
            phoneLabel.text=phone.value.stringValue
        }else{
            phoneErrorLabel.isHidden=false
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        switch result{
        case MessageComposeResult.sent:
            alertView(_content: "短信已发送")
        case .cancelled:
            alertView(_content: "短信已取消")
        case .failed:
            alertView(_content: "短信发送失败")
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
