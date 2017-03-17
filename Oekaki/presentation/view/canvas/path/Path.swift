import UIKit

final class Path {

    let token: MovableToken
    fileprivate let color: UIColor
    fileprivate let width: CGFloat
    
    fileprivate let bezierPath = UIBezierPath()
    var originPoint: CGPoint = .zero

    private static let DistanceForNearChecking: CGFloat = -20
    
    fileprivate var extendedBounds: CGRect {
        let bounds = bezierPath.bounds
        let currentRect = CGRect(
            x: bounds.origin.x + originPoint.x,
            y: bounds.origin.y + originPoint.y,
            width: bounds.size.width,
            height: bounds.size.height
        )
        return currentRect.insetBy(
            dx: Path.DistanceForNearChecking,
            dy: Path.DistanceForNearChecking
        )
    }
    
    init(color: UIColor = .black, width: CGFloat = 3.0) {
        self.token = UUID().uuidString
        self.color = color
        self.width = width
    }
    
    func movePoint(to point: CGPoint) {
        bezierPath.move(to: point)
    }

    func line(to point: CGPoint) {
        bezierPath.addLine(to: point)
    }

    func translatedPath(with moveTo: CGPoint) -> Path {
        class Info {
            var points: [CGPoint] = []
        }
        var info = Info()
        bezierPath.cgPath.apply(info: &info) { (info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) -> Void in
            guard let infoPointer = UnsafeMutablePointer<Info>(OpaquePointer(info)) else { return }
            switch element.pointee.type {
            case .closeSubpath:
                break
            default:
                let point = element.pointee.points[0]
                infoPointer.pointee.points.append(point)
            }
        }

        let translated = Path()
        var first = true
        for point in info.points {
            let translatedPoint = CGPoint(
                x: point.x - moveTo.x,
                y: point.y - moveTo.y
            )
            if first {
                translated.movePoint(to: translatedPoint)
                first = false
            } else {
                translated.line(to: translatedPoint)
            }
        }
        return translated
    }
}

// MARK: - Drawable
extension Path: Drawable {

    func draw(_ rect: CGRect) {
        color.setStroke()
        bezierPath.lineWidth = width
        bezierPath.stroke()
    }
}

// MARK: - Movable
extension Path: Movable {

    // TODO: impl
    func lift(at point: CGPoint) {
    }

    // TODO: impl
    func move(to point: CGPoint) {
    }
    
    // TODO: impl
    func drop() {
    }
    
    func isNear(from targetPath: Path) -> Bool {
        return extendedBounds.intersects(targetPath.extendedBounds)
    }

    func isNear(from targetPoint: CGPoint) -> Bool {
        return extendedBounds.contains(targetPoint)
    }
}
