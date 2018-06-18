//
//  SHSlidingNav.swift
//  SHSlidingNavExample
//
//  Created by subhajit halder on 29/05/17.
//

import UIKit

@objc enum SHSlidingNavDirection: Int {
    case leftToRight
    case righToLeft
}

@objc enum SHSlidingNavHeightSubstraction: Int {
    case fromTop
    case fromBottom
}

@objc enum PresentationType : Int {
    case overCurrentVC
    case underCurrentVC
}

enum SHSlidingNavConstants {
    //------------------------------------- gestures movement
    static let translationParent = 0.0
    static let maxVelocity = 1000.0
    //------------------------------------- BackGround View Alpha values
    static let alphaIncrement = 0.002
    static let maxAlpha = 0.45
    //------------------------------------- Animation Durations Self Explaining Charecteristics
    static let maxDuration = 0.5
    static let minDuration = 0.1
    static let equalDuration = 0.35
    
    //------------------------------------- Shadow controls of NAV Drawer
    static let shadowWidth = -6.0
    static let shadowHeight = 12.0
    static let shadowRadius = 6.0
    static let shadowMaxOpacity = 0.8
    static let shadowMinOpacity = 0.0
   
    static let yOrigin = CGFloat(0.0)
}

typealias SHSlidingNavCompletion = (IndexPath?) -> Void

class SHSlidingNav: UIViewController {
    
    internal var isOpen: Bool = false
    internal var viewDarkBackground = UIView()
    internal var currentVelocity = CGFloat(0.0)
    internal var leftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
    internal let rightEdgePanGesture = UIScreenEdgePanGestureRecognizer()
    internal var panGesture = UIPanGestureRecognizer()
    internal var tapGesture = UITapGestureRecognizer()
    internal var completion: SHSlidingNavCompletion!
    
    var width = CGFloat(0.0)
    var height = CGFloat(0.0)
    var parentVC: UIViewController = UIViewController()

}

extension SHSlidingNav {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftEdgePanGesture.addTarget(self, action: #selector(self.handleLeftEdgePan(_:)))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: internal Methods
    @objc internal func handleLeftEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation: CGPoint = gesture.translation(in: gesture.view)
        let width: CGFloat = view.frame.size.width
        let percent: CGFloat = max(translation.x, 0) / width
        switch gesture.state {
        case .began:
            if isOpen {
                return
            }
            view.isHidden = false
            view.layer.shadowOpacity = Float(SHSlidingNavConstants.shadowMaxOpacity)
        case .changed:
            if isOpen {
                return
            }
            //NSLog(@"kelo : %f", translation.x);
            if view.frame.origin.x < 0 {
                //                _parentVC.view.frame = CGRectMake(translation.x / TRANSLATION_PARENT,  0 , _parentVC.view.frame.size.width, _parentVC.view.frame.size.height);
                view.frame = CGRect(x: -view.frame.size.width + translation.x, y: SHSlidingNavConstants.yOrigin, width: view.frame.size.width, height: view.frame.size.height)
                viewDarkBackground.alpha = 0 + (CGFloat(SHSlidingNavConstants.alphaIncrement) * translation.x)
            }
            view.isUserInteractionEnabled = false
            parentVC.view.isUserInteractionEnabled = false
        case .ended:
            if isOpen {
                return
            }
            animateParentToCenter()
            currentVelocity = fabs(gesture.velocity(in: view).x)
            if percent > 0.5 || fabs(gesture.velocity(in: view).x) > CGFloat(SHSlidingNavConstants.maxVelocity) {
                slideIn()
            }
            else {
                slideOut()
            }
            view.isUserInteractionEnabled = true
            parentVC.view.isUserInteractionEnabled = true
        default:
            break
        }

    }
    
    @objc internal func handleRightEdgePan(_ rightPan: UIScreenEdgePanGestureRecognizer) {
        
    }
    
