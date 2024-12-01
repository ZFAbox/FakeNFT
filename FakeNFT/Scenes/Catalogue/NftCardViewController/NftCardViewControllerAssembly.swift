import UIKit

final class NftCardViewControllerAssembly {

    private var nftCollection: [Nft]
    private let serviceAssembly: ServicesAssembly
    private var viewController: UIViewController

    init(nftCollection: [Nft], serviceAssembly: ServicesAssembly, presentOn viewController: UIViewController) {
        self.nftCollection = nftCollection
        self.serviceAssembly = serviceAssembly
        self.viewController = viewController
    }

    func present(with nft: Nft){
        let presenter = NftCardPresenter(serviceAssembly: serviceAssembly)
        let nftCardviewController = NftCardViewController(nft: nft, nftCollection: nftCollection, presenter: presenter)
        presenter.view = nftCardviewController
        nftCardviewController.modalPresentationStyle = .fullScreen
        viewController.present(nftCardviewController, animated: true)
    }
}
