//
//  Crypto.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Security

public class Crypto {

    static let privTag = Bundle.main.bundleIdentifier!
    static let SecureEnclaveAccess = SecAccessControlCreateWithFlags(
        kCFAllocatorDefault,
        kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        .privateKeyUsage,
        nil
    )

    static var EnclaveAttribute: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        kSecAttrKeySizeInBits as String: 256,
        kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
        kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrAccessControl as String: SecureEnclaveAccess!
        ]
    ]

    // kSecAttrAccessControl as String:    access
    static var NonEnclaveAttribute: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        kSecAttrKeySizeInBits as String: 256,
        kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privTag
        ]
    ]

    public class func getPubKey() -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status != errSecSuccess {
            print("priv key get failed.. generate new key")
            generateKey()
            SecItemCopyMatching(query as CFDictionary, &result)
        }

        // swiftlint:disable force_cast superfluous_disable_command
        let privKey: SecKey = result as! SecKey
        // swiftlint:enable force_cast superfluous_disable_command
        let pubKey = SecKeyCopyPublicKey(privKey)!
        return pubKey
    }

    public class func getPrivKey() -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status != errSecSuccess {
            print("priv key get failed.. generate new key")
            SecItemDelete(query as CFDictionary)
            generateKey()
            let new = SecItemCopyMatching(query as CFDictionary, &result)
            print(new)
        }
        // swiftlint:disable force_cast superfluous_disable_command
        let privKey: SecKey = result as! SecKey
        // swiftlint:enable force_cast superfluous_disable_command
        return privKey
    }

    public class func deleteKey() {
        let privquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true
        ]
        let code = SecItemDelete(privquery as CFDictionary)
        if code == errSecSuccess {
            print("Key Delete Complete!")
        } else {
            print("Delete Failed!!")
            print(code)
        }
    }
    public class func generateKeyNoEnclave() {
        var error: Unmanaged<CFError>?
        // 기기가 SecureEnclave를 지원하지 않는 경우, 일반 암호화 키 생성 후 키체인에 저장
        _ = SecKeyCreateRandomKey(NonEnclaveAttribute as CFDictionary, &error)
    }

    public class func generateKey() {
        var error: Unmanaged<CFError>?
        var privKey = SecKeyCreateRandomKey(EnclaveAttribute as CFDictionary, &error) // Secure Enclave 키 생성
        if privKey == nil { // 단말기가 Secure Enclave를 지원하지 않는 경우
            print("Secure Enclave Not Supported.")
            privKey = SecKeyCreateRandomKey(NonEnclaveAttribute as CFDictionary, &error)
        }
    }

    public class func encrypt(input: String) -> String? {
        let pubKey: SecKey = getPubKey()
        print(pubKey)
        var error: Unmanaged<CFError>?

        let plain: CFData = input.data(using: .utf8)! as CFData
        let encData = SecKeyCreateEncryptedData(pubKey, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, plain, &error)
        var tdata: Data
        if encData == nil {
            print("encrypt error!!!")
            return nil
        } else {
            tdata = encData! as Data
        }

        let b64result = tdata.base64EncodedString()
        return b64result
    }

    public class func decrypt(input: String) -> String? {
        let privKey: SecKey = getPrivKey()
        print(privKey)
        guard let encData = Data(base64Encoded: input) else {
            print("decrypt error!!!")
            return nil
        }
        var error: Unmanaged<CFError>?
        let decData = SecKeyCreateDecryptedData(privKey, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, encData as CFData, &error)
        var tdata: Data

        if decData == nil {
            print("decrypt error!!!")
            return nil
        } else {
            tdata = decData! as Data
        }

        let decResult = String(data: tdata, encoding: .utf8)!
        return decResult
    }
}
