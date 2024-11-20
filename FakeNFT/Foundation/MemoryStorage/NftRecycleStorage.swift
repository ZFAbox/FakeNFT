
import Foundation


final class NftRecycleStorage {
    
    static let shared = NftRecycleStorage()
    
    private let key: String = "nftRecycle"
    private var userDefaluts = UserDefaults.standard
    var order: [String] {
        get {
            userDefaluts.object(forKey: key) as? [String] ?? []
        } set {
            userDefaluts.set(newValue, forKey: key)
            orderCounted = newValue
        }
    }
    var orderCounted: [String] {
        get {
            userDefaluts.object(forKey: "\(key)Counted") as? [String] ?? []
        } set {
            userDefaluts.set(newValue, forKey: "\(key)Counted")
        }
    }
    
    private init() {}
}
