
import UIKit

class CosmosView: UIView {
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 2
        stack.axis = .horizontal
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(hStack)
        adjustStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func adjustStackView() {
        for _ in 1...5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(resource: .nftCollectionCardStar)
            starImageView.tintColor = .nftLightGrey
            hStack.addArrangedSubview(starImageView)
        }
    }
    
    func setRank(_ rank: Int) {
        hStack.arrangedSubviews.prefix(upTo: rank).forEach{ $0.tintColor = UIColor(resource: .nftYellow) }
    }
}
