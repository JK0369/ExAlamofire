//
//  API.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Alamofire

class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}
