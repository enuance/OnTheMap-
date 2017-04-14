//
//  TableViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/12/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {super.viewDidAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMap.shared.locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentCell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath)
        
        let name = "\(OnTheMap.shared.locations[indexPath.row].firstName!) \(OnTheMap.shared.locations[indexPath.row].lastName!)"
        
        studentCell.textLabel?.text = name
        studentCell.detailTextLabel?.text = OnTheMap.shared.locations[indexPath.row].mediaURL
        
        return studentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaURL = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text
        let app = UIApplication.shared
        if let mediaURL = mediaURL {
            app.open(URL(string: mediaURL.prefixHTTP)!, options: [:], completionHandler: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
