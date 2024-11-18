//import Foundation
//
//struct NftOrderPutRequest: NetworkRequest {
//   var endpoint: URL? {
//       URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
//   }
//   var httpMethod: HttpMethod = .put
//   var dto: Dto?
//}
//
//struct NftOrderDtoObject: Dto {
//   let nfts: String
//
//    enum CodingKeys: String, CodingKey {
//        case nfts = "nfts"
//    }
//
//    func asDictionary() -> [String : String] {
//        [
//            CodingKeys.nfts.rawValue: nfts
//        ]
//    }
//}
//
//struct OrderPutResponse: Decodable {
//    let id: String
//    let nfts: [String]
//}
