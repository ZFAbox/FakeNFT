import UIKit

final class NftCardImageCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(scrollView)
        scrollView.constraintEdges(to: contentView)
        scrollView.addSubview(imageView)
        imageView.constraintCenters(to: scrollView)
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func configure(with cellModel: URL) {
        imageView.kf.setImage(with: cellModel)
    }
}

// MARK: - UIScrollViewDelegate

extension NftCardImageCollectionViewCell: UIScrollViewDelegate {

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
