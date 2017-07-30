//
//  Project.swift
//  TeamSample
//
//  Created by Fabio Dantas on 28/07/2017.
//  Copyright © 2017 DantasSoftware. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Project {
    var image = UIImage()
    var title = ""
    var date = ""
    var company = ""
    var id = ""
    var people = [People]()
    var activities = [Activity]()
    
    let sessionManager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 10 // seconds
    configuration.timeoutIntervalForResource = 10
    return SessionManager(configuration: configuration)
    }()
    
    func getActivities(view: UIView, controller: UIViewController, completed: @escaping DownloadComplete) {
         view.squareLoading.start(0.0)
        let headers = getCredencials()
        sessionManager.request("\(BASE_URL)projects/\(self.id)/latestActivity.json", method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            let result = response.result
            switch result {
            case .success:
                if let dic = result.value as? Dictionary<String, AnyObject> {
                    if let activityArray = dic["activity"] as? Array<Dictionary<String, AnyObject>> {
                        print(activityArray)
                        for activity in activityArray {
                            let newActivity = Activity()
                            if let description = activity["description"] as? String, let user = activity["fromusername"] as? String, let date = activity["datetime"] as? String {
                               newActivity.description = description
                                newActivity.forusername = user
                                
                                
                            }
                            if let imageUrl = activity["from-user-avatar-url"] as? String {
                                self.sessionManager.request(imageUrl).responseData(completionHandler: { (data) in
                                    if let image = data.value {
                                        let finalImage = UIImage(data: image)
                                        if let readyImage = finalImage {
                                            newActivity.userImage = readyImage
                                        }
                                        
                                    }
                                    completed()
                                    view.squareLoading.stop(0.0)
                                  
                                    
                                })
                                self.activities.append(newActivity)

                            }
                            
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
    
    func getPeople(view: UIView, controller: UIViewController, completed: @escaping DownloadComplete) {
         view.squareLoading.start(0.0)
         let headers = getCredencials()
        sessionManager.request("\(BASE_URL)projects/\(self.id)/people.json", method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            let result = response.result
            switch result {
            case .success:
                if let dic = result.value as? Dictionary<String, AnyObject> {
                    if let peopleArray = dic["people"] as? Array<Dictionary<String, AnyObject>> {
                        for people in peopleArray {
                            print("fabio")
                            let newPeople = People()
                            if let firstName = people["first-name"] as? String, let lastName = people["last-name"] as? String {
                                newPeople.name = firstName + " " + lastName
                            }
                            if let imageUrl = people["avatar-url"] as? String {
                                self.sessionManager.request(imageUrl).responseData(completionHandler: { (data) in
                                    if let image = data.value {
                                        let finalImage = UIImage(data: image)
                                        if let readyImage = finalImage {
                                            newPeople.image = readyImage
                                        }
                                        
                                    }
                                    completed()
                                    view.squareLoading.stop(0.0)
                                    
                                })
                                self.people.append(newPeople)
                            }
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
