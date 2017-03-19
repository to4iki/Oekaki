import UIKit

// TODO: impl
final class IllustRepositoryOnMemory {

    private var underlying: [UIImage] = DummyImageFactory.shared.samplePack

    static let shared = IllustRepositoryOnMemory()
    private init() {}

    func load() -> [UIImage] {
        return underlying
    }

    func save(image: UIImage) {
        underlying.append(image)
    }
}

private struct DummyImageFactory {

    private let imageSize = CGSize(width: 300, height: 300)

    var samplePack: [UIImage] {
        return [
            line(color: .orange, width: 10),
            triangle(),
            square(color: .gray, width: 10),
            roundSquare(),
            oval()
        ]
    }
    
    static let shared = DummyImageFactory()
    private init() {}

    private func imageContextTransaction(f: (_ context: CGContext?) -> Void) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1.0)
        f(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func line(color: UIColor = .black, width: CGFloat = 3.0) -> UIImage {
        return imageContextTransaction { _ in
            let path = Path(color: color, width: width)
            path.movePoint(to: CGPoint(x: 50, y: 50))
            path.line(to: CGPoint(x: 250, y: 250))
            path.draw(CGRect.zero)
        }
    }

    func triangle(color: UIColor = .black, width: CGFloat = 3.0) -> UIImage {
        return imageContextTransaction { _ in
            let path = Path(color: color, width: width)
            path.movePoint(to: CGPoint(x: 160, y: 50))
            path.line(to: CGPoint(x: 220, y: 150))
            path.line(to: CGPoint(x: 90, y: 150))
            path.line(to: CGPoint(x: 160, y: 50))
            path.draw(CGRect.zero)
        }
    }

    func square(color: UIColor = .black, width: CGFloat = 3.0) -> UIImage {
        return imageContextTransaction { _ in
            let drawRect = CGRect(x: 100, y: 100, width: 100, height: 100)
            let drawPath = UIBezierPath(rect: drawRect)
            drawPath.lineWidth = width
            UIColor.cyan.setFill()
            color.setStroke()
            drawPath.fill()
            drawPath.stroke()
        }
    }

    func roundSquare(color: UIColor = .black, width: CGFloat = 3.0) -> UIImage {
        return imageContextTransaction { _ in
            let drawRect = CGRect(x: 100, y: 100, width: 100, height: 100)
            let drawPath = UIBezierPath(roundedRect: drawRect, cornerRadius: 0.3)
            drawPath.lineWidth = width
            UIColor.red.setFill()
            drawPath.fill()
        }
    }

    func oval(color: UIColor = .black, width: CGFloat = 3.0) -> UIImage {
        return imageContextTransaction { _ in
            let drawRect = CGRect(x: 100, y: 100, width: 100, height: 100)
            let drawPath = UIBezierPath(ovalIn: drawRect)
            drawPath.lineWidth = width
            UIColor.green.setFill()
            drawPath.fill()
        }
    }
}
