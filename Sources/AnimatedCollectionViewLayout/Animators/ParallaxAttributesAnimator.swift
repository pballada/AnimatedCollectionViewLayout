//
//  ParallexAnimator.swift
//  AnimatedCollectionViewLayout
//
//  Created by Jin Wang on 8/2/17.
//  Copyright © 2017 Uthoft. All rights reserved.
//

import UIKit

/// An animator that implemented the parallax effect by moving the content of the cell
/// slower than the cell itself.
public struct ParallaxAttributesAnimator: LayoutAttributesAnimator {
    /// The higher the speed is, the more obvious the parallax. 
    /// It's recommended to be in range [0, 1] where 0 means no parallax. 0.5 by default.
    public var speed: CGFloat
    public var minAlpha: CGFloat
    
    public init(speed: CGFloat = 0.4, minAlpha: CGFloat = 0) {
        self.speed = speed
        self.minAlpha = minAlpha
    }
    
    public func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset
        let direction = attributes.scrollDirection
        
        //guard let contentView = attributes.contentView else { return }

        if abs(position) >= 1 {
            attributes.transform = .identity
            attributes.alpha = 1.0
            attributes.zIndex = 0
        } else if direction == .horizontal {
            let width = collectionView.frame.width
            attributes.alpha = 1.0 - abs(position) + minAlpha
            attributes.zIndex = attributes.indexPath.row
            let transitionX = -(width * speed * position)
            attributes.transform = CGAffineTransform(translationX: transitionX, y: 0)
        } else {
            let height = collectionView.frame.height
            attributes.alpha = 1.0 - abs(position) + minAlpha
            attributes.zIndex = attributes.indexPath.row
            let transitionY = -(height * speed * position)
            attributes.transform = CGAffineTransform(translationX: 0, y: transitionY)

            // By default, the content view takes all space in the cell
            //attributes.transform = attributes.bounds.applying(transform)

            // We don't use transform here since there's an issue if layoutSubviews is called
            // for every cell due to layout changes in binding method.
            //contentView.frame = newFrame
        }
    }
}
