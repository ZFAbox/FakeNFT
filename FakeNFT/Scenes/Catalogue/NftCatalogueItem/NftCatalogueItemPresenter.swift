
import Foundation

// MARK: - Protocol

protocol NftCatalogueItemPresenterProtocol {
    func viewDidLoad()
}

enum NftCatalogueItemState {
    case initial, loading, failed(Error), nftCollectionData, nftOrderData(Order), nftLikesData(NftProfile)
}

final class NftCatalogueItemPresenter: NftCatalogueItemPresenterProtocol {
    
    // MARK: - Properties

    weak var view: NftCatalogueItemViewControllerProtocol?
    private var input: [String]
    private var output: [Nft] = []
    private let nftItemsService: NftServiceProtocol
    private let nftOrderService: NftOrderServiceProtocol
    private let nftLikesService: NftLikesServiceProtocol
    private var recycleStorage = NftRecycleStorage.shared
    private var profileStorage = NftProfileStorage.shared
    private var state = NftCatalogueItemState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init

    init(input: [String], servicesAssembly: ServicesAssembly) {
        self.input = input
        self.nftItemsService = servicesAssembly.nftItemsService
        self.nftOrderService = servicesAssembly.nftOrderService
        self.nftLikesService = servicesAssembly.nftLikesService
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
            let id = input.removeFirst()
            loadNftCollectionItems(id: id)
        case .nftCollectionData:
            if 0 < input.count {
                state = .loading
            } else {
                loadNftOrder()
            }
        case .nftOrderData(let nftOrder):
            recycleStorage.order = nftOrder.nfts
            loadNftLikes()
        case .nftLikesData(let nftProfile):
            profileStorage.profile = nftProfile
            view?.hideLoading()
            view?.displayItems(output)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    private func loadNftCollectionItems(id: String) {
            nftItemsService.loadNft(id: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nftItems):
                    self.output.append(nftItems)
                    self.state = .nftCollectionData
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
    }
    
    private func loadNftOrder() {
        nftOrderService.loadOrder() { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nftOrder):
                    self.state = .nftOrderData(nftOrder)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
    }
    
    private func loadNftLikes(){
        nftLikesService.loadNftLikes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nftProfile):
                self.state = .nftLikesData(nftProfile)
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
