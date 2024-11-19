
import Foundation


final class NftLikesStorage {
    
    static let shared = NftLikesStorage()
    
    private var userDefaluts = UserDefaults.standard
    
    private init() {}
    
    private let key: String = "nftLikes"
    
    var likes: [String] {
        get {
            userDefaluts.object(forKey: key) as? [String] ?? []
        } set {
            userDefaluts.set(newValue, forKey: key)
            likesCounted = newValue
        }
    }
    
    var likesCounted: [String] {
        get {
            userDefaluts.object(forKey: "\(key)Counted") as? [String] ?? []
        } set {
            userDefaluts.set(newValue, forKey: "\(key)Counted")
        }
    }
}
