//
//  WebView.swift
//  Marvel
//
//  Created by Vasiliy Munenko on 23.03.2021.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    
    var url : URL
    func makeUIView(context: Context) -> WKWebView {
        
        let view = WKWebView()
        view.load(URLRequest(url: url))
        
        return view
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
       Text("webview")
    }
}
