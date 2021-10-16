//
//  MyAuthenticator.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Alamofire

class MyAuthenticator: Authenticator {
    typealias Credential = MyAuthenticationCredential

    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "refresh-token")
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        // bearerToken의 urlRequest대해서만 refresh를 시도 (true)
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }

    func refresh(_ credential: Credential, for session: Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        // TODO: refresh API 콜
        /*
         switch result {
         case .success(let response):
            completion(.success(credential))
         case .failure(let error):
            completion(.failure(error))
         }
         */
    }
}
