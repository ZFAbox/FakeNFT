
import Foundation

// MARK: - Protocol

protocol NftProfileManagerProtocol {
    var delegate: NftItemLikeUnlockProtocol? { get set }
    func sendProfile()
}

enum NftProfileManagerState {
    case initial, loading, failed(Error), nftProfileData(NftProfilePutResponse)
}

final class NftProfileManager: NftProfileManagerProtocol {
    
    // MARK: - Properties
    weak var delegate: NftItemLikeUnlockProtocol?
    weak var view: NftManagerUpdateProtocol?
    private var profileStorage = NftProfileStorage.shared
    private let nftProfilePutService: NftProfilePutService
    private var state = NftProfileManagerState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init

    init(servicesAssembly: CatalogueServicesAssembly, view: NftManagerUpdateProtocol) {
        self.nftProfilePutService = servicesAssembly.nftProfilePutService
        self.view = view
    }

    // MARK: - Functions

    func sendProfile() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            sendProfile(profile: profileStorage.profile)
        case .nftProfileData(let nftProfile):
            delegate?.likeUnlock()
            profileStorage.profile = NftProfile(name: nftProfile.name, description: nftProfile.description, website: nftProfile.website, likes: nftProfile.likes)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            delegate?.likesPreviousStateUpdate()
            view?.showError(errorModel)
        }
    }

    private func sendProfile(profile: NftProfile) {
        nftProfilePutService.sendProfilePutRequest(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            likes: profile.likes
        ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nftOrder):
                    self.state = .nftProfileData(nftOrder)
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
