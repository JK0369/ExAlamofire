//
//  KeychainService.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation

protocol KeychainService {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}

class KeychainServiceImpl: KeychainService {
    static let shared = KeychainServiceImpl()
    private init() {}

    struct Key {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }

    private let keychainAccess = KeychainAccessImpl()

    var accessToken: String? {
        get { keychainAccess.get(Key.accessToken) }
        set {
            if accessToken != nil {
                keychainAccess.save(Key.accessToken, newValue ?? "")
            } else {
                keychainAccess.remove(Key.accessToken)
            }
        }
    }
    var refreshToken: String? {
        get { keychainAccess.get(Key.refreshToken) }
        set {
            if refreshToken != nil {
                keychainAccess.save(Key.refreshToken, newValue ?? "")
            } else {
                keychainAccess.remove(Key.refreshToken)
            }
        }
    }
}
