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
    @IBOutlet weak var redSpinner: UIActivityIndicatorView!
    
    var urlString: String!
    var navBarTitle: String!
    
    override func viewDidLoad() {super.viewDidLoad()
        setUpNavBar()
        OTMWebView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
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
    
    func navigateBack(){navigationController?.popViewController(animated: true)}
    
    func webViewDidStartLoad(_ webView: UIWebView) {redSpinner.startAnimating()}
    
    func webViewDidFinishLoad(_ webView: UIWebView) {redSpinner.stopAnimating()}
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        redSpinner.stopAnimating()
        SendToDisplay.error(self, errorType: "WebPage Failed to Load", errorMessage: error.localizedDescription, assignment: ({self.navigateBack()}))
    }
}








