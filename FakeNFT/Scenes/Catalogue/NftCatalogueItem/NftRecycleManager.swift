
import Foundation

// MARK: - Protocol

protocol NftRecycleManagerProtocol {
    func sendNftOrder(nfts: [String])
}

enum NftRecycleManagerState {
    case initial, loading, failed(Error), nftOrderData(OrderPutResponse)
}

final class NftRecycleManager: NftRecycleManagerProtocol {
    
    // MARK: - Properties

    weak var view: NftRecycleManagerUpdateProtocol?
    private var nfts: [String] = []
    private let nftOrderPutService: NftOrderPutService
    private var state = NftRecycleManagerState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init

    init(servicesAssembly: CatalogueServicesAssembly) {
        self.nftOrderPutService = servicesAssembly.nftOrderPutService
    }

    // MARK: - Functions

    func viewDidLoad() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            sendNftOrder(nfts: nfts)
        case .nftOrderData(let nftOrder):
            print(nftOrder)
//            view?.hideLoading()
            view?.updateNftOrder(nftOrder)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    func sendNftOrder(nfts: [String]) {
        nftOrderPutService.sendOrderPutRequest(nfts: nfts) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nftOrder):
                    self.state = .nftOrderData(nftOrder)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
