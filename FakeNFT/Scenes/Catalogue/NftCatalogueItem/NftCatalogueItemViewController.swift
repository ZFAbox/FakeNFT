
import UIKit
import Kingfisher

protocol NftCatalogueItemViewControllerProtocol: AnyObject, ErrorView, LoadingView {
    func displayItems(_ nftCollectionItems: [NftCollectionItem], _ nftOrder: NftOrder)
}

final class NftCatalogueItemViewController: UIViewController, SettingViewsProtocol  {

    private var catalogue: NftCatalogueCollection
    private var catalogeItems: [NftCollectionItem] = []
    private var nftOrder: NftOrder = NftOrder(nfts: [], id: "")
    
    private var presenter: NftCatalogueItemPresenter
    
    private lazy var nftCatalogueCollectionHeight: Int = {
        let heightOfCollectionItem: Int = 192
        let separatorHeight: Int = 8
        let numberOItemsInRow: Int = 3
        let numberOfCompletedRows: Int = catalogue.nfts.count / numberOItemsInRow
        let nubmerOfIncompletedRows: Int = numberOfCompletedRows + 1
        var numberOfRows = catalogue.nfts.count % numberOItemsInRow == 0
        ? numberOfCompletedRows
        : nubmerOfIncompletedRows
        let numberOfSeparators = numberOfRows - 1
        return numberOfRows * heightOfCollectionItem + numberOfSeparators * separatorHeight
    }()

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
    
    private lazy var coverImgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    
    private lazy var catalogueTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .nftBlack
        label.text = "Автор коллекции:"
        return label
    }()
    
    private lazy var authorButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.nftBlueUni, for: .normal)
        button.titleLabel?.font = UIFont.caption1
        return button
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let label = UITextView()
        label.font = UIFont.caption2
        label.textColor = .nftBlack
        label.backgroundColor = .nftWhite
        label.textContainer.lineFragmentPadding = 0
        label.isScrollEnabled = false
        label.isEditable = false
        label.isSelectable = false
        return label
    }()
    
    private lazy var nftCatalogueCollectionView: NftCatalogueCollectionView = {
        let collectionView = NftCatalogueCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    init(presenter: NftCatalogueItemPresenter, catalogue: NftCatalogueCollection) {
        self.presenter = presenter
        self.catalogue = catalogue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .nftWhite
        setupView()
        addConstraints()
        prepareViews()
        presenter.viewDidLoad()
    }
    
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
    
    func prepareViews() {
        coverImgeView.kf.setImage(with: catalogue.cover)
        catalogueTitleLabel.text = catalogue.name
        descriptionTextView.text = catalogue.description
        authorButton.setTitle(catalogue.author, for: .normal)
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [coverImgeView, backButton, catalogueTitleLabel, authorLabel, authorButton, descriptionTextView, nftCatalogueCollectionView].forEach{contentView.addSubview($0)}
    }
    
    func addConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        coverImgeView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(310)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(coverImgeView.snp.top).offset(55)
            make.leading.equalTo(view.snp.leading).offset(9)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        catalogueTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImgeView.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(28)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(catalogueTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.height.equalTo(28)
        }
        
        authorButton.snp.makeConstraints { make in
            make.top.equalTo(catalogueTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(authorLabel.snp.trailing).offset(4)
            make.height.equalTo(28)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }
        
        nftCatalogueCollectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            make.leading.equalTo(coverImgeView.snp.leading).offset(16)
            make.trailing.equalTo(coverImgeView.snp.trailing).offset(-16)
            make.height.equalTo(nftCatalogueCollectionHeight)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
}

extension NftCatalogueItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catalogeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioItem", for: indexPath) as! NftCatalogueItemCollectionViewCell
        cell.configureItem(with: catalogeItems[indexPath.row], nftOrder: nftOrder)
        return cell
    }
}

extension NftCatalogueItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = 192
        let itemWidth = 108
        let size = CGSize(width: itemWidth, height: itemHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

extension NftCatalogueItemViewController: NftCatalogueItemViewControllerProtocol {
    func displayItems(_ nftCollectionItems: [NftCollectionItem], _ nftOrder: NftOrder) {
        catalogeItems = nftCollectionItems
        self.nftOrder = nftOrder
        nftCatalogueCollectionView.reloadData()
    }
}
