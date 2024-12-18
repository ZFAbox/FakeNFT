import Foundation

final class FilterStateStorage {
    static let shared = FilterStateStorage()
    
    private let userDefaults = UserDefaults.standard
    
    private enum UserDefaultsKeys {
        static let filterOption = "filterOption"
    }
    
    var filterOption: FilterOption? {
        get {
            if let filterDescription = userDefaults.string(forKey: UserDefaultsKeys.filterOption) {
                return FilterOption(rawValue: filterDescription)
            }
            return nil
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: UserDefaultsKeys.filterOption)
        }
    }
    
    private init() {}
}
