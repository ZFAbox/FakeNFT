

import Foundation



public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgresValue(_ newValue: Double)
}


final class NftAuthorWebViewPresenter: WebViewPresenterProtocol {
    
    private var urlString: String
    
    weak var view: WebViewViewControllerProtocol?
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func viewDidLoad() {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        didUpdateProgresValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgresValue(_ newValue: Double) {
        let newProgreeValue = Float(newValue)
        
        view?.setProgressValue(newProgreeValue)
        let shouldHideProgress = shouldHideProgress(for: newProgreeValue)
        view?.setProgressIsHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
}

