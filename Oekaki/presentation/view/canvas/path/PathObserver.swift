import UIKit
import RxSwift

final class PathObserver {

    private var pathGroups: [PathGroup] = []
    private var currentPathGroupe: PathGroup {
        if let group = pathGroups.last {
            return group
        } else {
            let group = PathGroup()
            pathGroups.append(group)
            return group
        }
    }

    let store = Store()
    
    func handlePath(_ path: Path) {
        defer { store.pathGroup.value = currentPathGroupe }

        guard !currentPathGroupContains(path: path) else { return }
        if let group = nearGroup(from: path) {
            let groupOrigin = group.frame.origin
            group.addPath(path.translatedPath(with: groupOrigin))
        } else {
            let group = PathGroup()
            group.addPath(path)
            pathGroups.append(group)
        }
    }

    func clear() {
        pathGroups.removeAll()
    }

    private func currentPathGroupContains(path: Path) -> Bool {
        return currentPathGroupe.contains(path: path)
    }

    private func nearGroup(from path: Path) -> PathGroup? {
        for group in pathGroups where group.isNear(from: path) {
            return group
        }
        return nil
    }
}

// MARK: - Store
extension PathObserver {

    struct Store {
        let pathGroup: Variable<PathGroup?> = Variable(nil)
    }
}
