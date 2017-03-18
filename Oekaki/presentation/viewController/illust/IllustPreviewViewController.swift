import UIKit

final class IllustPreviewViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    fileprivate var image: UIImage?

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

extension IllustPreviewViewController {

    override var previewActionItems: [UIPreviewActionItem] {
        let saveImageToPhotosAlbumHandler = { [weak self] (action: UIPreviewAction, viewController: UIViewController) -> Void in
            guard let image = self?.image else { return  }
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
        let saveImageAction = UIPreviewAction(title: "save", style: .default, handler: saveImageToPhotosAlbumHandler)
        let deleteImageAction = UIPreviewAction(title: "delete", style: .destructive, handler: { _ in print("onDelegetImageAction") })
        return [saveImageAction, deleteImageAction]
    }
}
