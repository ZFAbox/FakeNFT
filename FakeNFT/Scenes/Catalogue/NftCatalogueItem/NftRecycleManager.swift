
import Foundation

// MARK: - Protocol

protocol NftRecycleManagerProtocol {
    var delegate: NftItemRecycleUnlockProtocol? { get set }
    func sendOrder()
}

enum NftRecycleManagerState {
    case initial, loading, failed(Error), nftOrderData(OrderPutResponse)
}

final class NftRecycleManager: NftRecycleManagerProtocol {
    
    // MARK: - Properties
    
    weak var delegate: NftItemRecycleUnlockProtocol?
    weak var view: NftManagerUpdateProtocol?
    private var recycleStorage = NftRecycleStorage.shared
    private let nftOrderPutService: NftOrderPutService
    private var state = NftRecycleManagerState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init

    init(servicesAssembly: CatalogueServicesAssembly, view: NftManagerUpdateProtocol) {
        self.nftOrderPutService = servicesAssembly.nftOrderPutService
        self.view = view
    }

    // MARK: - Functions

    func sendOrder() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            sendNftOrder(nfts: recycleStorage.order)
        case .nftOrderData(let nftOrder):
            delegate?.recycleUnlock()
            recycleStorage.order = nftOrder.nfts
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            delegate?.recyclePreviousStateUpdate()
            view?.showError(errorModel)
        }
    }

    private func sendNftOrder(nfts: [String]) {
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
