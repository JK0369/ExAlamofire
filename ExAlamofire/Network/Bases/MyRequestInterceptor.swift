//
//  MyRequestInterceptor.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Alamofire

final class MyRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("https://api.agify.io") == true,
              let accessToken = KeychainServiceImpl.shared.accessToken else {
                  completion(.success(urlRequest))
                  return
              }

        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        /* TODO:
        RefreshTokenAPI.refreshToken { result in
            switch result {
            case .success(let accessToken):
                KeychainServiceImpl.shared.accessToken = accessToken
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
        */
    }
}
