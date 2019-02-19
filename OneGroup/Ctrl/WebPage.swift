//
//  WebPage
//  MysteryClient
//
//  Created by mac on 26/06/17.
//  Copyright © 2017 Mebius. All rights reserved.
//

import UIKit
import WebKit
import Photos
import Alamofire

class WebPage: MyViewController {
    class func Instance() -> WebPage {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let ctrlId = String (describing: self)
        return sb.instantiateViewController(withIdentifier: ctrlId) as! WebPage
    }
    
    var page = ""
    var needToken = true
    var uploadUrl: URL!
    
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
        if needToken == false {
            wheel.start()
            let request = URLRequest(url: URL(string: page)!)
            webView.load(request)
            return
        }
        User.shared.login { (response) in
            self.openPage()
        }
    }
    
    @IBAction func backTapped () {
        navigationController?.popViewController(animated: true)
    }
    
    private func openPage () {
        wheel.start()
        var request = URLRequest(url: URL(string: page)!)
        request.setValue("Bearer " + User.shared.token, forHTTPHeaderField: "Authorization")
        webView.load(request)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("navigationAction > \(String(describing: webView.url?.absoluteString))")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print(navigationResponse.response)
        print("navigationResponse > \(String(describing: webView.url?.absoluteString))")
        if let url = webView.url, url.absoluteString.contains("ios=1") {
            decisionHandler(.cancel)
            let s = url.absoluteString
            let u = s.replacingOccurrences(of: ".it/", with: ".it/api/")
            uploadUrl = URL(string: u)
            upload()
            return
        }
        
        decisionHandler(.allow)
    }
}

extension WebPage {
    private func upload () {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary // | .camera
        picker.delegate = self

        let alert = UIAlertController(title: "Invia una foto",
                                      message: "",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Scatta una foto",
                                      style: .default,
                                      handler: { (action) in
                                        self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Carica dalla galleria",
                                      style: .default,
                                      handler: { (action) in
                                        self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "Annulla",
                                      style: .cancel,
                                      handler: { (action) in
        }))
        
        present(alert, animated: true) { }

    }
    
    private func openGallary() {
        presentPicker(type: .photoLibrary)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable (.camera) else {
            let alert = UIAlertController(title: "Camera Not Found",
                                          message: "This device has no Camera",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        presentPicker(type: .camera)
    }
    
    private func presentPicker (type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = false
        if type == .camera {
            picker.cameraCaptureMode = .photo
        }
        present(picker, animated: true)
    }
}

//MARK:-

extension WebPage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func close () {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        close()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertDict(info)
        let imgKey = convertKey(UIImagePickerController.InfoKey.originalImage)
        
        if let pickedImage = info[imgKey] as? UIImage {
            uploadImage(pickedImage)
        }
        close()
    }
    
    fileprivate func convertDict(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

extension WebPage {
    private func uploadImage (_ img: UIImage) {
        let data = Data(img.jpegData(compressionQuality: 0.7)!)
        let headers = [
            "Authorization" : "Bearer " + User.shared.token
        ]
        
        let request: URLRequest!
        do {
            let req = try URLRequest(url: uploadUrl, method: .post, headers: headers)
            request = req
        }
        catch {
            self.error("uploadImage: URLRequest error")
            return
        }
        
        let spliturl = uploadUrl.absoluteString.components(separatedBy: "?")
        let paramUrl = spliturl.last?.components(separatedBy: "&")
        
        let fileName = Date().toString(withFormat: "yyMMddHHmmss") + ".jpg"
        var parameters = [
            "file" : fileName
        ]
        for (value) in paramUrl! {
            let split = value.components(separatedBy: "=")
            if split.count == 2 {
                parameters[split.first!] = split.last!
            }
        }

        let wheel = MYWheel(true)
//        wheel.start(self.view)
        
        func append (_ formData: MultipartFormData) {
            formData.append(data, withName: "object_file", fileName: fileName, mimeType: "multipart/form-data")
            for (key, value) in parameters {
                formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }
        
        func validateResult (_ result: SessionManager.MultipartFormDataEncodingResult) {
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON {
                    (response) in
                    wheel.stop()
                    self.done()
                }
            case .failure(let encodingError):
                wheel.stop()
                self.error(encodingError.localizedDescription)
            }
        }
        
        Alamofire.upload(multipartFormData: {
            (formData) in append(formData)
        }, with: request, encodingCompletion: {
            (result) in validateResult (result)
        })
    }

    private func done() {
        print("\nUpload done:\n")
        
        let alert = UIAlertController(title: "", message: "Foto caricata", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.openPage()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func error(_ err: String) {
        print("\nUpload error:\n", err)

        let alert = UIAlertController(title: "Errore", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.openPage()
        }))
        present(alert, animated: true, completion: nil)
    }
}
