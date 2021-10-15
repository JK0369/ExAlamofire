//
//  LoginTarget.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Alamofire

enum LoginTarget {
    case login(LoginRequest)
    case getUserDetails(UserDetailsRequest)
}

extension LoginTarget: TargetType {

    var baseURL: String {
        return "https://www.apiserver.com"
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .getUserDetails: return .get
        }
    }

    var path: String {
        switch self {
        case .login: return "/login"
        case .getUserDetails: return "/details"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .login(let request): return .body(request)
        case .getUserDetails(let request): return .body(request)
        }
    }

}
