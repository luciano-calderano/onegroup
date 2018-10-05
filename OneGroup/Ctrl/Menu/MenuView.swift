//
//  ViewController.swift
//  MysteryClient
//
//  Created by mac on 21/06/17.
//  Copyright © 2017 Mebius. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func menuSelectedItem(atIndex index: Int)
    func menuLogout()
}

class MenuView: UIView {
    class func Instance() -> MenuView {
        let viewName = String (describing: self)
        let array = Bundle.main.loadNibNamed(viewName, owner: self, options: nil)
        return array!.first as! MenuView
    }

    var delegate: MenuViewDelegate?
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var backView: UIView!
    @IBOutlet private var topView: UIView!
    @IBOutlet private var titleLabel: UILabel!

    var dataArray = [String]()
    let cellId = "MenuCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapBack = UITapGestureRecognizer.init(target: self, action: #selector(closeMenu))
        self.backView.addGestureRecognizer(tapBack)
        titleLabel.text = "One Group 1.0"
    }
    
    @IBAction func closeMenu () {
        menuHide()
    }
    
    @IBAction func logout () {
        delegate?.menuLogout()
    }
    
    func menuHide () {
        UIView.animate(withDuration: 0.2, animations: {
            var rect = self.frame
            rect.origin.x = -rect.size.width
            self.frame = rect
        }) { (true) in
            self.isHidden = true
        }
    }

    func menuShow () {
        self.isHidden = false
        UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 0.1,
                                   options: .curveEaseInOut,
                                   animations: {
            var rect = self.frame
            rect.origin.x = 0
            self.frame = rect
        })
    }
}

// MARK:- UITableViewDataSource

extension MenuView: UITableViewDataSource {
    func maxItemOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellId);
        }
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell!
    }
}

// MARK:- UITableViewDelegate

extension MenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        menuHide()
        self.delegate?.menuSelectedItem(atIndex: indexPath.row)
    }
}
