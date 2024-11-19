final class CatalogueServicesAssembly {

    private let networkClient: NetworkClient
    private let nftCollectionCatalogueStorage: NftCollectionCatalogueStorage
    private let nftCollectionItemsStorage: NftCollectionItemsStorage

    init(
        networkClient: NetworkClient,
        nftCollectionCatalogueStorage: NftCollectionCatalogueStorage,
        nftCollectionItemsStorage: NftCollectionItemsStorage
    ) {
        self.networkClient = networkClient
        self.nftCollectionCatalogueStorage = nftCollectionCatalogueStorage
        self.nftCollectionItemsStorage = nftCollectionItemsStorage
    }

    var nftCollectionCataloguService: NftCollectionCatalogueService {
        NftCollectionCatalogueServiceImpl(
            networkClient: networkClient,
            storage: nftCollectionCatalogueStorage
        )
    }
    
    var nftItemsService: NftItemsService {
        NftItemsServiceImpl(
            networkClient: networkClient,
            storage: nftCollectionItemsStorage
        )
    }
    
    var nftOrderService: NftOrderService {
        NftOrderServiceImpl(
            networkClient: networkClient
        )
    }
    
    var nftOrderPutService: NftOrderPutService {
        NftOrderPutServiceImpl(
            networkClient: networkClient
        )
    }
    
    var nftLikesService: NftLikesService {
        NftLikesServiceImpl(networkClient: networkClient)
    }
    
}
