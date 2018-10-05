//
//  MYHttp.swift
//  MysteryClient
//
//  Created by mac on 17/08/17.
//  Copyright © 2017 Mebius. All rights reserved.
//
enum MYHttpType {
    case grant
    case get
    case post
}

import Foundation
import Alamofire

class MYHttp {
    struct Error {
        public var title = ""
        public var message = ""
    }
    
    static let printJson = true
    
    private var json = JsonDict()    
    private var type: HTTPMethod!
    private var apiUrl = ""
    
    private var myWheel:MYWheel?
    
    init(_ httpType: MYHttpType, param: JsonDict, showWheel: Bool = true) {
        json = param
        
        switch httpType {
        case .get:
            type = .get
            apiUrl = Config.Url.get
        case .grant:
            type = .post
            apiUrl = Config.Url.grant
        case .post:
            type = .post
            apiUrl = Config.Url.post
        }
        
        self.startWheel(showWheel)
    }
    
    func load(ok: @escaping (JsonDict) -> ()) {
        printJson(json)
        var headers = [String: String]()
//        headers["content-type"] = "application/json"
        if Config.Auth.token.count > 0 {
            headers["Authorization"] = Config.Auth.header + Config.Auth.token
        }
        
        Alamofire.request(apiUrl,
                          method: type,
                          parameters: json,
                          headers: headers).responseJSON(completionHandler: { response in
                            self.startWheel(false)
                            if let json = self.fixResponse(response) {
                                ok (json)
                            }
        })
    }
    
    private func fixResponse (_ response: DataResponse<Any>) -> JsonDict? {
        let statusCode = response.response?.statusCode
        let array = apiUrl.components(separatedBy: "/")
        let page = array.last ?? apiUrl
        
        if response.result.isSuccess && statusCode == 200 {
            let dict = response.value as! JsonDict
            return dict
        }
        let errorMessage = response.error == nil ? "Server error" :  (response.error?.localizedDescription)!
        let err = Error(title: "Server error \(statusCode ?? 0)\n[ \(page) ]", message: errorMessage)

        let error = err
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let ctrl = UIApplication.shared.keyWindow?.rootViewController
        ctrl?.present(alert, animated: true, completion: nil)
        return nil
    }
    
    // MARK: - private
    
    fileprivate func printJson (_ json: JsonDict) {
        if MYHttp.printJson {
            print("\n[ \(apiUrl) ]\n\(json)\n------------")
        }
    }
    
    fileprivate func startWheel(_ start: Bool, inView: UIView = UIApplication.shared.keyWindow!) {
        if start {
            myWheel = MYWheel()
            myWheel?.start(inView)
        }
        else {
            if let wheel = myWheel {
                wheel.stop()
                myWheel = nil
            }
        }
    }
}
