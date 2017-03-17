import UIKit

typealias MovableToken = String

protocol Movable {
    var token: MovableToken { get }
    func lift(at point: CGPoint)
    func move(to point: CGPoint)
    func drop()
    func isNear(from targetPoint: CGPoint) -> Bool
    func isNear(from targetPath: Path) -> Bool
}
