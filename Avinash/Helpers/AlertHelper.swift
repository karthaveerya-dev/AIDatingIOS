
import UIKit

class AlertHelper: NSObject {
    
    class func show(message: String?, controller: UIViewController?) {
        
        guard let title = message, let vc = controller else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: nil , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alertController.view.tintColor = .black
        
        vc.present(alertController,animated: true, completion: nil)
    }
    
    class func show(message: String?, controller: UIViewController?, completion: @escaping (UIAlertAction) -> ()) {
        
        guard let title = message, let vc = controller else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: nil , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: completion))
        alertController.view.tintColor = .black
        
        vc.present(alertController, animated: true)
    }
    
    class func show(message: String) {
        if let topController = UIApplication.topViewController() {
            show(message: message, controller: topController)
        }
    }
    
    class func showWithCompletion(title: String?, message: String, completion: @escaping () -> () ) {
        if let topController = UIApplication.topViewController() {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                completion()
            }))
            alertController.view.tintColor = .black
            
            topController.present(alertController, animated: true)
        }
    }
}
