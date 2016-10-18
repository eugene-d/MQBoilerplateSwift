//
//  MQAspectFitLabel.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/29/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

private let CGSizeMax = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

open class MQAspectFitLabel: UILabel {
    
    fileprivate enum ScaleDirection {
        case grow, shrink, none
        
        func opposite() -> ScaleDirection {
            switch self {
            case .grow:
                return .shrink
                
            case .shrink:
                return .grow
                
            case .none:
                return .none
            }
        }
    }
    
    open func setFontSize(_ fontSize: CGFloat) {
        self.font = UIFont(name: self.font.fontName, size: fontSize)
    }
    
    /**
    Finds the font size to apply to the entire string so that the text's intrinsic size
    can be scaled up or down to fit inside the label's dimensions.
    
    **Important** This function only works for labels where all the string characters
    are the same font size. This will not work properly on attributed strings that have
    different font sizes in certain parts of the string.
    */
    open func adjustFontSizeToScaleAspectFit() {
        if let _: NSString = self.text as NSString? {
            // Find the min and max font sizes before doing a binary search.
            var currentSize = self.self.font.pointSize > 0 ? self.self.font.pointSize : UIFont.systemFontSize
            var min = CGFloat(0)
            var max = CGFloat(0)
            
            let startingDirection = self.scaleDirectionForFontSize(currentSize)
            var currentDirection = startingDirection
            
            loop: while true {
                switch currentDirection {
                case .none:
                    // The correct font size was suddenly found, so set it already
                    // and leave the function.
                    self.setFontSize(currentSize)
                    return
                    
                default:
                    if currentDirection == startingDirection.opposite() {
                        if startingDirection == .grow {
                            max = currentSize
                            min = max / 2
                        } else if startingDirection == .shrink {
                            min = currentSize
                            max = min * 2
                        }
                        break loop
                    } else if currentDirection == .grow {
                        currentSize *= 2
                    } else if currentDirection == .shrink {
                        currentSize /= 2
                    }
                }
                
                currentDirection = self.scaleDirectionForFontSize(currentSize)
            }
            
            
            var mid: CGFloat
            
            loop: while true {
                mid = min + ((max - min) / 2)
                
                switch self.scaleDirectionForFontSize(mid) {
                case .grow:
                    min = mid
                    
                case .shrink:
                    max = mid
                    
                case .none:
                    self.setFontSize(mid)
                    return
                }
            }
        }
    }
    
    fileprivate func scaleDirectionForFontSize(_ fontSize: CGFloat) -> ScaleDirection {
        if let text = self.text {            
            let textSize = text.boundingRect(with: CGSizeMax,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [NSFontAttributeName : UIFont(name: self.font.fontName, size: fontSize)!],
                context: nil).size
            
//            let textSize = (text as NSString).sizeWithAttributes(
//                [NSFontAttributeName : UIFont(name: self.font.fontName, size: fontSize)!])
            
            let labelWidth = floor(self.bounds.size.width)
            let labelHeight = floor(self.bounds.size.height)
            let textWidth = ceil(textSize.width)
            let textHeight = ceil(textSize.height)
            
            if labelWidth > textWidth && labelHeight > textHeight {
                return .grow
            } else if labelWidth < textWidth || labelHeight < textHeight {
                return .shrink
            }
        }
        
        return .none
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.adjustFontSizeToScaleAspectFit()
    }
    
}
