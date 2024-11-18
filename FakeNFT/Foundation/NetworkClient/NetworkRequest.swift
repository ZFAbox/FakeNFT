import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Dto? { get }
}

protocol NetworkPutRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: DtoPut? { get }
}

protocol Dto {
    func asDictionary() -> [String: String]
}

protocol DtoPut {
    func asDictionary() -> [String: String]
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
