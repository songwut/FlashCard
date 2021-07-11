//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    override func loadView() {
        
        print(self.deg2rad(45))
        print(self.deg2rad(-33.690065508446814))
        print(self.deg2rad(-180))
        
        
        let view = UIView()
        view.backgroundColor = .white

        let label = UIView()
        label.transform = CGAffineTransform(rotationAngle: CGFloat(self.deg2rad(180)))
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.backgroundColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


