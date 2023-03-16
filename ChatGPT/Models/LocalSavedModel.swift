//
//  LocalSavedModel.swift
//  ChatGPT
//
//  Created by nirvana on 3/14/23.
//

import Foundation
import UIKit

struct LocalSavedModel {
    var apiKey: String = ""
    var questionColor: UIColor = .white
    var answerColor: UIColor = UIColor(hexString: "#1E90FF")
    var proFile: UIImage = UIImage(named: "profile") ?? UIImage()
    var backgroundFile: UIImage = UIImage(named: "background2") ?? UIImage()
    var robotFile: UIImage = UIImage(named: "robot") ?? UIImage()
}

struct APIKey: Codable {
    let apiKey: String
}
