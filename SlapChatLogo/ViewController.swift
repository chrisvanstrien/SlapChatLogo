import UIKit
import CoreMotion

class ViewController: UIViewController {

    let RESISTANCE = 10.0
    let FREQUENCY = 2.5
    let DAMPING = 0.25
    let ACCELERATION_FACTOR = 7.0
    
    var animator: UIDynamicAnimator!
    var motion: CMMotionManager!
    var updater: CADisplayLink!
    
    var renderView: RenderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 237/255, green: 108/255, blue: 48/255, alpha: 1)
        
        let centerX = view.center.x
        let center = CGPoint(x: centerX, y: centerX)
        
        renderView = RenderView()
        renderView.bounds = CGRect(origin: CGPointZero, size: CGSize(width: 160, height: 160))
        renderView.bubble = UIImage(named: "SpeechBubble")
        renderView.shadow = UIImage(named: "Shadow")
        renderView.opaque = false
        renderView.center = center
        
        let monkey = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 110, height: 110)))
        monkey.image = UIImage(named: "Octomonkey")
        monkey.center = center
        
        renderView.wiggle = monkey
        
        view.addSubview(renderView)
        view.addSubview(monkey)
    
        let spring = UIAttachmentBehavior(item: monkey, attachedToItem: renderView)
        spring.frequency = CGFloat(FREQUENCY)
        spring.damping = CGFloat(DAMPING)
        
        let friction = UIDynamicItemBehavior(items: [monkey])
        friction.resistance = CGFloat(RESISTANCE)
        friction.allowsRotation = false
        
        let anchored = UIDynamicItemBehavior(items: [renderView])
        anchored.anchored = true
        anchored.allowsRotation = false // needed?
        
        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(spring)
        animator.addBehavior(friction)
        animator.addBehavior(anchored)
        
        // Dont add a new one every time
        let handler = {
            (deviceMotion: CMDeviceMotion?, error: NSError?) in
            
            // Use continuous, but update force?
            let force = UIPushBehavior(items: [monkey], mode: .Instantaneous)
            
            let x = deviceMotion!.userAcceleration.x
            let xVelocity = x * self.ACCELERATION_FACTOR
            
            let y = deviceMotion!.userAcceleration.y
            let yVelocity = y * self.ACCELERATION_FACTOR
            
            force.pushDirection = CGVector(
                dx: xVelocity,
                dy: yVelocity)
            
            self.animator.addBehavior(force)
        }
        
        motion = CMMotionManager()
        motion.deviceMotionUpdateInterval = 0.1
        motion.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: handler)
   
        updater = CADisplayLink(target: self, selector: Selector("refresh"))
        updater.frameInterval = 1
        updater.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func refresh() {
        renderView.setNeedsDisplay()
    }
}

