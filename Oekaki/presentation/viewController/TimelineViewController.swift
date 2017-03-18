import UIKit

final class TimelineViewController: UIViewController {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate var illustImages: [UIImage] = []

    fileprivate lazy var cellSize: CGSize = {
        let width: CGFloat = (self.view.frame.width / 3) - 2
        return CGSize(width: width, height: width)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPreviewing()
        illustImages = IllustRepositoryOnMemory.shared.load()
    }
}

extension TimelineViewController {

    fileprivate func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        IllustCollectionViewCell.register(to: collectionView)
    }

    fileprivate func setupPreviewing() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TimelineViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return illustImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return IllustCollectionViewCell.dequeue(cellOf: illustImages[indexPath.row], by: collectionView, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension TimelineViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TimelineViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension TimelineViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("peek")
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        previewingContext.sourceRect = cell.frame
        let illust = illustImages[indexPath.row]
        return IllustPreviewViewController.instantiate(image: illust)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        print("pop")
    }
}
