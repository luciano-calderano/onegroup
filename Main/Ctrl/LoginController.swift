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
    @IBOutlet var logupBtn: UIButton!

    let check = UIImage.init(named: "check")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.delegate = self
        passText.delegate = self
 
        userView.layer.cornerRadius = userView.frame.height / 2
        passView.layer.cornerRadius = passView.frame.height / 2
        loginBtn.layer.cornerRadius = 5
        logupBtn.layer.cornerRadius = 5

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
        userText.text = "strumenti4web@gmail.com"
        passText.text = "okokok"
        #endif
        
        if ((userText.text?.count)! > 0 && (passText.text?.count)! > 0) {
            selectButton(btn: saveCredBtn)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if event?.allTouches?.first?.view == view {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
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
                            let resp = response as! [Any]
                            
                            ctrl.menu = resp.first as! String
                            if resp.count > 1 {
                                ctrl.social = resp[1]
                            }
                            
                            self.navigationController?.show(ctrl, sender: self)
        }
    }
    
    @IBAction func passForgotSelected () {
        openPage(Config.Url.passReset)
    }

    @IBAction func registerSelected () {
        openPage(Config.Url.register)
    }
    
    private func openPage(_ page: String, needToken: Bool = false) {
        let ctrl = WebPage.Instance()
        ctrl.needToken = needToken
        ctrl.page = page
        navigationController?.show(ctrl, sender: self)
    }
    
    private func selectButton(btn: UIButton){
        if (btn.tag > 0) {
            btn.tag = 0
            btn.setBackgroundImage(UIImage(), for: .normal)
        } else {
            btn.tag = 1
            btn.setBackgroundImage(check, for: .normal)
        }
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userText {
            passText.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
}

