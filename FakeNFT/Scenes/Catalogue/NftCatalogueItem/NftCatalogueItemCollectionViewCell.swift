import UIKit
import Kingfisher

final class NftCatalogueItemCollectionViewCell: UICollectionViewCell, SettingViewsProtocol {

    private var rank: Int = 0 {
        didSet {
            setRacnk()
        }
    }
    
    private var likeButtonState = false
    private var recycleIsEmpty = true
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likeImageButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .nftCollectionCartHeart)
        button.setImage(image, for: .normal)
        button.tintColor = .nftWhiteUni
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(starImage1)
        stack.addArrangedSubview(starImage2)
        stack.addArrangedSubview(starImage3)
        stack.addArrangedSubview(starImage4)
        stack.addArrangedSubview(starImage5)
        stack.spacing = 2
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var starImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .nftCollectionCardStar)
        imageView.tintColor = .nftLightGrey
        return imageView
    }()
    
    private lazy var starImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .nftCollectionCardStar)
        imageView.tintColor = .nftLightGrey
        return imageView
    }()
    
    private lazy var starImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .nftCollectionCardStar)
        imageView.tintColor = .nftLightGrey
        return imageView
    }()
    
    private lazy var starImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .nftCollectionCardStar)
        imageView.tintColor = .nftYellowUni
        return imageView
    }()
    
    private lazy var starImage5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .nftCollectionCardStar)
        imageView.tintColor = .nftLightGrey
        return imageView
    }()
    
    private lazy var itmeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var priceLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption3
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var recycleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .nftRecycleEmpty), for: .normal)
        button.addTarget(self, action: #selector(recycleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRacnk() {
        let starImageViews = [starImage1, starImage2, starImage3, starImage4, starImage5]
        starImageViews.prefix(upTo: rank).forEach{ $0.tintColor = UIColor(resource: .nftYellow) }
    }
    
    func configureItem(with item: NftCollectionItem, nftOrder: NftOrder) {
        itemImageView.kf.setImage(with: item.images.first)
        var itemName = item.name
        if itemName.count > 5 {
            itemName = itemName.prefix(5) + "..."
        }
        itmeTitle.text = itemName
        rank = item.rating
        priceLable.text = "\(item.price) ETH"
        recycleIsEmpty = !nftOrder.nfts.contains(item.id)
        recycleStateUpdate()
    }
    
    @objc func likeButtonTapped(){
        likeButtonState.toggle()
        likeImageButton.tintColor = likeButtonState
        ? .nftRedUni
        : .nftWhiteUni
    }
    
    @objc func recycleButtonTapped(){
        recycleIsEmpty.toggle()
        recycleStateUpdateAnimated()
    }
    
    
    func recycleStateUpdate(){
        let image = recycleIsEmpty
        ? UIImage(resource: .nftRecycleEmpty)
        : UIImage(resource: .nftRecycleFull)
        recycleButton.setImage(image, for: .normal)

    }
    
    func recycleStateUpdateAnimated(){
        let image = recycleIsEmpty
        ? UIImage(resource: .nftRecycleEmpty)
        : UIImage(resource: .nftRecycleFull)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.67) {
                let transformation = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.recycleButton.transform = transformation
            }
           UIView.addKeyframe(withRelativeStartTime: 0.67, relativeDuration: 1) {
               let transformation = CGAffineTransform(scaleX: 1.0, y: 1.0)
               self.recycleButton.transform = transformation
               self.recycleButton.setImage(image, for: .normal)
            }
        }
    }
    
    func setupView() {
        [itemImageView, likeImageButton, hStack, itmeTitle, priceLable, recycleButton].forEach { subView in
            contentView.addSubview(subView)
        }
    }
    
    func addConstraints() {
        itemImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.height.equalTo(108)
            make.width.equalTo(108)
        }
        
        likeImageButton.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.top)
            make.trailing.equalTo(itemImageView.snp.trailing)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        hStack.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(8)
            make.leading.equalTo(itemImageView.snp.leading)
            make.height.equalTo(12)
            make.width.equalTo(68)
        }
        
        itmeTitle.snp.makeConstraints { make in
            make.top.equalTo(hStack.snp.bottom).offset(5)
            make.leading.equalTo(itemImageView.snp.leading)
        }
        
        priceLable.snp.makeConstraints { make in
            make.top.equalTo(itmeTitle.snp.bottom).offset(4)
            make.leading.equalTo(itemImageView.snp.leading)
        }
        
        recycleButton.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(24)
            make.trailing.equalTo(itemImageView.snp.trailing)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
}
