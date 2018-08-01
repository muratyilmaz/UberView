//  Created by Murat YILMAZ on 26.07.2018.
//  Copyright © 2018 Murat YILMAZ. All rights reserved.
import UIKit

final class AnimationHelper: NSObject, CAAnimationDelegate {
    
    public enum AnimationKey: String {
        case fadeAndScale = "fadeAndScale"
        case opacity = "opacity"
        case rotation = "transform.rotation"
        case scale = "transform.scale"
    }
    
    static public func rotateAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: AnimationKey.rotation.rawValue )
        animation.duration = CFTimeInterval(100.0)
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        return animation
    }
    
    static public func fadeAndScaleAnimation() -> CAAnimationGroup {
        let fadeIn = CABasicAnimation(keyPath: AnimationKey.opacity.rawValue )
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 0.3
        
        let scaleAnimation = CABasicAnimation(keyPath: AnimationKey.scale.rawValue )
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 1.0
        
        let fadeAndScale = CAAnimationGroup()
        fadeAndScale.animations = [fadeIn, scaleAnimation]
        fadeAndScale.duration = 2
        fadeAndScale.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        
        return fadeAndScale
    }
}

final class UberView: UIView {
    
    private let bgColor = UIColor.init(red: 0/255, green: 136/255, blue: 143/255, alpha: 1)
    private let rectSize = CGSize(width: 60.0, height: 60.0)
    private let gridLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = self.bgColor
        self.layer.masksToBounds = true
    }
    
    override func layoutSublayers(of layer: CALayer) {
        let rowsInstanceCount = Int(ceil(bounds.width * 2 / rectSize.width))
        let columsInstanceCount = Int(ceil(bounds.height * 2 / rectSize.height))
        let gridSize = (x: rowsInstanceCount, y: columsInstanceCount, size: rectSize)
        let w = CGFloat(rowsInstanceCount) * rectSize.width
        let h = CGFloat(columsInstanceCount) * rectSize.height
        
        gridLayer.bounds = bounds
        layer.addSublayer(gridLayer)
        gridLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let outerGrid = makeGrid(with: makeRoundedRect(size: rectSize), gridSize: gridSize)
        outerGrid.bounds =  CGRect(x: 0, y: 0, width: w, height: h)
        outerGrid.position = CGPoint(x: gridLayer.bounds.midX, y: gridLayer.bounds.midY)
        gridLayer.addSublayer(outerGrid)
        
        let innerGrid = makeGrid(with: makeRoundedRect(size: rectSize, borderWidth: 0.4), gridSize: gridSize )
        innerGrid.bounds = outerGrid.bounds
        innerGrid.position = CGPoint(x: outerGrid.position.x + rectSize.width * 0.5, y: outerGrid.position.y + rectSize.height * 0.5)
        gridLayer.addSublayer(innerGrid)
    }
    
    private func makeGrid(with shape: CAShapeLayer,
                          gridSize: (x: Int, y:Int, size: CGSize),
                          mask: Bool = false) -> CAReplicatorLayer {
        
        let rowsReplicatorLayer = CAReplicatorLayer()
        rowsReplicatorLayer.instanceCount = gridSize.x
        rowsReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(gridSize.size.width, 0, 0)
        rowsReplicatorLayer.addSublayer(shape)
        
        let columnsReplicatorLayer = CAReplicatorLayer()
        columnsReplicatorLayer.masksToBounds = mask
        columnsReplicatorLayer.instanceCount = gridSize.y
        columnsReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, gridSize.size.height, 0)
        columnsReplicatorLayer.addSublayer(rowsReplicatorLayer)
        
        return columnsReplicatorLayer
    }
    
    private func makeRoundedRect( size: CGSize, borderWidth: CGFloat = 0.6 ) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.frame.size = size
        shape.cornerRadius = 25
        shape.borderColor = UIColor.white.cgColor
        shape.borderWidth = borderWidth
        return shape
    }
    
    // MARK: PUBLIC
    public func startAnimation() {
        gridLayer.add(AnimationHelper.rotateAnimation(), forKey: nil)
        gridLayer.add(AnimationHelper.fadeAndScaleAnimation(), forKey: AnimationHelper.AnimationKey.fadeAndScale.rawValue)
        gridLayer.opacity = 0.3
    }
}


