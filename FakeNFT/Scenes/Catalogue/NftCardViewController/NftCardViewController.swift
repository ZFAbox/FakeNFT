//
//  NftCardViewController.swift
//  FakeNFT
//
//  Created by Федор Завьялов on 26.11.2024.
//
import UIKit

protocol NftCardViewControllerProtocol: AnyObject, ErrorView, LoadingView {
    func displayCurencies(_ curencies: [Currency])
}

final class NftCardViewController: UIViewController, LoadingView {
    
    private var presenter: NftCardPresenter
    private var nft: Nft
    private var nftCollection: [Nft]
    private var cellModels: [URL] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .nftCollectionBackwardChevron)
        button.setImage(image, for: .normal)
        button.tintColor = .nftBlack
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .nftCollectionCartHeart)
        button.setImage(image, for: .normal)
        button.tintColor = .nftRedUni
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NftCardImageCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 40
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return collectionView
    }()
    
    private lazy var pageControl = LinePageControl()
    
    private lazy var nftTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var catalogueTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var priceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var priceLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold17
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var addToRecycleButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonText = NSLocalizedString("Add.to.cart", comment: "")
        button.setTitle(buttonText, for: .normal)
        button.tintColor = .nftWhite
        button.backgroundColor = .nftBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addToRecycleTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cosmosView = CosmosRatingView()

    init(nft: Nft, nftCollection: [Nft], presenter: NftCardPresenter) {
        self.nft = nft
        self.cellModels = nft.images
        self.nftCollection = nftCollection
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfItems = cellModels.count
        setupView()
        addConstraints()
    }
    
    @objc private func backButtonTapped(){
        self.hideLoading()
        self.dismiss(animated: true)
    }
    
    @objc private func likeButtonTapped(){

    }
    
    @objc private func addToRecycleTapped(){
        
    }
    
    private func setupView() {
        view.backgroundColor = .nftWhite
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(collectionView, pageControl, backButton, likeButton)
    }
    
    private func addConstraints() {
            scrollView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(55)
            make.leading.equalTo(view.snp.leading).offset(9)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(46)
            make.trailing.equalTo(view.snp.trailing).offset(-9)
            make.height.equalTo(42)
            make.width.equalTo(42)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.height.equalTo(view.bounds.width)
            make.width.equalTo(view.bounds.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.height.equalTo(4)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    
    }
    
}

extension NftCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftCardImageCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NftCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width, height: view.bounds.width)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedItem = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.selectedItem = selectedItem
    }
}

extension NftCardViewController: NftCardViewControllerProtocol {
    func displayCurencies(_ curencies: [Currency]) {
        
    }
}
