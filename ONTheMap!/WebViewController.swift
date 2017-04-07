//
//  WebViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/7/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var OTMWebView: UIWebView!
    
    var urlString: String!
    
    
    override func viewDidLoad() {super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        OTMWebView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {super.viewWillAppear(true)
        guard let urlString = urlString, let validURL = URL(string: urlString)
            else {print("urlString property not set or invalid!");return}
        OTMWebView.loadRequest(URLRequest(url: validURL))
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        guard OTMWebView.canGoBack else{return}
        OTMWebView.goBack()
    }
    
    @IBAction func goForward(_ sender: UIButton) {
        guard OTMWebView.canGoForward else{return}
        OTMWebView.goForward()
    }
}
