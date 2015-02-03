//
//  ViewController.swift
//  WebKitDemo
//
//  Created by mac on 15/2/3.
//  Copyright (c) 2015年 LingAn. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,UITextFieldDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var urlField: UITextField!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var forwardBtn: UIBarButtonItem!
    @IBOutlet weak var reloadBtn: UIBarButtonItem!
    
    
    //声明webView变量
    var webView: WKWebView
    
    //初始化webView
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //设置barView的大小
        barView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        view.addSubview(webView)
        //禁止自动约束
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //手动添加约束
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height,width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        
        //启动程序时，默认打开http://www.appcoda.com
        let url = NSURL(string: "http://www.appcoda.com")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        backBtn.enabled = false
        forwardBtn.enabled = false
    }

    //设备方向改变时，重新设置barView的大小
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        barView.frame = CGRect(x: 0, y: 0, width: size.width, height: 30)
    }
    
    //隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlField.text)!))
        return false
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            backBtn.enabled = webView.canGoBack
            forwardBtn.enabled = webView.canGoForward
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        let request = NSURLRequest(URL: webView.URL!)
        webView.loadRequest(request)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

