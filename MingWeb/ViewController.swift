//
//  ViewController.swift
//  MingWeb
//
//  Created by yar on 28.04.2020.
//  Copyright © 2020 yar. All rights reserved.
//

import UIKit
import WebKit

private struct Constants {
    static let deviceWidthParameterName = "device_width"
    static let deviceHeightParameterName = "device_height"
    static let baseURL = "https://www.mingming.io"
}

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = URL(string: Constants.baseURL) {
            guard let modifyURL = SupportManager.addWebViewFrameToURL(url: url, frame: webView.frame) else { return }
            let urlRequest = URLRequest(url: modifyURL)
            webView.load(urlRequest)
            print(modifyURL)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            guard let modifyURL = SupportManager.addWebViewFrameToURL(url: url, frame: webView.frame) else {
                decisionHandler(.cancel)
                return
            }
            print(modifyURL)
            decisionHandler(.cancel)
            let urlRequest = URLRequest(url: modifyURL)
            webView.load(urlRequest)
        } else {
            
            print("not a user click - \(navigationAction.request.url)")
            decisionHandler(.allow)
        }
    }
}

class SupportManager {
    class func addWebViewFrameToURL(url: URL, frame: CGRect) -> URL? {
        if url.absoluteString.contains(Constants.deviceWidthParameterName) &&
            url.absoluteString.contains(Constants.deviceHeightParameterName) {
            return url
        } else {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
            let queryItemWidth = URLQueryItem(name: Constants.deviceWidthParameterName, value: String(Int(frame.width)))
            let queryItemHeight = URLQueryItem(name: Constants.deviceHeightParameterName, value: String(Int(frame.height)))
            if urlComponents.queryItems != nil {
                urlComponents.queryItems! += [queryItemWidth, queryItemHeight]
            } else {
                urlComponents.queryItems = [queryItemWidth, queryItemHeight]
            }
            guard let tmpURL = urlComponents.url else { return nil }
            return tmpURL
        }
    }
}


