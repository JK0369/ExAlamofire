//
//  LoginAPI.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Alamofire

struct LoginAPI {

    /// 이름과 패스워드로 로그인
    static func login(request: LoginRequest, completion: @escaping (_ succeed: Login?, _ failed: Error?) -> Void) {
        AF.request(LoginTarget.login(request))
            .responseDecodable { (response: AFDataResponse<LoginResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    /// 유저 정보 조회
    static func getUserDetails(request: UserDetailsRequest, completion: @escaping (_ succeed: Login?, _ failed: Error?) -> Void) {
        AF.request(LoginTarget.getUserDetails(request))
            .responseDecodable { (response: AFDataResponse<UserDetailsResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
