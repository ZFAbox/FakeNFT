import UIKit

final class TabBarController: UITabBarController {

    private var catalogueServicesAssembly: CatalogueServicesAssembly

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(resource: .nftCatalogueTabBarItem),
        tag: 0
    )
    
    //Тестовый элемент TabBar
    private let testTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 1
    )
    
    init(catalogueServicesAssembly: CatalogueServicesAssembly) {
        self.catalogueServicesAssembly = catalogueServicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustTapBarApperance()
        setupViewControllers()
    }
    
    private func adjustTapBarApperance(){
        tabBar.unselectedItemTintColor = .nftBlack
        tabBar.tintColor = .nftBlueUni
        view.backgroundColor = .systemBackground
    }
    
    private func setupViewControllers() {
        //Тестовый элемент для проверки цветовой заливки иконок
        let testProfileViewController = UIViewController()
        testProfileViewController.tabBarItem = testTabBarItem
        
        let catalogueAssembly = NftCollectionCatalogueAssembly(catalogueServicesAssembler: catalogueServicesAssembly)
        let catalogController = catalogueAssembly.build()
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController, testProfileViewController]
    }
}
