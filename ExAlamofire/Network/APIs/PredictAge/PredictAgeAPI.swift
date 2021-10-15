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
}
