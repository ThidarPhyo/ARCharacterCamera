//
//  LaunchScreenManager.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/10/30.
//

import Foundation
import UIKit

class LaunchScreenManager {
    static let instance = LaunchScreenManager()

    var view: UIView?
    var parentView: UIView?

    init() {}

    func loadView() -> UIView {
        let launchScreen = UINib(nibName: "LaunchScreen", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        return launchScreen
    }
    func fillParentViewWithView() {
        guard let view = view, let parentView = parentView else { return }
        parentView.addSubview(view)
        view.frame = parentView.bounds
        view.center = parentView.center
    }
    
    // MARK: - Animation

    func animateAfterLaunch(_ parentViewPassedIn: UIView) {
        parentView = parentViewPassedIn
        view = loadView()
        fillParentViewWithView()
        // start animation
        startAnimation()
    }

    func startAnimation() {
        guard let logo1 = view?.viewWithTag(1),
            let logo2 = view?.viewWithTag(2),
            let label = view?.viewWithTag(3) else { return }

        let screen = UIScreen.main.bounds.size

        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                logo1.transform = CGAffineTransform.identity.translatedBy(x: screen.width / 2 + logo1.frame.size.width / 2, y: 0)
                logo2.transform = CGAffineTransform.identity.translatedBy(x: -(screen.width / 2 + logo2.frame.size.width / 2), y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.1) {
                label.center.x = screen.width / 2
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.view?.alpha = 0
            }
        }) { (_) in
            self.view?.removeFromSuperview()
        }
    }
}
