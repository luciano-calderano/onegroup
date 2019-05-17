//
//  MYWheel.swift
//  Lc
//
//  Created by Luciano Calderano on 10/11/16.
//  Copyright © 2016 it.kanitoKanito. All rights reserved.
//

import UIKit

class MYWheel: UIView {
    var containerColor = UIColor.darkGray
    var containerBorder = UIColor.lightGray

    private let wheel = UIActivityIndicatorView()
    init(_ startWheel: Bool = false) {
        super.init(frame: UIScreen.main.bounds)
        initialize()
        if startWheel {
            start()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize () {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.66)
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        container.center = self.center
        container.backgroundColor = containerColor
        container.alpha = 0.9
        container.clipsToBounds = true
        container.layer.cornerRadius = 10
        container.layer.borderWidth = 1
        container.layer.borderColor = containerBorder.cgColor
        addSubview(container)

        wheel.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        wheel.style = .whiteLarge
        wheel.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
        container.addSubview(wheel)
        
    }
    
    func stop () {
        wheel.stopAnimating()
        isHidden = true
        removeFromSuperview()
    }
    
    func start(_ uiView: UIView = UIApplication.shared.keyWindow!) {
        frame = uiView.bounds
        uiView.addSubview(self)
        wheel.startAnimating()
    }
}
