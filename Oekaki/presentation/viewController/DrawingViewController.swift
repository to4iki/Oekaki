import UIKit

final class DrawingViewController: UIViewController {

    @IBOutlet private weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTouchSaveButton(_ sender: UIBarButtonItem) {
        canvasView.clear()
    }
}
