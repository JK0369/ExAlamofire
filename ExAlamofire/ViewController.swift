//
//  ViewController.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = LoginRequest(userName: "name", password: "1234")
        LoginAPI.login(request: request) { succeed, failed in
            if let succeed = succeed {
                print(succeed)
            }
        }
    }

}
