
import UIKit

final class NftCurenciesRateTableViewCell: UITableViewCell, SettingViewsProtocol {
    
    let currencyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    let currencyStack = CurrencyLableStackView()
    
    let nftPrice: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftGreenUni
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(currencyImage)
        contentView.addSubview(currencyStack)
        contentView.addSubview(nftPrice)
    }
    
    func addConstraints() {
        
        currencyImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        
        currencyStack.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(currencyImage.snp.trailing).offset(10)
            
        }
        
        nftPrice.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            
        }
    }
}
