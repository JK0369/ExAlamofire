//
//  LoginRequest.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation

struct LoginRequest: Encodable {
    let userName: String
    let password: String
}
