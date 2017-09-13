//
//  PDFWebViewController.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/28/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
import WebKit

class PDFWebViewController: UIViewController, WKUIDelegate {
    
    var color : UIColor!
    var webView: WKWebView!
    var titulo : String!
    
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.backBarButtonItem?.title = ""
        colorear()
        cargarDoc()
        if let t = titulo {
            self.title = t
        }
    }

    func cargarDoc() {
        if let pdfURL = Bundle.main.url(forResource: "resume", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            do {
                let data = try Data(contentsOf: pdfURL)
               
                webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
            }catch {
                
            }
       //
 titulo = webView.title
        }
    }	

    func colorear() {
        if let c = color {
            UIApplication.shared.statusBarView?.backgroundColor = c
            self.navigationController?.navigationBar.tintColor = c
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : c]
            webView.tintColor = color
        }
    }



}

