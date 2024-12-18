import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let networkClient = DefaultNetworkClient()
    private lazy var serviceAssembly = ServicesAssembly(
        networkClient: networkClient,
        nftStorage: NftStorageImpl(),
        nftCollectionCatalogueStorage: NftCollectionCatalogueStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController(servicesAssembly: serviceAssembly)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
