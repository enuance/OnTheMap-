//
//  TableViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/12/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var studentTable: UITableView!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var redSpinner: UIActivityIndicatorView!
    
    //This property prevents the tableView from attempting to access the model while it is being cleared
    //and reset, which results in an index out of range (fatal error).
    var isReloadingOrLogout: Bool! {
        willSet{
            guard let newValue = newValue else{return}
            switch newValue{
            case true:
                if studentTable.isDecelerating{
                    let paths = studentTable.indexPathsForVisibleRows
                    studentTable.scrollToRow(at: paths![0], at: .top, animated: false)
                    studentTable.isScrollEnabled = false
                }
            case false: studentTable.isScrollEnabled = true
            }
        }
    }
    
    var distanceRatio: CGFloat = 0
    
    override func viewDidLoad() {super.viewDidLoad()
        blurEffect.alpha = 0; blurEffect.effect = nil
        studentTable.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {super.viewDidAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMap.shared.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentCell = Bundle.main.loadNibNamed("StudentCell", owner: self, options: nil)?.first as! StudentCell
        let name = "\(OnTheMap.shared.locations[indexPath.row].firstName!) \(OnTheMap.shared.locations[indexPath.row].lastName!)"
        studentCell.name.text = name
        studentCell.media.text = OnTheMap.shared.locations[indexPath.row].mediaURL
        return studentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStudentCell = tableView.cellForRow(at: indexPath) as! StudentCell
        selectedStudentCell.animateSelection(){
            let mediaURL = selectedStudentCell.media.text
            let app = UIApplication.shared
            if let mediaURL = mediaURL {
                if let verifiedURL = URL(string: mediaURL.prefixHTTP){
                    app.open(verifiedURL, options: [:], completionHandler: nil)
                }else{
                        SendError.toDisplay(self,
                                            errorType: GeneralError.invalidURL.rawValue,
                                            errorMessage: GeneralError.invalidURL.description,
                                            assignment: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let studentCellHeight: CGFloat = 100; return studentCellHeight
    }
    
}
