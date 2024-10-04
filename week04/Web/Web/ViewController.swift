//
//  ViewController.swift
//  Web
//
//  Created by CSMAC11 on 9/27/24.
//

import UIKit
import WebKit

class ViewController: UIViewController , WKNavigationDelegate{
    @IBOutlet var txtUrl: UITextField!
    @IBOutlet var myWebView: WKWebView!
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myWebView.navigationDelegate = self
        
        loadWebPage("https://www.dongduk.ac.kr/kor/main.do")
    }
    
    func loadWebPage(_ url: String){
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        myWebView.load(myRequest)
    }
    
    func webWiew(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        myActivityIndicator.startAnimating()
        myActivityIndicator.isHidden = false
    }
    func webWiew(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    func webWiew(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }

    @IBAction func btnGotoUrl(_ sender: UIButton) {
    }
    
    @IBAction func btnGoSite1(_ sender: UIButton) {
    }
    @IBAction func btnGoSite2(_ sender: UIButton) {
    }
    @IBAction func btnLoadHtmlString(_ sender: UIButton) {
    }
    @IBAction func btnLoadHtmlFile(_ sender: UIButton) {
    }
    @IBAction func btnStop(_ sender: UIBarButtonItem) {
    }
    @IBAction func btnReload(_ sender: UIBarButtonItem) {
    }
    @IBAction func btnGoBack(_ sender: UIBarButtonItem) {
    }
    @IBAction func btnGoForward(_ sender: UIBarButtonItem) {
    }
}

