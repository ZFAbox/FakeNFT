import Foundation

typealias NftProfilePutCompletion = (Result<NftProfilePutResponse, Error>) -> Void

protocol NftProfilePutService {
    func sendProfilePutRequest(
        name: String,
        description: String,
        website: String,
        likes: [String],
        completion: @escaping NftProfilePutCompletion
    )
}

final class NftProfilePutServiceImpl: NftProfilePutService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func sendProfilePutRequest(
        name: String,
        description: String,
        website: String,
        likes: [String],
        completion: @escaping NftProfilePutCompletion
    ) {
        let dto = NftProfileDtoObject(name: name, description: description, website: website, likes: likes)
        let request = NftProfilePutRequest(dto: dto)
        networkClient.send(request: request, type: NftProfilePutResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
