import Foundation
import UIKit
import TransitionButton

protocol SlideButtonDelegate{
    func buttonStatus(status:String, sender:SlidingButton)
}

@IBDesignable class SlidingButton: TransitionButton{
    
    var dragPoint            = UIImageView(image: UIImage(named: "Dial"))
    var unlocked             = false
    var layoutSet            = false
    var promptLabel          = UILabel()
    var priceLabel           = UILabel()
    var slideDelegate: SlideButtonDelegate?
    
    override func layoutSubviews() {
        if !layoutSet{
            self.setUpButton()
            self.layoutSet = true
        }
    }
    
    func setUpButton(){
        
        self.promptLabel.frame = self.bounds
        self.promptLabel.textAlignment = .center
        self.promptLabel.textColor = UIColor.white
        self.promptLabel.text = "Swipe to buy"
        self.promptLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(promptLabel)
        
        self.priceLabel.frame = self.bounds
        self.priceLabel.center.x -= 21
        self.priceLabel.textAlignment = .right
        self.priceLabel.textColor = UIColor.white
        self.priceLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(priceLabel)
        
        self.dragPoint                    = UIImageView(frame: CGRect(x: 7, y: 7, width: 42, height: 42))
        self.dragPoint.image = UIImage(named: "Dial")
        self.dragPoint.isUserInteractionEnabled = true
        self.dragPoint.backgroundColor    = UIColor.white
        self.dragPoint.layer.cornerRadius = 21
        self.addSubview(self.dragPoint)
        self.bringSubview(toFront: self.dragPoint)
        self.layer.masksToBounds = true
        let panGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    
    @objc func panDetected(sender: UIPanGestureRecognizer){
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        sender.view?.frame.origin.x = 7 + translatedPoint.x
        self.promptLabel.alpha = (self.frame.size.width - translatedPoint.x)/self.frame.size.width
        self.priceLabel.alpha = (self.frame.size.width - translatedPoint.x)/self.frame.size.width
        if sender.state == .ended{
            let velocityX = sender.velocity(in: self).x * 0.2
            var finalX    = translatedPoint.x + velocityX
            if finalX < 0{
                finalX = 0
            }else if finalX + 56  > (self.frame.size.width){
                unlocked = true
                self.unlock()
            }
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
            }, completion: { (Status) in
                if Status{
                    self.animationFinished()
                }
            })
        }
    }
    
    func animationFinished(){
        if !unlocked{
            self.reset()
        }
    }
    
    func unlock(){
        self.slideDelegate?.buttonStatus(status: "Unlocked", sender: self)
    }
    
    func reset(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: 7, y: 7, width: 42, height: 42)
        }) { (Status) in
            if Status{
                self.dragPoint.isHidden               = false
                self.unlocked                       = false
                self.promptLabel.alpha                = 1
                self.priceLabel.alpha                 = 1
            }
        }
    }
}
