import UIKit

class RenderView: UIView {
    
    var bubble: UIImage!
    var shadow: UIImage!
    
    var wiggle: UIView! // can this be CGPointRef
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        bubble.drawInRect(bounds)
        
        let rect = CGRect(
            origin: CGPoint(
                x: CGRectGetMinX(wiggle.frame) - CGRectGetMidX(bounds),
                y: CGRectGetMinY(wiggle.frame) - CGRectGetMidY(bounds)),
            size: CGSize(
                width: 159.0/80.0 * CGRectGetWidth(wiggle.frame),
                height: 143.0/76.0 * CGRectGetHeight(wiggle.frame)))
        
        shadow.drawInRect(rect, blendMode: .SourceAtop, alpha: 1)
    }
}
