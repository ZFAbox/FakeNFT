import Foundation

protocol NftCardPresenterProtocol: AnyObject {
    func viewDidLoad()
}


final class NftCardPresenter: NftCardPresenterProtocol {
    
    private let serviceAssembly: ServicesAssembly
    weak var view: NftCardViewControllerProtocol?
    
    init(serviceAssembly: ServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func viewDidLoad() {
        
    }
    
}
