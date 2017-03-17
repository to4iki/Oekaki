import UIKit
import RxCocoa
import RxSwift

final class CanvasView: UIView {

    fileprivate weak var handlePathView: HandlePathView?
    fileprivate let pathObserver = PathObserver()
    fileprivate let disposeBag = DisposeBag()

    fileprivate var movableObjects: [Movable] = []
    fileprivate var liftedObject: Movable?

    override func awakeFromNib() {
        super.awakeFromNib()
        addHandlePathView()
        bind()
    }

    func clear() {
        handlePathView?.clear()
        pathObserver.clear()
        movableObjects.removeAll()
        liftedObject = nil
        subviews.forEach { $0.removeFromSuperview() }
        redraw()
    }
}

extension CanvasView {

    fileprivate func addHandlePathView() {
        let view = HandlePathView()
        view.frame = bounds
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        handlePathView = view
    }

    fileprivate func bind() {
        handlePathView?.store.path.asDriver()
            .drive(onNext: { [weak self] (path: Path?) -> Void in
                guard let path = path else { return }
                self?.pathObserver.handlePath(path)
            })
            .addDisposableTo(disposeBag)

        handlePathView?.store.moveTo.asDriver()
            .drive(onNext: { [weak self] (point: CGPoint?) -> Void in
                self?.moveObjectIfNeeded(to: point)
            })
            .addDisposableTo(disposeBag)

        pathObserver.store.pathGroup.asDriver()
            .drive(onNext: { [weak self] (pathGroup: PathGroup?) -> Void in
                guard let pathGroup = pathGroup else { return }
                self?.handleMovableObject(pathGroup)
            })
            .addDisposableTo(disposeBag)
    }

    fileprivate func moveObjectIfNeeded(to point: CGPoint?) {
        guard let point = point else {
            liftedObject?.drop()
            liftedObject = nil
            return
        }

        if let object = liftedObject {
            object.move(to: point)
        } else {
            liftedObject = nearObject(from: point)
            liftedObject?.lift(at: point)
        }
    }

    private func nearObject(from point: CGPoint) -> Movable? {
        for object in movableObjects where object.isNear(from: point) {
            return object
        }
        return nil
    }

    fileprivate func handleMovableObject(_ object: Movable) {
        defer { redraw() }

        guard movableObjects.last?.token != object.token else { return }
        movableObjects.append(object)
        if let view = object as? UIView {
            view.frame = bounds
            if let handlePathView = handlePathView {
                insertSubview(view, belowSubview: handlePathView)
            }
        }
    }

    fileprivate func redraw() {
        subviews.forEach { $0.setNeedsDisplay() }
        setNeedsDisplay()
    }
}
