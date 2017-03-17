import UIKit
import RxSwift

final class HandlePathView: UIView {

    fileprivate var currentPath: Path?
    fileprivate var mode: Mode = .draw

    let store = Store()

    private static let ForceTouchThreshold: CGFloat = 3.0

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        began(with: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        let force = touch.force > HandlePathView.ForceTouchThreshold
        moved(with: point, force: force)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        ended()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ended()
    }
}

extension HandlePathView {

    func clear() {
        currentPath = nil
        mode = .draw
    }
    
    fileprivate func began(with point: CGPoint) {
        let path = Path()
        path.movePoint(to: point)
        path.line(to: point)
        currentPath = path
    }

    fileprivate func moved(with point: CGPoint, force: Bool) {
        switch mode {
        case .draw where force:
            mode = .move
            store.moveTo.value = point
        case .draw:
            currentPath?.line(to: point)
            store.path.value = currentPath
        case .move:
            store.moveTo.value = point
        }
    }

    fileprivate func ended() {
        switch mode {
        case .draw:
            store.path.value = currentPath
        case .move:
            store.moveTo.value = nil
        }
        currentPath = nil
        mode = .draw
    }
}

// MARK: - Mode
extension HandlePathView {

    fileprivate enum Mode {
        case draw, move
    }
}

// MARK: - State
extension HandlePathView {

    struct Store {
        let path: Variable<Path?> = Variable(nil)
        let moveTo: Variable<CGPoint?> = Variable(nil)
    }
}
