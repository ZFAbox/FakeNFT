import Foundation

typealias NftOrderCompletion = (Result<NftOrder, Error>) -> Void

protocol NftOrderService {
    func loadNftOrder(completion: @escaping NftOrderCompletion)
}

final class NftOrderServiceImpl: NftOrderService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftOrder(completion: @escaping NftOrderCompletion) {

        let request = NftOrderRequest()
        networkClient.send(request: request, type: NftOrder.self) {result in
            switch result {
            case .success(let nftOrder):
                completion(.success(nftOrder))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
