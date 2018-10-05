//
//  ViewController.swift
//  OneGroup
//
//  Created by Developer on 31/07/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class LoginController: MyViewController {
    
    @IBOutlet var userView: UIView!
    @IBOutlet var passView: UIView!
    
    @IBOutlet var userText: UITextField!
    @IBOutlet var passText: UITextField!
    
    @IBOutlet var saveCredBtn: UIButton!
    @IBOutlet var showPassBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    let check = UIImage.init(named: "check")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ctrl =  (UIApplication.shared.keyWindow?.rootViewController)!
//        let view = ctrl.view!
//        let imageView = Config.backImage
//        imageView.frame = view.frame
//        imageView.contentMode =  UIViewContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        view.addSubview(imageView)
//        view.sendSubview(toBack: imageView)

        userView.layer.cornerRadius = userView.frame.height / 2
        passView.layer.cornerRadius = passView.frame.height / 2
        loginBtn.layer.cornerRadius = 5
        
        saveCredBtn.layer.borderColor = UIColor.white.cgColor
        saveCredBtn.layer.borderWidth = 2
        showPassBtn.layer.borderColor = UIColor.white.cgColor
        showPassBtn.layer.borderWidth = 2
        
        let me = User.shared.getUser()
        userText.text = me.user
        passText.text = me.pass
        
        #if DEBUG
        userText.text = "admin@admin.it"
        passText.text = "admin_0n3"
        #endif
        
        if ((userText.text?.count)! > 0 && (passText.text?.count)! > 0) {
            selectButton(btn: saveCredBtn)
        }
    }
    
    @IBAction func saveSelected () {
        selectButton(btn: saveCredBtn)
    }
    @IBAction func showSelected () {
        selectButton(btn: showPassBtn)
        passText.isSecureTextEntry = showPassBtn.tag == 0
    }
    
    @IBAction func loginSelected () {
        if (userText.text?.count == 0){
            userText.becomeFirstResponder()
            return
        }
        if (passText.text?.count == 0){
            passText.becomeFirstResponder()
            return
        }
        
        User.shared.login(withUser: userText.text!,
                          password: passText.text!,
                          saveData: saveCredBtn.tag > 0) { (response) in
                            let ctrl = HomeController.Instance()
                            ctrl.menu = response as! String
                            self.navigationController?.show(ctrl, sender: self)
        }
    }
    func selectButton(btn: UIButton){
        if (btn.tag > 0) {
            btn.tag = 0
            btn.setBackgroundImage(UIImage(), for: .normal)
        } else {
            btn.tag = 1
            btn.setBackgroundImage(check, for: .normal)
        }
    }
}
