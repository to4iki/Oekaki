import UIKit

// TODO: impl
final class IllustRepositoryOnMemory {

    static let shared = IllustRepositoryOnMemory()
    private var store: [UIImage] = []

    func load() -> [UIImage] {
        return store
    }

    func save(image: UIImage) {
        store.append(image)
    }
}
