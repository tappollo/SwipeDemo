//
//  ViewController.swift
//  SwipeToConfirm
//
//  Created by Ruoyu Fu on 30/03/2018.
//  Copyright © 2018 Ruoyu Fu. All rights reserved.
//

import UIKit
import TransitionButton

class ViewController: UIViewController, SlideButtonDelegate {
    let button = { () -> SlidingButton in
        // demo here plz use autolayout
        let btn = SlidingButton(frame: CGRect(x: 16, y: 600, width: 343, height: 56))
        btn.layer.cornerRadius = 28
        btn.backgroundColor = UIColor(red: 126.0/255, green: 132.0/255, blue: 250.0/255, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.slideDelegate = self
        self.view.addSubview(button)
        button.priceLabel.text = "$46.8"
    }
    
    func buttonStatus(status: String, sender: SlidingButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.button.backgroundColor = UIColor.white
            self.button.stopAnimation(animationStyle: .expand, completion: {
                let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
                let secondVC = sb.instantiateViewController(withIdentifier: "Second")
                self.present(secondVC, animated: true, completion: nil)
            })
        }
    }
    

}

class SecondViewController: CustomTransitionViewController{
    
}
