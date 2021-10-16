//
//  PredictAgeAPI.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Alamofire

struct PredictAgeAPI {

    /// 이름과 패스워드로 로그인
    static func predict(request: PredictAgeRequest, completion: @escaping (_ succeed: Person?, _ failed: Error?) -> Void) {
        AF.request(PredictAgeTarget.predict(request), interceptor: MyRequestInterceptor())
            .responseDecodable { (response: AFDataResponse<PredictAgeResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    /// 이름과 패스워드로 로그인 + AuthencitationInterceptor 사용
    static func predictWithAuth(request: PredictAgeRequest, completion: @escaping (_ succeed: Person?, _ failed: Error?) -> Void) {

        // AuthenticationInterceptor 적용
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: KeychainServiceImpl.shared.accessToken ?? "",
                                                    refreshToken: KeychainServiceImpl.shared.refreshToken ?? "",
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 120))
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        AF.request(PredictAgeTarget.predict(request), interceptor: myAuthencitationInterceptor)
            .responseDecodable { (response: AFDataResponse<PredictAgeResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
