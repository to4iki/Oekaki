import UIKit
import SVProgressHUD

final class DrawingViewController: UIViewController {

    @IBOutlet private weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTouchSaveButton(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            SVProgressHUD.showSuccess(withStatus: "saved :)")
            self?.canvasView?.clear()
        }
    }
}
