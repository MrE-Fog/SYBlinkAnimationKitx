//
//  SYLabel.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYLabelAnimation {
    case Border
    case BorderWithShadow
    case Background
    case Text
    case Ripple
}

public class SYLabel: UILabel {
    
    private let textLayer = CATextLayer()
    
    public var labelColor: UIColor = UIColor() {
        didSet {
            self.backgroundColor = UIColor.clearColor()
            self.syLayer.backgroundColor = labelColor
        }
    }
    
    public var animationBorderColor = UIColor() {
        didSet {
            self.syLayer.animationBorderColor = self.animationBorderColor
        }
    }
    
    public var animationBackgroundColor = UIColor() {
        didSet {
            self.syLayer.animationBackgroundColor = self.animationBackgroundColor
        }
    }
    
    public var animationTextColor = UIColor() {
        didSet {
            self.syLayer.animationTextColor = self.animationTextColor
        }
    }
    
    public var animationRippleColor = UIColor() {
        didSet {
            self.syLayer.animationRippleColor = self.animationRippleColor
        }
    }
    
    override public var frame: CGRect {
        didSet {
            self.syLayer.resizeSuperLayer()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            self.syLayer.resizeSuperLayer()
        }
    }
    
    override public var text: String? {
        didSet {
            !isFirstSetTextLayer ? self.firstSetTextLayer() : self.firstSetTextLayer()
        }
    }
    
    public var labelTextColor: UIColor? {
        didSet {
            self.textLayer.foregroundColor = labelTextColor?.CGColor
        }
    }
    
    public var isAnimating = false
    
    public var isFirstSetTextLayer = false
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            self.syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    public var animationDuration: CFTimeInterval = 1.0 {
        didSet {
            self.syLayer.setAnimationDuration(animationDuration)
        }
    }
    
    public func systemFontOfSize(fontSize: CGFloat) {
        self.font = UIFont.systemFontOfSize(fontSize)
        self.resetTextLayer()
    }
    
    public func fontNameWithSize(name: String, size: CGFloat) {
        self.font = UIFont(name: name, size: size)
        self.resetTextLayer()
    }
    
    public lazy var syLayer: SYLayer = SYLayer(superLayer: self.layer)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayer() {
        self.textColor = UIColor.clearColor()
        self.labelTextColor = UIColor.blackColor()//?  
        
    }
    
    private func firstSetTextLayer() {
        self.isFirstSetTextLayer = true
        self.setTextLayer()
        self.syLayer.firstSetTextLayer(textLayer)
    }
    
    private func resetTextLayer() {
        self.setTextLayer()
        self.syLayer.resetTextLayer(self.textLayer)
    }
    
    private func setTextLayer() {
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = self.font
        let size = self.text!.sizeWithAttributes(attributes)
        
        let x = (CGRectGetWidth(self.frame) - size.width) / 2
        let y = (CGRectGetHeight(self.frame) - size.height) / 2
        let height = size.height + self.layer.borderWidth
        let width = size.width
        let frame = CGRectMake(x, y, width, height)
        
        self.textLayer.font = self.font
        self.textLayer.string = self.text
        self.textLayer.fontSize = self.font.pointSize
        
        self.textLayer.foregroundColor = self.labelTextColor!.CGColor
        self.textLayer.contentsScale = UIScreen.mainScreen().scale
        
        self.textLayer.frame = frame
        self.textLayer.alignmentMode = kCAAlignmentCenter
    }
    
    public var syLabelAnimation: SYLabelAnimation = .Border {
        didSet {
            switch syLabelAnimation {
            case .Border:
                self.syLayer.syLayerAnimation = .Border
            case .BorderWithShadow:
                self.syLayer.syLayerAnimation = .BorderWithShadow
            case .Background:
                self.syLayer.syLayerAnimation = .Background
            case .Text:
                self.syLayer.syLayerAnimation = .Text
            case .Ripple:
                self.syLayer.syLayerAnimation = .Ripple
            }
        }
    }
    
    public func startAnimation() {
        self.isAnimating = true
        self.syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        self.isAnimating = false
        self.syLayer.stopAnimation()
    }
}