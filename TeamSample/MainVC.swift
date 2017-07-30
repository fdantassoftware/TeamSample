//
//  MainVC.swift
//  TeamSample
//
//  Created by Fabio Dantas on 26/07/2017.
//  Copyright © 2017 DantasSoftware. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var coverBtn: UIButton!
    @IBOutlet weak var menuCurveImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var eventBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var dashBtn: UIButton!
    @IBOutlet weak var projectsBtn: UIButton!
    @IBOutlet weak var tasksBtn: UIButton!
    @IBOutlet weak var activitiesBtn: UIButton!
    let user = User()
    var isSearching = false
    var filteredProjects = [Project]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //get image and change tint
        let image = #imageLiteral(resourceName: "MenuCurve")
        let templateImage = image.maskWithColor(color: UIColor.white)
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        menuCurveImage.image = templateImage
        
        
        setupForIphone7()
        //set delegates
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Mark: Call Api and update view
        user.getAllProjects(view: self.view, controller: self) {
            self.collectionView.reloadData()
        }
        user.getUserProfile {
            self.userImage.image = self.user.image
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        hideMenu()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as? ProjectCell {
            styleCell(cell: cell)
            let project: Project
            if isSearching {
                project = filteredProjects[indexPath.row]
            } else {
                project = user.projects[indexPath.row]
            }
            
            cell.projectName.text = project.title
            cell.projectImage.image = project.image
            cell.projectCompany.text = project.company
            cell.projectDate.text = project.date
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredProjects.count
        } else {
            return user.projects.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: self.view.frame.width - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let project = user.projects[indexPath.row]
        performSegue(withIdentifier: "showSummary", sender: project)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSummary" {
            if let dest = segue.destination as? SummaryVC {
                if let project = sender as? Project {
                    dest.project = project
                }
            }
        }
    }
    
    
    @IBAction func menuPressed(_ sender: Any) {
        showMenu()
    }
    
    func showMenu() {
        // Animation sequences when showing menu
        self.menuView.isHidden = false
        UIView.animate(withDuration: 0.7) {
            
            self.coverBtn.alpha = 0.5
           
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.06, options: .curveEaseOut, animations: {
            self.menuCurveImage.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            if screen.1 > 568 {
                self.tasksBtn.transform = .identity
            }
            
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.06, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            self.projectsBtn.transform = .identity
            if screen.1 < 667 {
                self.tasksBtn.transform = .identity
            } else{
                self.activitiesBtn.transform = .identity
            }
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.12, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            self.dashBtn.transform = .identity
            if screen.1 < 667 {
                self.activitiesBtn.transform = .identity
            } else{
                self.messageBtn.transform = .identity
            }
            
        })
        
     
        
        UIView.animate(withDuration: 0.4, delay: 0.18, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            self.userImage.transform = .identity
            if screen.1 < 667 {
                self.messageBtn.transform = .identity
            } else{
                self.eventBtn.transform = .identity
            }
            
        })
    }
    
    func hideMenu() {
        
        // Animation sequences when hiding menu
        
        UIView.animate(withDuration: 0.4) {
            self.coverBtn.alpha = 0
            
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            self.userImage.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            if screen.1 < 667 {
                self.messageBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            } else{
                self.eventBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            }
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.08, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            self.dashBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            if screen.1 < 667 {
                self.activitiesBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            } else{
                self.messageBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            }
            
        })
        
        
        
        UIView.animate(withDuration: 0.4, delay: 0.16, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            self.projectsBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            if screen.1 < 667 {
                self.tasksBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            } else{
                self.activitiesBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            }
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.08, options: .curveEaseOut, animations: {
            self.menuCurveImage.transform = CGAffineTransform(translationX: -self.menuCurveImage.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.21, options: [.curveEaseOut, .allowUserInteraction], animations: {
            let screen = self.getScreenSize()
            if screen.1 > 568 {
                 self.tasksBtn.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            }
                
            
        }) { success in
            self.menuView.isHidden = true
        }
        
        
    }
    
    @IBAction func coverBtnPressed(_ sender: Any) {
        // Hide menu when button pressed
        hideMenu()
    }
    
    


    func styleCell(cell: UICollectionViewCell) {
        // Style CollectionView Cell
        cell.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.view.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)! {
            self.view.endEditing(true)
        }
        // Filter array based on texted typed

        filteredProjects = user.projects.filter { project in
            return project.title.lowercased().contains(searchText.lowercased())
                
        }
        if(filteredProjects.count == 0) {
            isSearching = false
        } else {
            isSearching = true
        }
        self.collectionView.reloadData()
    }
    
    func getScreenSize() -> (Float, Float) {
        // Get Device screen
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        return (Float(screenWidth), Float(screenHeight))
    }
    
    func setupForIphone7() {
        // Show more or less items depeding on device screen size
        let screen = getScreenSize()
        if screen.1 < 667 {
            eventBtn.isHidden = true
        } else {
            eventBtn.isHidden = false
      
        }
    }
    

}
extension UIImage {
    // Set UIImage mask/tint to desirable color
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
