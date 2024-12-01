
import UIKit

final class CurrencyLableStackView: UIStackView {
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var currencyName: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var currencyPrice: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .nftBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addArrangedSubview(vStack)
        vStack.addArrangedSubview(currencyName)
        vStack.addArrangedSubview(currencyPrice)
    }
    
    func setCurrency(_ currencyName: String, _ currencyUSDRate: Double) {
        self.currencyName.text = currencyName
        currencyPrice.text = "$" + String(format: "%.2f", currencyUSDRate)
    }
    
}
