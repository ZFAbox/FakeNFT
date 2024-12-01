import UIKit

final class CurrenciesRateTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    private func setupView(){
        self.backgroundColor = .nftLightGrey
        self.separatorStyle = .none
        self.register(NftCurenciesRateTableViewCell.self, forCellReuseIdentifier: "collection cell")
        self.isScrollEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
