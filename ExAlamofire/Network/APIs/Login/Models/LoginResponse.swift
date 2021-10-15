//
//  LoginResponse.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation

struct LoginResponse: Decodable {
    let name: String
    let accessToken: String
    let refreshToken: String
}

extension LoginResponse {
    var toDomain: Login {
        return Login(name: name)
    }
}
