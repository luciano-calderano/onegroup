//
//  WebPage
//  MysteryClient
//
//  Created by mac on 26/06/17.
//  Copyright © 2017 Mebius. All rights reserved.
//

import UIKit
import WebKit

class WebPage: MyViewController {
    class func Instance() -> WebPage {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let ctrlId = String (describing: self)
        return sb.instantiateViewController(withIdentifier: ctrlId) as! WebPage
    }
    
    var page = ""
    
    @IBOutlet private var container: UIView!
    
    private var webView = WKWebView()
    private let wheel = MYWheel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.isUserInteractionEnabled = true
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if page.isEmpty {
            return
        }
        User.shared.login { (response) in
            self.wheel.start()
            var request = URLRequest(url: URL(string: self.page)!)
            request.setValue("Bearer " + User.shared.token, forHTTPHeaderField: "Authorization")
            self.webView.load(request)
        }
    }
    
    @IBAction func backTapped () {
        navigationController?.popViewController(animated: true)
    }
}

extension WebPage: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        wheel.stop()
        let alert = UIAlertController(title: error.localizedDescription,
                                      message: "",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        wheel.stop()
        webView.frame = container.bounds
        container.addSubview(webView)
        container.isHidden = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(navigationResponse.response)
        decisionHandler(.allow)
    }
}
