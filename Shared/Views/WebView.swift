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

#if os(iOS)
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
#endif

#if os(macOS)
struct WebViewUI: NSViewRepresentable {
    let webView: WKWebView
    let request: URLRequest
    
    init(_ url: String, webView: WKWebView) {
        self.request = URLRequest(url: URL(string: url)!)
        self.webView = webView
    }

    func makeNSView(context: NSViewRepresentableContext<WebViewUI>) -> WKWebView  {
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: NSViewRepresentableContext<WebViewUI>) {
        webView.load(request)
    }
}
#endif

struct WebView: View {
    let url: String
    @StateObject var webViewStore = WebViewStore()
    init(url: String) {
        self.url = url
    }
    
    var main: some View {
        WebViewUI(url, webView: webViewStore.webView)
            .navigationTitle(webViewStore.title ?? "")
    }
    var body: some View {
        ZStack(alignment: .top) {
            #if os(iOS)
                main
                    .navigationBarTitleDisplayMode(.inline)
            #else
                main
            #endif
            if webViewStore.estimatedProgress < 1.0 {
                ProgressView(value: webViewStore.estimatedProgress)
            }
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url:"https://www.apple.com")
    }
}
