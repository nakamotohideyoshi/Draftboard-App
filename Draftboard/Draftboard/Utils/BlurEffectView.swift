import UIKit

public class BlurEffectView: UIVisualEffectView {
    
    public func mungeClassString(string: String) -> String {
        return "_" + string.stringByReplacingOccurrencesOfString("UI", withString: "UICustom")
    }
    
    public init?(radius: CGFloat) {
        super.init(effect: UIBlurEffect())
        
        let className = mungeClassString(String(effect!.dynamicType))
        let blurRadiusKeyPath = "blurRadius"
        let scaleKeyPath = "scale"
        
        guard !UIAccessibilityIsReduceTransparencyEnabled(),
            let effectClass = NSClassFromString(className) as? NSObject.Type,
            effect = effectClass.init() as? UIBlurEffect where
                effect.respondsToSelector(Selector(blurRadiusKeyPath)) &&
                effect.respondsToSelector(Selector(scaleKeyPath))
        else { return nil }
        
        effect.setValue(radius, forKeyPath: blurRadiusKeyPath)
        effect.setValue(1.0, forKeyPath: scaleKeyPath)
        
        self.effect = effect
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}