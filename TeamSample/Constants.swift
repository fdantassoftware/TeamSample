//
//  Constants.swift
//  TeamSample
//
//  Created by Fabio Dantas on 28/07/2017.
//  Copyright © 2017 DantasSoftware. All rights reserved.
//

import Foundation
var BASE_URL = "https://yat.teamwork.com/"
typealias DownloadComplete = () -> ()

func getCredencials() -> Dictionary<String, String> {
    // Get api Credencials

    let username = "twp_TEbBXGCnvl2HfvXWfkLUlzx92e3T"
    let password = "X"
    let userPasswordData = "\(username):\(password)".data(using: .utf8)
    let base64EncodedCredentials = userPasswordData!.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
    let headers = ["Authorization": "Basic \(base64EncodedCredentials)"]
    return headers
}
