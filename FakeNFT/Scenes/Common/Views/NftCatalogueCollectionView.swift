	
import UIKit

final class NftCatalogueCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        setupView()
    }
    
    private func setupView(){
        self.register(NftCatalogueItemCollectionViewCell.self, forCellWithReuseIdentifier: "collectioItem")
        self.backgroundColor = .nftWhite
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
