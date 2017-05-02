import UIKit

protocol Previewable {
    associatedtype PreviewContent
    func fetchPreviewableContent(location: CGPoint) -> PreviewContent?
    func fetchSourceRect(location: CGPoint) -> CGRect
    func previewingViewController(content: PreviewContent) -> UIViewController?
}
