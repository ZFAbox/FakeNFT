
import UIKit
import SnapKit
import Kingfisher

final class NftCollectionTableViewCell: UITableViewCell, SettingViewsProtocol {

    private lazy var collectionCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var collectiobTitleLabel: UILabel = {
     let lable = UILabel()
        lable.font = .bodyBold
        lable.textColor = .nftBlack
    return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        setupView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: NftCatalogueCollection) {
        collectionCoverImageView.kf.setImage(with: model.cover)
        let collectionName = model.name
        let nftCollectionAmount = model.nfts.count
        collectiobTitleLabel.text = "\(collectionName) (\(nftCollectionAmount))"
    }
    
    func setupView() {
        [collectionCoverImageView, collectiobTitleLabel].forEach { contentView.addSubview($0) }
    }
    
    func addConstraints() {
        collectionCoverImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(4)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(140)
        }
        collectiobTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionCoverImageView.snp.bottom).offset(4)
            make.left.equalTo(collectionCoverImageView)
            make.right.equalTo(collectionCoverImageView)
            make.bottom.equalTo(contentView).offset(-17)
        }
    }
}
