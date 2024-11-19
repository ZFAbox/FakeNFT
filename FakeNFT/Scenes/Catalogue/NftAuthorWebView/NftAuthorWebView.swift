//
//  NftAuthorWebView.swift
//  FakeNFT
//
//  Created by Fedor on 18.11.2024.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol { get set }
    func setProgressValue(_ newValue: Float)
    func setProgressIsHidden(_ isHidden: Bool)
    func load(request: URLRequest)
}

final class NftAuthorWebView: UIViewController, WKNavigationDelegate, SettingViewsProtocol {
    
    private lazy var authorWebView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    } ()
    
    var presenter: WebViewPresenterProtocol
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var progreesView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .nftWhite
        progressView.progressTintColor = .nftBlack
        return progressView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .nftCollectionBackwardChevron)
        button.setImage(image, for: .normal)
        button.tintColor = .nftBlack
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(presenter: WebViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad () {
        super.viewDidLoad()
        view.backgroundColor = .nftWhite
        setupView()
        addConstraints()
        estimatedProgressObservation = authorWebView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter.didUpdateProgresValue(self.authorWebView.estimatedProgress)
             })
        presenter.viewDidLoad()
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func setupView() {
        [backButton, authorWebView, progreesView].forEach{view.addSubview($0)}
    }
    
    func addConstraints() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(55)
            make.leading.equalTo(view.snp.leading).offset(9)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        authorWebView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(88)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        progreesView.snp.makeConstraints { make in
            make.top.equalTo(authorWebView.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(2)
        }
    }
}

extension NftAuthorWebView: WebViewViewControllerProtocol {
    func setProgressValue(_ newValue: Float) {
        progreesView.progress = newValue
    }
    
    func setProgressIsHidden(_ isHidden: Bool) {
        progreesView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        authorWebView.load(request)
    }
    
    
}

