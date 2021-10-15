//
//  PredictAgeResponse.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/16.
//

import Foundation

struct PredictAgeResponse: Decodable {
    let name: String
    let age: Int
    let count: Int
}

extension PredictAgeResponse {
    var toDomain: Person {
        return Person(name: name, age: age)
    }
}
