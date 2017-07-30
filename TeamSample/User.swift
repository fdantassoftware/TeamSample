//
//  Company.swift
//  TeamSample
//
//  Created by Fabio Dantas on 28/07/2017.
//  Copyright © 2017 DantasSoftware. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class User {
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        return SessionManager(configuration: configuration)
    }()
    private var _projects = [Project]()
    private var _image = UIImage()
    
    var projects: [Project] {
        return _projects
    }
    
    var image: UIImage {
        return self._image
    }
    
    func getUserProfile(completed: @escaping DownloadComplete) {
        // Get user Picture
        let headers = getCredencials()
        sessionManager.request("\(BASE_URL)account.json", method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            let result = response.result
            switch result {
            case .success:
                if let dic = result.value as? Dictionary<String, AnyObject> {
                    if let account = dic["account"] as? Dictionary<String, AnyObject> {
                        if let imageUrl = account["logo"] as? String {
                            self.sessionManager.request(imageUrl).responseData(completionHandler: { (data) in
                                if let image = data.value {
                                    let finalImage = UIImage(data: image)
                                    if let readyImage = finalImage {
                                        self._image = readyImage
                                    }
                                    
                                }
                                completed()
                                
                                
                            })
                        }
                    }
                    
                }
            case .failure(let error):
                print(error._code)
            }
            completed()
        }
    }
    
    
    func getAllProjects(view: UIView, controller: UIViewController, completed: @escaping DownloadComplete) {
        // Get all projects
        view.squareLoading.start(0.0)
        let headers = getCredencials()
        sessionManager.request("\(BASE_URL)projects.json", method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            let result = response.result
            switch result {
            case .success:
                if let dic = result.value as? Dictionary<String, AnyObject> {
                    if let projects = dic["projects"] as? Array<Dictionary<String,AnyObject>> {
                        for project in projects {
                            let newProject = Project()
                            if let projectName = project["name"] as? String {
                                newProject.title = projectName
                                
                            }
                            if let projectID = project["id"] as? String {
                                newProject.id = projectID
                            }
                            if let company = project["company"] as? Dictionary<String, AnyObject> {
                                if let name = company["name"] as? String {
                                    newProject.company = name.capitalized
                                }
                            }
                            if let created = project["created-on"] as? String {
                                let dateformatter = DateFormatter()
                                dateformatter.locale = Locale(identifier: "en_US_POSIX")
                                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                let string = dateformatter.date(from: created)
                                let dateformatterFinal = DateFormatter()
                                dateformatterFinal.dateFormat = "MMM dd, yyyy"
                                if string != nil {
                                    let finalDate = dateformatterFinal.string(from: string!)
                                    if finalDate != "" {
                                        newProject.date = finalDate
                                    }
                                }
                                
                            }
                            if let imageUrl = project["logo"] as? String {
                                self.sessionManager.request(imageUrl).responseData(completionHandler: { (data) in
                                    if let image = data.value {
                                        let finalImage = UIImage(data: image)
                                        if let readyImage = finalImage {
                                            newProject.image = readyImage
                                        }
                                        
                                    }
                                    completed()
                                    view.squareLoading.stop(0.0)
                                    
                                })
                                
                            }
                            self._projects.append(newProject)
                            
                        }
                        
                        
                    }
                }
                
                
            case .failure(let error):
                view.squareLoading.stop(0.0)
                print(error._code)
                if error._code == NSURLErrorTimedOut {
                    self.timeOutAlert(controller: controller)
                } else if error._code == NSURLErrorNotConnectedToInternet {
                    self.noInternetAlert(controller: controller)
                }
            }
            
            
            completed()
        }
        
    }
    
    func timeOutAlert(controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "The request timed out, please try again later", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    func noInternetAlert(controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "No internet connection, please try again later", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
}
