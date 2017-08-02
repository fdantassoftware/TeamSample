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
<<<<<<< HEAD
    let username = "twp_TEbBXGCnvl2HfvXWfkLUlzx92e3T"
=======
    let username = "april294unreal"
>>>>>>> 2aa1ad004312b235c791abac594e75f443e5d073
    let password = "X"
    let userPasswordData = "\(username):\(password)".data(using: .utf8)
    let base64EncodedCredentials = userPasswordData!.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
    let headers = ["Authorization": "Basic \(base64EncodedCredentials)"]
    return headers
}
