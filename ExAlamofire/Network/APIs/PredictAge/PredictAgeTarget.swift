//
//  PredictAgeTarget.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation
import Alamofire

enum PredictAgeTarget {
    case predict(PredictAgeRequest)
}

extension PredictAgeTarget: TargetType {

    var baseURL: String {
        return "https://api.agify.io"
    }

    var method: HTTPMethod {
        switch self {
        case .predict: return .get
        }
    }

    var path: String {
        switch self {
        case .predict: return ""
        }
    }

    var parameters: RequestParams {
        switch self {
        case .predict(let request): return .query(request)
        }
    }

}
