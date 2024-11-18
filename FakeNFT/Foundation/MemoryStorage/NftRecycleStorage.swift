//
//  NftRecycleStorage.swift
//  FakeNFT
//
//  Created by Федор Завьялов on 18.11.2024.
//

import Foundation


final class NftRecycleStorage {
    
    static let shared = NftRecycleStorage()
    
    private var userDefaluts = UserDefaults.standard
    
    private init() {}
    
    private let key: String = "nftRecycle"
    
    var order: [String] {
        get {
            userDefaluts.object(forKey: key) as? [String] ?? []
        } set {
            userDefaluts.set(newValue, forKey: key)
            orderCounted = newValue
            print(newValue)
        }
    }
    
    var orderCounted: [String] {
        get {
            userDefaluts.object(forKey: "\(key)Counted") as? [String] ?? []
        } set {
            userDefaluts.set(newValue, forKey: "\(key)Counted")
        }
    }
}
