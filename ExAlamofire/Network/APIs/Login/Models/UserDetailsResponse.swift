//
//  UserDetailsResponse.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation

struct UserDetailsResponse: Decodable {
    let name: String
}

extension UserDetailsResponse {
    var toDomain: Login {
        return Login(name: name)
    }
}
