//
//  MainPresentAlertController.swift
//  ChatGPT
//
//  Created by nirvana on 3/13/23.
//

import UIKit

class CustomPresentationController: UIPresentationController {

    lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black
        return view

    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(x: 0, y: ChatDefinedFrame.screenHeight - 410 - ChatDefinedFrame.safeBottomHeight, width: ChatDefinedFrame.screenWidth, height: 410 + ChatDefinedFrame.safeBottomHeight)
    }

    override func presentationTransitionWillBegin() {
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0.5
        }
    }

    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0) {
            self.blackView.alpha = 0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
}
