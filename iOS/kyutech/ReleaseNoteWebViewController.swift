//
//  ReleaseNoteWebViewController.swift
//  kyutech
//
//  Created by shogo okamuro on 3/28/16.
//  Copyright © 2016 shogo okamuro. All rights reserved.
//

import UIKit

class ReleaseNoteWebViewController: UIViewController {
    
    @IBOutlet weak var naviBar: UINavigationBar!
    var urlString: String = Config.releaseNote
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = Config.getThemeColor()
        self.naviBar.barTintColor = Config.getThemeColor()
        self.webView.scrollView.bounces = false
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let url = NSURL(string : urlString)
        let urlRequest = NSURLRequest(URL: url!)
        self.webView.loadRequest(urlRequest)
    }
    
    
    
    @IBAction func closeTaped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ReleaseNoteWebViewController: UIWebViewDelegate {
    //MARK: - UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }

}
