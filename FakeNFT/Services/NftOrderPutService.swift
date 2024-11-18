import Foundation

typealias NftOrderPutCompletion = (Result<OrderPutResponse, Error>) -> Void

protocol NftOrderPutService {
    func sendOrderPutRequest(
        nfts: [String],
        completion: @escaping NftOrderPutCompletion
    )
}

final class NftOrderPutServiceImpl: NftOrderPutService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func sendOrderPutRequest(
        nfts: [String],
        completion: @escaping NftOrderPutCompletion
    ) {
        let dto = NftOrderDtoObject(nfts: nfts)
        let request = NftOrderPutRequest(dto: dto)
        networkClient.send(request: request, type: OrderPutResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
