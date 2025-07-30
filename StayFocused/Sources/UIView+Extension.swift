//
//  Untitled.swift
//  StayFocused
//
//  Created by Макс Макеев on 28.07.2025.
//

import UIKit

// MARK: - Constraints

extension UIView {
    
    func addConstraints(
        centerX: NSLayoutXAxisAnchor? = nil,
        centerXPaddiing: CGFloat = 0,
        centerY: NSLayoutYAxisAnchor? = nil,
        centerYPadding: CGFloat = 0,
        top: NSLayoutYAxisAnchor? = nil,
        topPadding: CGFloat = 0,
        left: NSLayoutXAxisAnchor? = nil,
        leftPadding: CGFloat = 0,
        right: NSLayoutXAxisAnchor? = nil,
        rightPadding: CGFloat = 0,
        bottom: NSLayoutYAxisAnchor? = nil,
        bottomPadding: CGFloat = 0,
        width: CGFloat = 0,
        height: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: centerXPaddiing).isActive = true
        }
        
        if let centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: centerYPadding).isActive = true
        }
        
        if let top {
            topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let left {
            leadingAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        
        if let right {
            trailingAnchor.constraint(equalTo: right, constant: rightPadding).isActive = true
        }
        
        if let bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

// MARK: - Constants

extension ViewController {
    
    enum Texts {
        static let workText = "Let's Work"
        static let breakText = "Relax a bit"
        static let pauseText = "Pause"
        static let startText = "Press Play Button to Start work"
    }
    
    enum Images {
        static let playImage = UIImage(systemName: "play.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 36, weight: .regular))
        static let pauseImage = UIImage(systemName: "pause.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 36, weight: .regular))
        static let backgroundImage = UIImage(named: "background")
    }
}
