import UIKit
import Kingfisher

// MARK: - Protocol

protocol NftItemRecycleUnlockProtocol: AnyObject {
    func recycleUnlock()
    func recyclePreviousStateUpdate()
}

protocol NftItemLikeUnlockProtocol: AnyObject {
    func likeUnlock()
    func likesPreviousStateUpdate()
}

final class NftCatalogueItemCollectionViewCell: UICollectionViewCell, SettingViewsProtocol {
    
    // MARK: - Properties
    
    private var likeButtonState = false
    private var nftRecycleManager: NftRecycleManagerProtocol?
    private var nftProfileManager: NftProfileManagerProtocol?
    private var profileBeforeUpdate: NftProfile?
    private var recycleBeforeUpdate: [String]?
    private var nftId: String = "" {
        didSet {
            recycleIsEmpty = !recycleStorage.orderCounted.contains(nftId)
            if let index = recycleStorage.orderCounted.firstIndex(of: nftId) {
                recycleStorage.orderCounted.remove(at: index)
            }
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
    private var alertPresenter: NftNotificationAlerPresenter?
    
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
    
    private lazy var cosmosView = CosmosView()
    
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureItem(with item: NftCollectionItem, nftRecycleManager: NftRecycleManagerProtocol?, nftProfileManager: NftProfileManagerProtocol?, alertPresenter: NftNotificationAlerPresenter?) {
        itemImageView.kf.setImage(with: item.images.first)
        var itemName = item.name
        if itemName.count > 5 {
            itemName = itemName.prefix(5) + "..."
        }
        self.nftRecycleManager = nftRecycleManager
        self.nftProfileManager = nftProfileManager
        self.alertPresenter = alertPresenter
        nftId = item.id
        itmeTitle.text = itemName
        cosmosView.setRank(item.rating)
        priceLable.text = "\(item.price) ETH"
        recycleStateUpdate()
        likeUpdate()
    }
    
    @objc func likeButtonTapped(){
        self.nftProfileManager?.delegate = self
        profileBeforeUpdate = profileStorage.profile
        guard let nftProfileManager = nftProfileManager else { return }
        if !likeButtonState {
            if  likesStorage.likes.contains(nftId) {
                alertPresenter?.showNotificationAlert(with: .likeNotification)
                return
            }
            likesStorage.likes.append(nftId)
        }else {
            guard let index = likesStorage.likes.firstIndex(of: nftId) else { return }
            likesStorage.likes.remove(at: index)
        }
        guard let profile = profileBeforeUpdate else { return }
        let updateProfile = NftProfile(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            likes: likesStorage.likes
        )
        profileStorage.profile = updateProfile
        likeImageButton.isUserInteractionEnabled = false
        nftProfileManager.sendProfile()
        likeButtonState.toggle()
        likeUpdateAnimated()
    }
    
    @objc func recycleButtonTapped(){
        self.nftRecycleManager?.delegate = self
        recycleBeforeUpdate = recycleStorage.order
        guard let nftRecycleManager = nftRecycleManager else { return }
        if recycleIsEmpty {
            if  recycleStorage.order.contains(nftId) {
                alertPresenter?.showNotificationAlert(with: .orderNotification)
                return
            }
            recycleStorage.order.append(nftId)
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
    
    func likeUpdateAnimated(){
        let likeButtonColor: UIColor = likeButtonState
        ? .nftRedUni
        : .nftWhiteUni
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                let rotateTransform = CGAffineTransform.init(rotationAngle: 0.35)
                let scaleTransform = CGAffineTransform(scaleX: 1.1, y: 1.3).concatenating(rotateTransform)
                self.likeImageButton.transform = scaleTransform
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.6) {
                let rotateTransform = CGAffineTransform.init(rotationAngle: -0.4)
                let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5).concatenating(rotateTransform)
                self.likeImageButton.transform = scaleTransform
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.8) {
                let rotateTransform = CGAffineTransform.init(rotationAngle: 0.1)
                let scaleTransform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(rotateTransform)
                self.likeImageButton.transform = scaleTransform
            }
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 1) {
                let rotateTransform = CGAffineTransform.init(rotationAngle: 0)
                let scaleTransform = CGAffineTransform(scaleX: 1, y: 1).concatenating(rotateTransform)
                self.likeImageButton.transform = scaleTransform
                self.likeImageButton.tintColor = likeButtonColor
            }
        }
    }
    
    func setupView() {
        [itemImageView, likeImageButton, cosmosView, itmeTitle, priceLable, recycleButton].forEach { subView in
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
        
        cosmosView.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(8)
            make.leading.equalTo(itemImageView.snp.leading)
            make.height.equalTo(12)
            make.width.equalTo(68)
        }
        
        itmeTitle.snp.makeConstraints { make in
            make.top.equalTo(cosmosView.snp.bottom).offset(5)
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
    func recyclePreviousStateUpdate() {
        guard let recycleBeforeUpdate = recycleBeforeUpdate else { return }
        recycleStorage.order = recycleBeforeUpdate
        recycleIsEmpty.toggle()
        recycleStateUpdateAnimated()
        recycleButton.isUserInteractionEnabled = true
    }
    
    func recycleUnlock() {
        recycleButton.isUserInteractionEnabled = true
    }
}

extension NftCatalogueItemCollectionViewCell: NftItemLikeUnlockProtocol {
    func likesPreviousStateUpdate() {
        guard let profileBeforeUpdate = profileBeforeUpdate else { return }
        profileStorage.profile = profileBeforeUpdate
        likeButtonState.toggle()
        likeUpdate()
        likeImageButton.isUserInteractionEnabled = true
    }
    
    func likeUnlock() {
        likeImageButton.isUserInteractionEnabled = true
    }
}
