import Foundation

struct NftOrderPutRequest: NetworkPutRequest {
   var endpoint: URL? {
       URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
   }
   var httpMethod: HttpMethod = .put
   var dto: DtoPut?
}

struct NftOrderDtoObject: DtoPut {
   let nfts: [String]

    enum CodingKeys: String, CodingKey {
        case nfts = "nfts"
    }

    func asDictionary() -> [String : String]{
        var dictionary: [String : String] = [ : ]
        for nft in nfts {
            dictionary[nft] = CodingKeys.nfts.rawValue
        }
        return dictionary
    }
}

struct OrderPutResponse: Decodable {
    let id: String
    let nfts: [String]
}
