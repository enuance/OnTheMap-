//
//  WebViewController.swift
//  ONTheMap!
//
//  Created by Stephen Martinez on 4/7/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit
/*
 The sole pupose of This WebViewController is for Signing up for a new account
 */

class WebViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var OTMWebView: UIWebView!
    let redSpinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var urlString: String!
    
    override func viewDidLoad() {super.viewDidLoad()
        setUpNavBar()
        OTMWebView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        guard let urlString = urlString, let validURL = URL(string: urlString) else {return}
        OTMWebView.loadRequest(URLRequest(url: validURL))
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        redSpinner.stopAnimating()
        SendToDisplay.error(self, errorType: "WebPage Failed to Load", errorMessage: error.localizedDescription, assignment: ({self.navigateBack()}))
    }
    
    func navigateBack(){navigationController?.popViewController(animated: true)}
    
    func webViewDidStartLoad(_ webView: UIWebView) {redSpinner.startAnimating()}
    
    func webViewDidFinishLoad(_ webView: UIWebView) {redSpinner.stopAnimating()}
    
    @IBAction func goBack(_ sender: UIButton) {
        guard OTMWebView.canGoBack else{return}
        OTMWebView.goBack()
    }
    
    @IBAction func goForward(_ sender: UIButton) {
        guard OTMWebView.canGoForward else{return}
        OTMWebView.goForward()
    }
    
}








