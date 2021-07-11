//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


extension UIBezierPath {

    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength

        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        var points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]

        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        var transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)

        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        //CGPathAddLines(path, &transform, &points, points.count)
        path.closeSubpath()

        return self.init(cgPath: path)
    }

}

// Example call:


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        
        let arrow = UIBezierPath.arrow(from: CGPoint(x: 50, y: 100), to: CGPoint(x: 200, y: 50),
            tailWidth: 10, headWidth: 25, headLength: 40)
        let layer = CALayer()
        
        
        let shapeLayer = CAShapeLayer()
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        shapeLayer.path = arrow.cgPath

        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.position = CGPoint(x: 10, y: 10)

        // add the new layer to our custom view
        self.view.layer.addSublayer(shapeLayer)
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
