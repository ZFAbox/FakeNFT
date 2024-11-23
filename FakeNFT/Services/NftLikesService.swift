import Foundation

typealias NftLikesCompletion = (Result<NftProfile, Error>) -> Void
typealias NftLikeCompletion = (Result<Bool, Error>) -> Void

protocol NftLikesService {
    func loadNftLikes(completion: @escaping NftLikesCompletion)
}

final class NftLikesServiceImpl: NftLikesService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftLikes(completion: @escaping NftLikesCompletion) {
        
        let request = NftProfileRequest()
        networkClient.send(request: request, type: NftProfile.self) {result in
            switch result {
            case .success(let nftLikes):
                completion(.success(nftLikes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putLikes(id: [String], completion: @escaping NftLikeCompletion) {
        let dto = LikesDtoObject(likes: id)
        let request = LikesPutRequest(dto: dto)
        networkClient.send(request: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
