//
//  KeychainAccessible.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import KeychainAccess

protocol KeychainAccessible {
    func save(_ key: String, _ value: String)
    func get(_ key: String) -> String?
    func remove(_ key: String)
    func removeAll()
}

public class KeychainAccessImpl: KeychainAccessible {
    private let keychain = Keychain()

    func save(_ key: String, _ value: String) {
        do {
            if let encryptValue = Crypto.encrypt(input: value) {
                try keychain.set(encryptValue, key: key)
            } else {
                print("CRPYTO SAVED FAILED \(key), \(value)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func get(_ key: String) -> String? {
        var decrypt: String?
        if let value = keychain[string: key] {
            decrypt = Crypto.decrypt(input: value)
        }

        return decrypt
    }

    func remove(_ key: String) {
        do {
            try keychain.remove(key)
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeAll() {
        do {
            try keychain.removeAll()
        } catch {
            print(error.localizedDescription)
        }
    }
}
