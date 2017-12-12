//
//  ContactsViewController.swift
//  SystemAPIDemo
//
//  Created by lokizero00 on 2017/12/6.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var contactsTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="联系人"
        self.view.backgroundColor=UIColor.white
        
        self.contactsTableView.delegate=self
        self.contactsTableView.dataSource=self
        
        self.contactsTableView.register(UINib(nibName:"ContactCell",bundle:nil), forCellReuseIdentifier: "contactCellIdentify")
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonClicked))
        
        //检查权限
        checkAccess()
    }
    
    func checkAccess() {
        CNContactStore().requestAccess(for: .contacts, completionHandler: {
            (isRight,error) in
            if !isRight{
                self.navigationItem.rightBarButtonItem?.isEnabled=false
                self.alertView(_content: "没有权限")
            }
        })
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addButtonClicked(){
        let addCtl=AddContactViewController()
        addCtl.navigationItem.title="添加"
        navigationController?.pushViewController(addCtl, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactManager.shared.contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentify="contactCellIdentify"
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath) as! ContactCell
        let contact=ContactManager.shared.contactsList[indexPath.row]
        
        cell.cellWithContact(contact: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailCtl=ContactDetailViewController()
        detailCtl.contact=ContactManager.shared.contactsList[indexPath.row]
        detailCtl.navigationItem.title="详情"
        navigationController?.pushViewController(detailCtl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if ContactManager.shared.deleteContact(_index: indexPath.row) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }else{
                alertView(_content: "删除失败")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ContactManager.shared.fetchContacts()
        contactsTableView.reloadData()
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
