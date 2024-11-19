
import Foundation

final class NftProfileStorage {
    
    static let shared = NftProfileStorage()
    
    private var userDefaluts = UserDefaults.standard
    
    private let defaultProfile = NftProfile(name: "", description: "", website: "", likes: [""])
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    private init() {}
    
    private let key: String = "nftProfile"
    
    var profile: NftProfile {
        get {
            guard let decodedData = userDefaluts.object(forKey: key) else { return defaultProfile}
            guard let profile = try? decoder.decode(NftProfile.self, from: decodedData as! Data) else { return defaultProfile}
            return profile
        } set {
            NftLikesStorage.shared.likes = newValue.likes
            let encodedData = try? encoder.encode(newValue)
            userDefaluts.set(encodedData, forKey: key)
        }
    }
}
