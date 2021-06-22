//
//  WebView.swift
//  GankIO
//
//  Created by Kiyan Gauss on 6/18/21.
//

import SwiftUI
import WebKit

@dynamicMemberLookup
public class WebViewStore: ObservableObject {
  @Published public var webView: WKWebView {
    didSet {
      setupObservers()
    }
  }
  
  public init(webView: WKWebView = WKWebView()) {
    self.webView = webView
    setupObservers()
  }
  
  private func setupObservers() {
    func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
      return webView.observe(keyPath, options: [.prior]) { _, change in
        if change.isPrior {
          self.objectWillChange.send()
        }
      }
    }
    // Setup observers for all KVO compliant properties
    observers = [
      subscriber(for: \.title),
      subscriber(for: \.url),
      subscriber(for: \.isLoading),
      subscriber(for: \.estimatedProgress),
      subscriber(for: \.hasOnlySecureContent),
      subscriber(for: \.serverTrust),
      subscriber(for: \.canGoBack),
      subscriber(for: \.canGoForward)
    ]
  }
  
  private var observers: [NSKeyValueObservation] = []
  
  public subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
    webView[keyPath: keyPath]
  }
}

struct WebViewUI: UIViewRepresentable {
    let webView: WKWebView
    let request: URLRequest
    
    init(_ url: String, webView: WKWebView) {
        self.request = URLRequest(url: URL(string: url)!)
        self.webView = webView
    }

    func makeUIView(context: Context) -> WKWebView  {
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(request)
    }
}

struct WebView: View {
    let url: String
    @StateObject var webViewStore = WebViewStore()
    init(url: String) {
        self.url = url
    }
    var body: some View {
        print(webViewStore.estimatedProgress)
        return ZStack(alignment: .top) {
            WebViewUI(url, webView: webViewStore.webView)
                .navigationTitle(webViewStore.title ?? "")
                .navigationBarTitleDisplayMode(.inline)
            ProgressView(value: webViewStore.estimatedProgress)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url:"https://www.apple.com")
    }
}
