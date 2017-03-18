import UIKit

final class IllustPreviewViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    private var image: UIImage?

    static func instantiate() -> IllustPreviewViewController {
        let storyboard = UIStoryboard(name: "IllustPreview", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "IllustPreviewViewController") as! IllustPreviewViewController
    }

    static func instantiate(image: UIImage) -> IllustPreviewViewController {
        let viewController = instantiate()
        viewController.image = image
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
