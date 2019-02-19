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
    static private let printJson = true
    
    private var json = JsonDict()    
    private var afType: HTTPMethod!
    private var apiUrl = ""
    private var myWheel:MYWheel?
    
    init(_ httpType: MYHttpType, param: JsonDict, showWheel: Bool = true) {
        json = param
        
        switch httpType {
        case .get:
            afType = .get
            apiUrl = Config.Url.get
        case .grant:
            afType = .post
            apiUrl = Config.Url.grant
        case .post:
            afType = .post
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
        
        let af = Alamofire.request(apiUrl, method: afType, parameters: json, headers: headers)
        af.responseJSON(completionHandler: { response in
            self.startWheel(false)
            if let json = self.fixResponse(response) {
                ok (json)
            }
        })
    }
    
// MARK: - private -
    
    private func fixResponse (_ response: DataResponse<Any>) -> JsonDict? {
        let statusCode = response.response?.statusCode
        
        if response.result.isSuccess && statusCode == 200, let dict = response.value as? JsonDict {
            return dict
        }

        var errTitle = response.error?.localizedDescription ?? "Generic error"
        if let dict = response.value as? JsonDict {
            let msg = dict.string("message")
            if msg.isEmpty == false {
                errTitle = msg
            }
        }
        let page = apiUrl.components(separatedBy: "/").last ?? apiUrl
        let errSubtitle = "\nServer error \(statusCode ?? 0)\n[ \(page) ]\n"
        
        let alert = UIAlertController(title: errTitle, message: errSubtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let ctrl = UIApplication.shared.keyWindow?.rootViewController {
            ctrl.present(alert, animated: true, completion: nil)
        }
        return nil
    }
    
    private func printJson (_ json: JsonDict) {
        if MYHttp.printJson {
            print("\n[ \(apiUrl) ]\n\(json)\n------------")
        }
    }
    
    private func startWheel(_ start: Bool, inView: UIView = UIApplication.shared.keyWindow!) {
        if start {
            myWheel = MYWheel()
            myWheel?.start(inView)
            return
        }
        if let wheel = myWheel {
            wheel.stop()
            myWheel = nil
        }
    }
}
