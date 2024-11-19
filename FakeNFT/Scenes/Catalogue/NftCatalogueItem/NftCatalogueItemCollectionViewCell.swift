import UIKit
import Kingfisher

protocol NftItemRecycleUnlockProtocol: AnyObject {
    func recycleUnlock()
}

protocol NftItemLikeUnlockProtocol: AnyObject {
    func likeUnlock()
}

final class NftCatalogueItemCollectionViewCell: UICollectionViewCell, SettingViewsProtocol {
    
    private var rank: Int = 0 {
        didSet {
            setRacnk()
        }
    }
    
    private var likeButtonState = false
    private var nftRecycleManager: NftRecycleManagerProtocol?
    private var nftProfileManager: NftProfileManagerProtocol?
    private var nftId: String = "" {
        didSet {
            recycleIsEmpty = !recycleStorage.orderCounted.contains(nftId)
            if let index = recycleStorage.orderCounted.firstIndex(of: nftId) {
                recycleStorage.orderCounted.remove(at: index)
            }
            print(likesStorage.likesCounted)
            likeButtonState = likesStorage.likesCounted.contains(nftId)
            if let index = likesStorage.likesCounted.firstIndex(of: nftId) {
                likesStorage.likesCounted.remove(at: index)
            }
        }
    }
    private var nftsOrder: [String] = []
    private var recycleStorage = NftRecycleStorage.shared
    private var profileStorage = NftProfileStorage.shared
    private var likesStorage = NftLikesStorage.shared
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
    
    func configureItem(with item: NftCollectionItem, nftRecycleManager: NftRecycleManagerProtocol?, nftProfileManager: NftProfileManagerProtocol?) {
        itemImageView.kf.setImage(with: item.images.first)
        var itemName = item.name
        if itemName.count > 5 {
            itemName = itemName.prefix(5) + "..."
        }
        self.nftRecycleManager = nftRecycleManager
        self.nftProfileManager = nftProfileManager
        nftId = item.id
        itmeTitle.text = itemName
        rank = item.rating
        priceLable.text = "\(item.price) ETH"
        recycleStateUpdate()
        likeUpdate()
    }
    
    @objc func likeButtonTapped(){
        self.nftProfileManager?.delegate = self
        let profile = profileStorage.profile
        guard let nftProfileManager = nftProfileManager else { return }
        if !likeButtonState {
            likesStorage.likes.append(nftId)
        }else {
            guard let index = likesStorage.likes.firstIndex(of: nftId) else { return }
            likesStorage.likes.remove(at: index)
        }
        let updateProfile = NftProfile(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            likes: likesStorage.likes
        )
        profileStorage.profile = updateProfile
        likeImageButton.isUserInteractionEnabled = false
        nftProfileManager.sendProfile()
    }
    
    @objc func recycleButtonTapped(){
        self.nftRecycleManager?.delegate = self
        guard let nftRecycleManager = nftRecycleManager else { return }
        if recycleIsEmpty {
            recycleStorage.order.append(nftId)
            print(recycleStorage.order)
        } else {
            if let index = recycleStorage.order.firstIndex(of: nftId) {
                recycleStorage.order.remove(at: index)
            }
        }
        recycleButton.isUserInteractionEnabled = false
        nftRecycleManager.sendOrder()
        recycleIsEmpty.toggle()
        recycleStateUpdateAnimated()
    }
    
    func recycleStateUpdate(){
        let image = recycleIsEmpty
        ? UIImage(resource: .nftRecycleEmpty)
        : UIImage(resource: .nftRecycleFull)
        recycleButton.setImage(image, for: .normal)
        
    }
    
    func likeUpdate(){
        likeImageButton.tintColor = likeButtonState
        ? .nftRedUni
        : .nftWhiteUni
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

extension NftCatalogueItemCollectionViewCell: NftItemRecycleUnlockProtocol {
    func recycleUnlock() {
        recycleButton.isUserInteractionEnabled = true
    }
}


extension NftCatalogueItemCollectionViewCell: NftItemLikeUnlockProtocol {
    func likeUnlock() {
        likeImageButton.isUserInteractionEnabled = true
        likeButtonState.toggle()
        likeUpdate()
    }
}
