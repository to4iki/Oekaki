import UIKit

final class IllustCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    static let Identifier = "IllustCollectionViewCell"
    private static let Nib: UINib = UINib(nibName: IllustCollectionViewCell.Identifier, bundle: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }

    static func register(to collectionView: UICollectionView) {
        collectionView.register(IllustCollectionViewCell.Nib, forCellWithReuseIdentifier: IllustCollectionViewCell.Identifier)
    }

    static func dequeue(cellOf: String, by collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IllustCollectionViewCell.Identifier, for: indexPath) as! IllustCollectionViewCell
        cell.set(cellOf)
        return cell
    }
}

extension IllustCollectionViewCell {

    func set(_ string: String) {
    }
}
