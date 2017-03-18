import UIKit

final class DrawingViewController: UIViewController {

    @IBOutlet private weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTouchSaveButton(_ sender: UIBarButtonItem) {
        canvasView.clear()
        guard let image = dummyImage() else { return }
        IllustRepositoryOnMemory.shared.save(image: image)
    }

    // TODO: impl
    private func dummyImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(canvasView.frame.size, false, 1.0)
        let path = Path()
        path.movePoint(to: CGPoint(x: 160, y: 50))
        path.line(to: CGPoint(x: 220, y: 150))
        path.line(to: CGPoint(x: 90, y: 150))
        path.line(to: CGPoint(x: 160, y: 50))
        path.draw(CGRect.zero)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
