import Foundation

struct NftProfilePutRequest: NetworkPutRequest {
   var endpoint: URL? {
       URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
   }
   var httpMethod: HttpMethod = .put
   var dto: DtoPut?
}

struct NftProfileDtoObject: DtoPut {
    let name: String
    let description: String
    let website: String
    let likes: [String]

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case website = "website"
        case likes = "likes"
    }

    func asDictionary() -> [String : String]{
        var dictionary: [String : String] = [ : ]
        dictionary[name] = CodingKeys.name.rawValue
        dictionary[description] = CodingKeys.description.rawValue
        dictionary[website] = CodingKeys.website.rawValue
        for like in likes {
            dictionary[like] = CodingKeys.likes.rawValue
        }
        return dictionary
    }
}

struct NftProfilePutResponse: Decodable {
    let name: String
    let description: String
    let website: String
    let likes: [String]
}
