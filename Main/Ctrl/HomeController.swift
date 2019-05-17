//
//  HomeController.swift
//  OneGroup
//
//  Created by Developer on 01/08/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

class HomeController: MyViewController {
    class func Instance() -> HomeController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let ctrlId = String (describing: self)
        return sb.instantiateViewController(withIdentifier: ctrlId) as! HomeController
    }

    var menu = "" {
        didSet {
            createMenu()
        }
    }
    
//    @IBOutlet var menuButton: MyBackButton!
    @IBOutlet var homeTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var sponsorImage: UIImageView!

    private var dataArray = [String]()
    private var menuDict = JsonDict()
    private let menuView = MenuView.Instance()

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.backgroundColor = UIColor.clear
        homeTableView.separatorColor = UIColor.clear
        
//        tableViewHeight.constant = CGFloat(dataArray.count * 80)
//        if (tableViewHeight.constant > 400) {
//            tableViewHeight.constant = 400
//        }
//        
        menuView.isHidden = true
        menuView.delegate = self
        menuView.dataArray = dataArray;
        view.addSubview(menuView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSponsor()
        getSponsor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var rect = self.view.frame
        rect.origin.x = -rect.size.width
        rect.origin.y = 20
        rect.size.height -= rect.origin.y
        menuView.frame = rect
    }
    
    @IBAction func menuTapped () {
        menuView.menuShow()
    }
    
    private func createMenu() {
        menuDict = menu.toJSON() as! JsonDict
        for key in menuDict.keys {
            dataArray.append(key)
        }
    }
    
    private func selectedItem (atIndex index: Int) {
        let key = dataArray[index]
        let page = menuDict.string(key)
        let ctrl = WebPage.Instance()
        ctrl.page = page
        navigationController?.show(ctrl, sender: self)
    }
    
    private func getSponsor () {
        do {
            let data = try Data(contentsOf: Config.Url.sponsor!)
            try data.write(to: Config.Url.sponsorFile)
            loadSponsor()
        }
        catch {
            print("errore sponsor")
        }
    }

    private func loadSponsor () {
        
        do {
            let data = try Data(contentsOf: Config.Url.sponsorFile)
            sponsorImage.image = UIImage(data: data)
            sponsorImage.isHidden = false
        }
        catch {
            sponsorImage.isHidden = true
        }
    }
}

//MARK: - UITableViewDataSource

extension HomeController: UITableViewDataSource {
    func maxItemOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeCell.dequeue(tableView, indexPath)
        cell.title = dataArray[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedItem(atIndex: indexPath.row)
    }
}

//MARK: -

extension HomeController: MenuViewDelegate {
    func menuSelectedItem(atIndex index: Int) {
        selectedItem(atIndex: index)
    }
    
    func menuLogout() {
        navigationController?.popToRootViewController(animated: true)
    }
}


class HomeCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, _ indexPath: IndexPath) -> HomeCell {
        return tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
    }
    
    @IBOutlet var titleLabel: UILabel!

    var title: String = "" {
        didSet {
            update ()
        }
    }

    override func awakeFromNib() {
        titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
        titleLabel.layer.masksToBounds = true
        titleLabel.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    private func update() {
        titleLabel.text = title
    }
}
