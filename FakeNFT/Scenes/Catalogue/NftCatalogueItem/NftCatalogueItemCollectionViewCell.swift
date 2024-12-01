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

final class NftCatalogueItemCollectionViewCell: UICollectionViewCell, SettingViewsProtocol, ReuseIdentifying {
    
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
    private var nftItem: Nft = Nft(name: "", id: "", rating: 0, price: 0, images: [])
    private var nftsOrder: [String] = []
    private var recycleStorage = NftRecycleStorage.shared
    private var profileStorage = NftProfileStorage.shared
    private var likesStorage = NftLikesStorage.shared
    private var recycleIsEmpty = true
    private var alertPresenter: NftNotificationAlerPresenter?
    private var nftCardAssembly: NftCardViewControllerAssembly?
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    @objc func imageTapped () {
        nftCardAssembly?.present(with: nftItem)
    }
    
    private lazy var likeImageButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .nftCollectionCartHeart)
        button.setImage(image, for: .normal)
        button.tintColor = .nftWhiteUni
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cosmosView = CosmosRatingView()
    
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
        button.tintColor = .nftBlack
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
    
    func configureItem(with item: Nft, nftRecycleManager: NftRecycleManagerProtocol?, nftProfileManager: NftProfileManagerProtocol?, alertPresenter: NftNotificationAlerPresenter?, nftCardAssembly: NftCardViewControllerAssembly?) {
        
        self.nftCardAssembly = nftCardAssembly
        self.nftRecycleManager = nftRecycleManager
        self.nftProfileManager = nftProfileManager
        self.alertPresenter = alertPresenter
        
        nftItem = item
        
        itemImageView.kf.setImage(with: item.images.first)
        var itemName = item.name
        if itemName.count > 5 {
            itemName = itemName.prefix(5) + "..."
        }
        nftId = item.id
        itmeTitle.text = itemName
        cosmosView.setRank(item.rating)
        priceLable.text = "\(item.price) ETH"
        recycleStateUpdate()
        likeUpdate()
    }
    
    @objc private func likeButtonTapped(){
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
        likeUpdateAnimated(likeButtonState, likeImageButton)
    }
    
    @objc private func recycleButtonTapped(){
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
        recycleStateUpdateAnimated(recycleIsEmpty, recycleButton)
    }
    
    private func recycleStateUpdate(){
        let image = recycleIsEmpty
        ? UIImage(resource: .nftRecycleEmpty)
        : UIImage(resource: .nftRecycleFull)
        recycleButton.setImage(image, for: .normal)
        
    }
    
    private func likeUpdate(){
        likeImageButton.tintColor = likeButtonState
        ? .nftRedUni
        : .nftWhiteUni
    }
    
    func setupView() {
        contentView.addSubviews(itemImageView, likeImageButton, cosmosView, itmeTitle, priceLable, recycleButton)
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
        recycleStateUpdateAnimated(recycleIsEmpty, recycleButton)
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