    @objc internal func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation: CGPoint = gesture.translation(in: gesture.view)
        let width: CGFloat = view.frame.size.width
        var percent: CGFloat = 0.0
        if translation.x < 0 {
            percent = max(fabs(translation.x), 0) / width
        }
        switch gesture.state {
        case .began:
            if !isOpen {
                return
            }
        case .changed:
            if !(isOpen || translation.x > 0) {
                return
            }
            //NSLog(@"kelo : %f", translation.x);
            //            if (translation.x <= self.width ) {
            //                _parentVC.view.frame = CGRectMake(translation.x / TRANSLATION_PARENT,  0 , _parentVC.view.frame.size.width, _parentVC.view.frame.size.height);
            view.frame = CGRect(x: 0 + translation.x, y: SHSlidingNavConstants.yOrigin, width: view.frame.size.width, height: view.frame.size.height)
            viewDarkBackground.alpha = CGFloat(SHSlidingNavConstants.maxAlpha) + (CGFloat(SHSlidingNavConstants.alphaIncrement) * translation.x)
            //            }
            view.isUserInteractionEnabled = false
            parentVC.view.isUserInteractionEnabled = false
        case .ended:
            if !isOpen {
                return
            }
            animateParentToCenter()
            currentVelocity = fabs(gesture.velocity(in: view).x)
            // NSLog(@"percent: %f  velocity: %f",percent, [gesture velocityInView:self.view].x);
            if percent > 0.5 || gesture.velocity(in: view).x < -CGFloat(SHSlidingNavConstants.maxVelocity) {
                slideOut()
            }
            else {
                slideIn()
                //                self.view.layer.shadowOpacity = 0.0f;
            }
            view.isUserInteractionEnabled = true
            parentVC.view.isUserInteractionEnabled = true
        default:
            break
        }

    }
    
    @objc internal func handleTapGesture(_ tap: UITapGestureRecognizer) {
        if isOpen {
            self.slideOut()
        }
    }
    
    func animateParentToCenter() {
        UIView.animate(withDuration: TimeInterval(SHSlidingNavConstants.equalDuration), delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.parentVC.view.frame = CGRect(x: 0, y: self.parentVC.view.frame.origin.y, width: self.parentVC.view.frame.size.width, height: self.parentVC.view.frame.size.height)
            // backGroundDarkView.alpha = 0.f;
        }, completion: {(_ finished: Bool) -> Void in
        })

    }
    
    func slideIn() {
        view.isHidden = false
        var animationDuration: CGFloat = currentVelocity != 0.0 ? (0.5 / currentVelocity) * 100 : CGFloat(SHSlidingNavConstants.equalDuration)
        if animationDuration > CGFloat(SHSlidingNavConstants.maxDuration) {
            animationDuration = CGFloat(SHSlidingNavConstants.maxDuration)
        }
        else if animationDuration < CGFloat(SHSlidingNavConstants.minDuration) {
            animationDuration = CGFloat(SHSlidingNavConstants.minDuration)
        }
        
        UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: [], animations: {() -> Void in
            self.view.frame = CGRect(x: 0, y: CGFloat(SHSlidingNavConstants.yOrigin), width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.viewDarkBackground.alpha = CGFloat(SHSlidingNavConstants.maxAlpha)
        }, completion: {(_ finished: Bool) -> Void in
            self.isOpen = true
            self.currentVelocity = 0.0
        })
    }
    
    func slideOut() {
        var animationDuration: CGFloat = currentVelocity != 0.0 ? (0.5 / currentVelocity) * 100 : CGFloat(SHSlidingNavConstants.equalDuration)
        if animationDuration > CGFloat(SHSlidingNavConstants.maxDuration) {
            animationDuration = CGFloat(SHSlidingNavConstants.maxDuration)
        }
        else if animationDuration < CGFloat(SHSlidingNavConstants.minDuration) {
            animationDuration = CGFloat(SHSlidingNavConstants.minDuration)
        }
        
        UIView.animate(withDuration: TimeInterval(animationDuration) , delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.view.frame = CGRect(x: -self.view.frame.size.width, y: CGFloat(SHSlidingNavConstants.yOrigin), width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.viewDarkBackground.alpha = 0.0
        }, completion: {(_ finished: Bool) -> Void in
            self.isOpen = false
            self.completion(nil)
            self.view.layer.shadowOpacity = Float(SHSlidingNavConstants.shadowMinOpacity)
            self.currentVelocity = 0.0
            self.view.isHidden = true
        })

    }
    
    //MARK: Public Methods
    @objc func addTarget(_ parent: UIViewController, direction: SHSlidingNavDirection = SHSlidingNavDirection.leftToRight, handler: @escaping SHSlidingNavCompletion)  {
        
        self.completion = handler
        self.parentVC = parent
        self.viewDarkBackground = UIView(frame: CGRect(x: 0, y: SHSlidingNavConstants.yOrigin, width: self.parentVC.view.frame.size.width, height: self.parentVC.view.frame.size.height - SHSlidingNavConstants.yOrigin))
        self.viewDarkBackground.backgroundColor = UIColor.black
        self.viewDarkBackground.alpha = 0.0
        self.parentVC.view.addSubview(self.viewDarkBackground)
        self.setFrame()
        self.setGesturesOnParent()
        self.view.isHidden = true

        
    }
    
    func setFrame() {
        self.width = (parentVC.view.frame.size.width * (75.0/100.0))
        self.height = parentVC.view.frame.size.height
        //- (_parentVC.view.frame.size.height * HEIGHT_PERCENT);
        view.frame = CGRect(x: -width, y: SHSlidingNavConstants.yOrigin, width: width, height: height)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = Float(SHSlidingNavConstants.shadowMinOpacity)
        view.layer.shadowOffset = CGSize(width: SHSlidingNavConstants.shadowWidth, height: SHSlidingNavConstants.shadowHeight)
        view.layer.shadowRadius = CGFloat(SHSlidingNavConstants.shadowRadius)
        parentVC.view.addSubview(view)
        parentVC.view.bringSubview(toFront: view)
        view.layoutIfNeeded()
    }
    
    func setGesturesOnParent() {
        leftEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleLeftEdgePan(_ :)))
        leftEdgePanGesture.edges = .left
        leftEdgePanGesture.delegate = self
        parentVC.view.addGestureRecognizer(leftEdgePanGesture)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGesture.delegate = self
        viewDarkBackground.addGestureRecognizer(panGesture)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewDarkBackground.addGestureRecognizer(tapGesture)
    }
    
    func toggleSlide() {
        if !isOpen {
            
            slideIn()
        }
        else {
            
            slideOut()
        }
    }

    
    @objc func setFrame(_ left: CGFloat,_ right: CGFloat,_ top: CGFloat,_ bottom: CGFloat) {
        
    }
    
    @objc func setWidthInRelationToScreen(percent: Float) {
        
    }
    
    @objc func setWidthFixed( width: Float) {
        
    }
    
    @objc func setHeighInRelationToScreen(percent: Float) {
        
    }
    
    @objc func setHeightFixed( height: Float) {
        
    }
    
}

extension SHSlidingNav: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == self.leftEdgePanGesture {
            return true
        }
        else if gestureRecognizer == panGesture && touch.view == viewDarkBackground {
            return true
        }
        else if gestureRecognizer == tapGesture && touch.view == viewDarkBackground {
            return true
        }
        
        return false

    }
}
