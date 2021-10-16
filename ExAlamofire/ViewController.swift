//
//  ViewController.swift
//  ExAlamofire
//
//  Created by 김종권 on 2021/10/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didTapCallAPIButton(_ sender: Any) {
        let request = PredictAgeRequest(name: textField.text ?? "")
        PredictAgeAPI.predictWithEventLogger(request: request) { [weak self] succeed, failed in
            guard let succeed = succeed else { return }
            self?.label.text = "\(succeed.name)이름, 예측 = \(succeed.age)살"
        }
    }
}
