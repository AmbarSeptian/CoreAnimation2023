import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let circleView = CircleView()
        circleView.frame.origin = .init(x: 100, y: 300)
        view.addSubview(circleView)
        circleView.runAnimation()
        
    }
}
