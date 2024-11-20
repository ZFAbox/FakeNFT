import UIKit

final class TabBarController: UITabBarController {

    private var catalogueServicesAssembly: CatalogueServicesAssembly

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(resource: .nftCatalogueTabBarItem),
        tag: 0
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
        
        let catalogueAssembly = NftCollectionCatalogueAssembly(catalogueServicesAssembler: catalogueServicesAssembly)
        let catalogController = catalogueAssembly.build()
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .systemBackground
    }
    
    private func adjustTapBarApperance(){
        
    }
}
