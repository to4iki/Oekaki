import UIKit

final class PathGroup: UIView {

    let token: MovableToken
    fileprivate var paths: [Path] = []
    fileprivate var liftedPoint: CGPoint?
    fileprivate var originCenter: CGPoint?

    override init(frame: CGRect) {
        self.token = UUID().uuidString
        super.init(frame: frame)
        commonInit()
    }

    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.token = UUID().uuidString
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension PathGroup {

    fileprivate func commonInit() {
        backgroundColor = .clear
    }

    func addPath(_ path: Path) {
        paths.append(path)
    }

    func contains(path: Path) -> Bool {
        return paths.last?.token == path.token
    }
}

// MARK: - Drawable
extension PathGroup: Drawable {

    override func draw(_ rect: CGRect) {
        for path in paths {
            path.draw(rect)
        }
    }
}

// MARK: - Movable
extension PathGroup: Movable {

    func lift(at point: CGPoint) {
        liftedPoint = point
        originCenter = center
    }

    func move(to point: CGPoint) {
        guard let liftedPoint = liftedPoint, let originCenter = originCenter else { return }
        center = CGPoint(
            x: originCenter.x - (liftedPoint.x - point.x),
            y: originCenter.y - (liftedPoint.y - point.y)
        )

        paths.forEach { $0.originPoint = frame.origin }
    }

    func drop() {
        liftedPoint = nil
    }
    
    func isNear(from targetPath: Path) -> Bool {
        for path in paths where path.isNear(from: targetPath) {
            return true
        }
        return false
    }

    func isNear(from targetPoint: CGPoint) -> Bool {
        for path in paths where path.isNear(from: targetPoint) {
            return true
        }
        return false
    }
}
