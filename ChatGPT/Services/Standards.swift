//
//  Standards.swift
//  ChatGPT
//
//  Created by nirvana on 3/5/23.
//
import Foundation
import UIKit

enum CustomError: Error {
    case netWorkLost
    case invalidURL
    case invalidResponse
    case reachLimitation
    case responseUnexpected(Int)
    case modelLoadError
    case defaultError
}

class ChatDefinedFrame: NSObject {
    
    static let screenSize: CGSize = UIScreen.main.bounds.size
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
//    if #available(iOS 13.0, *) {
//        static let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//    } else {
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//    }

    static let tabBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height>20 ? 83 : 49
    static let safeBottomHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height>20 ? 34 : 0
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    
//    static let tabBarHeight: CGFloat = UIApplication.shared.connectedScenes
//            .filter {$0.activationState == .foregroundActive }
//            .map {$0 as? UIWindowScene }
//            .compactMap { $0 }
//            .first?.windows
//            .filter({ $0.isKeyWindow }).first?
//            .windowScene?.statusBarManager?.statusBarFrame.height ?? 0 > 20 ? 83 : 49
//
//    static let safeBottomHeight: CGFloat = UIApplication.shared.connectedScenes
//            .filter {$0.activationState == .foregroundActive }
//            .map {$0 as? UIWindowScene }
//            .compactMap { $0 }
//            .first?.windows
//            .filter({ $0.isKeyWindow }).first?
//            .windowScene?.statusBarManager?.statusBarFrame.height ?? 0 > 20 ? 34 : 0
//
//    static let statusBarHeight: CGFloat = UIApplication.shared.connectedScenes
//            .filter {$0.activationState == .foregroundActive }
//            .map {$0 as? UIWindowScene }
//            .compactMap { $0 }
//            .first?.windows
//            .filter({ $0.isKeyWindow }).first?
//            .windowScene?.statusBarManager?.statusBarFrame.height ?? 0 > 29 ? 34 : 0
    
    static let navViewHeight: CGFloat = 44.0
    static let navBarHeight: CGFloat = (statusBarHeight + navViewHeight)
    
    static var isSmallScreen: Bool {
        // small screen:
        // iPhone 8 Plus 414 x 736
        // iPhone 8      375 x 667
        return ChatDefinedFrame.screenHeight <= 736
    }
}
