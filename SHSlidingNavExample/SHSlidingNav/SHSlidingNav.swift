//
//  SHSlidingNav.swift
//  SHSlidingNavExample
//
//  Created by subhajit halder on 29/05/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
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

class SHSlidingNav: UIViewController {
    
    private var isOpen: Bool = false
    private let viewBackground = UIView()
    private let leftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
    private let rightEdgePanGesture = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.leftEdgePanGesture.addTarget(self, action: #selector(self.handleLeftEdgePan(_:)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    @objc private func handleLeftEdgePan(_ leftPan: UIScreenEdgePanGestureRecognizer) {
        
    }
    
    @objc private func handleRightEdgePan(_ rightPan: UIScreenEdgePanGestureRecognizer) {
        
    }
    
    
    
    //MARK: Public Methods
    @objc func addTarget(_ viewController: UIViewController, direction: SHSlidingNavDirection) -> SHSlidingNav  {
        
        
        return self
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
