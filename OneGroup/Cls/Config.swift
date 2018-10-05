//
//  Config.swift
//  MysteryClient
//
//  Created by mac on 26/06/17.
//  Copyright © 2017 Mebius. All rights reserved.
//
// git: mcappios@git.mebius.it:projects/mcappios - Pw: Mc4ppIos
// web: mysteryclient.mebius.it - User: utente_gen - Pw: novella44

import Foundation
import LcLib

typealias JsonDict = Dictionary<String, Any>
func Lng(_ key: String) -> String {
    return MYLang.value(key)
}

struct Config {
    struct Url {
        static let home  = "http://onegroup.mebius.it/"
        static let grant = Config.Url.home + "oauth/access_token"
        static let get   = Config.Url.home + "default/rest/get"
        static let post  = Config.Url.home + "default/rest/post"
    }
    struct Auth {
        static let header = "Auth "
        static var token = ""
    }
    static let backImage = UIImageView.init(image: UIImage.init(named: "Sfondo.jpg"))
}

//MARK:-

class MyViewController: UIViewController {
    class BackImage  {
        static let shared = BackImage()
        public func addBackImage (_ ctrl: UIViewController) {
            let view = ctrl.view!
            let imageView = Config.backImage
            imageView.frame = view.frame
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            view.addSubview(imageView)
            view.sendSubviewToBack(imageView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BackImage.shared.addBackImage(self)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK:-

class MyBackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize () {
        self.showsTouchWhenHighlighted = true
        self.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
}
