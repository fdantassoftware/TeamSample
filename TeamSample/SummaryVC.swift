//
//  SummaryVC.swift
//  TeamSample
//
//  Created by Fabio Dantas on 30/07/2017.
//  Copyright © 2017 DantasSoftware. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let sectionTitles: [String] = ["People", "Acitivities"]
    let s1Data: [String] = ["Row 1", "Row 2", "Row 3"]
    let s2Data: [String] = ["Row 1", "Row 2", "Row 3"]
    let s3Data: [String] = ["Row 1", "Row 2", "Row 3", "Row 4"]
    let sectionImages: [UIImage] = [#imageLiteral(resourceName: "people"), #imageLiteral(resourceName: "activity")]
    var project: Project!
    
    var sectionData: [Int: [AnyObject]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        project.activities.removeAll()
        project.people.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        project.getPeople(view: self.view, controller: self) {
            self.tableView.reloadData()
        }
        project.getActivities(view: self.view, controller: self) {
            self.tableView.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            if section == 0 {
                return project.people.count
            } else if section == 1 {
                return project.activities.count
            } else {
                return 0
            }
           
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
//        view.backgroundColor = UIColor(red: 59/255, green: 147/255, blue: 247/255, alpha: 0.15)
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 59/255, green: 147/255, blue: 247/255, alpha: 1).cgColor
        
        let image = UIImageView(image: sectionImages[section])
        image.frame = CGRect(x: 5, y: 5, width: 70, height: 70)
        view.addSubview(image)
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 18)
        label.textColor = UIColor(red: 59/255, green: 147/255, blue: 247/255, alpha: 1)
        label.text = sectionTitles[section]
        label.frame = CGRect(x: 80, y: 5, width: 100, height: 70)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as? PeopleCell {
                let people =  project.people[indexPath.row]
                cell.nameLabel.text = people.name
                cell.userImage.image = people.image
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AcitivityCell", for: indexPath) as? AcitivityCell {
                let activity =  project.activities[indexPath.row]
                cell.descriptionLabel.text = activity.description
                cell.userLabel.text = activity.forusername
                cell.userImage.image = activity.userImage
                return cell
            }
        }
        
        return UITableViewCell()
       
    }

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
