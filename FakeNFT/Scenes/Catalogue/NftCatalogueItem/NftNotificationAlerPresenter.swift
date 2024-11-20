
import UIKit

enum AlertMessage: String {
    case likeNotification = "Nft уже добавлен в избранное!"
    case orderNotification = "Nft уже добавлен в корзину!"
}

final class NftNotificationAlerPresenter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showNotificationAlert(with notification: AlertMessage){
        let alert = UIAlertController(title: nil, message: notification.rawValue, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
}
