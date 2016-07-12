//
//  DLTransition.swift
//  DLTransition
//
//  Created by xiangkai yin on 16/7/11.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

import UIKit

enum DLTransitionGestureRecognizerType:Int {
    case DLTransitionGestureRecognizerTypePan,
    DLTransitionGestureRecognizerEdgePan
}

struct Static {
    static var dispacthOnceToken:dispatch_once_t = 0
}

var __DLTransitionGestureRecognizerType:DLTransitionGestureRecognizerType = .DLTransitionGestureRecognizerTypePan

class DLTransition: NSObject {
    
    class func validatePanBackWithDLTransitionGestureRecognizerType(type:DLTransitionGestureRecognizerType) {
        dispatch_once(&Static.dispacthOnceToken) {
            __DLTransitionGestureRecognizerType = type
            DLTransition.___DLTransition_Swizzle(UINavigationController.classForCoder(), origSEL: #selector(UINavigationController.viewDidLoad), newSEL: #selector(UINavigationController.__DLTransition_Hook_ViewDidLoad))
        }
    }
    
    static func ___DLTransition_Swizzle(c:AnyClass,origSEL:Selector,newSEL:Selector) {
        var origMethod = class_getInstanceMethod(c,origSEL)
        let newMethod:Method
        
        if origMethod == nil {
            origMethod = class_getClassMethod(c, origSEL)
            newMethod = class_getClassMethod(c, newSEL)
        } else {
            newMethod = class_getInstanceMethod(c, newSEL)
        }
        
        if origMethod == nil || newMethod == nil {
            return
        }
        if class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
        } else {
            method_exchangeImplementations(origMethod, newMethod)
        }
    }
}

var k__DLTransition_GestureRecognizer = "__DLTransition_GestureRecognizer";

extension UINavigationController:UIGestureRecognizerDelegate {
    
    var __DLTransition_PanGestureRecognizer:UIPanGestureRecognizer {
        get {
            return objc_getAssociatedObject(self, &k__DLTransition_GestureRecognizer) as! UIPanGestureRecognizer
        }
        set(newValue) {
            self.willChangeValueForKey(k__DLTransition_GestureRecognizer)
            objc_setAssociatedObject(self, &k__DLTransition_GestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey(k__DLTransition_GestureRecognizer)
        }
    }
    
    
    //MARK: Hook
    func __DLTransition_Hook_ViewDidLoad() {
        self.__DLTransition_Hook_ViewDidLoad()
        
        if self.interactivePopGestureRecognizer?.delegate?.isKindOfClass(UIPercentDrivenInteractiveTransition.classForCoder()) == true {
            var gestureRecognizer:UIPanGestureRecognizer!
            let  kHandleNavigationTransitionKey:NSString = "nTShMTkyGzS2nJquqTyioyElLJ5mnKEco246".__dlDecryptString()
            
            if __DLTransitionGestureRecognizerType == DLTransitionGestureRecognizerType.DLTransitionGestureRecognizerEdgePan {
                gestureRecognizer = UIScreenEdgePanGestureRecognizer.init(target: self.interactivePopGestureRecognizer?.delegate, action:NSSelectorFromString(kHandleNavigationTransitionKey as String))
                let edgeRecognizer = gestureRecognizer as! UIScreenEdgePanGestureRecognizer
                edgeRecognizer.edges = UIRectEdge.Left
            } else {
                gestureRecognizer = UIPanGestureRecognizer.init(target: self.interactivePopGestureRecognizer?.delegate, action: NSSelectorFromString(kHandleNavigationTransitionKey as String))
            }
            
            gestureRecognizer.delegate = self
            gestureRecognizer.__DLTransition_NavController = self
            self.__DLTransition_PanGestureRecognizer = gestureRecognizer
            self.interactivePopGestureRecognizer?.enabled = false
        }
        self.view.addGestureRecognizer(self.__DLTransition_PanGestureRecognizer)
    }
    
    //MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let navVC:UINavigationController = self
        if navVC.transitionCoordinator()?.isAnimated() == true ||
            navVC.viewControllers.count < 2 {
                return false
        }
        let view:UIView = gestureRecognizer.view!
        if view.disableDLTransition == false {
            return false
        }
        let loc:CGPoint = gestureRecognizer.locationInView(view)
        let subView = view.hitTest(loc, withEvent: nil)
        var superView = subView
        while superView != view {
            if superView?.disableDLTransition == true {
                return false
            }
            superView = superView?.superview
        }
        if __DLTransitionGestureRecognizerType == DLTransitionGestureRecognizerType.DLTransitionGestureRecognizerTypePan {
            let panRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = panRecognizer.velocityInView(navVC.view)
            if velocity.x <= 0 {
                return false
            }
            var translation = panRecognizer.translationInView(navVC.view)
            translation.x = translation.x == 0 ? 0.0:translation.x
            let ratio = fabs(translation.y)/fabs(translation.x)
            if translation.y>0 && ratio>0.618 ||
                translation.y < 0 && ratio>0.2{
                return false
            }
            
        }
        return true
    }
    
    func enabledMLTransition(enable:Bool) {
        self.__DLTransition_PanGestureRecognizer.enabled = enable
    }
}

var k_DLTransition_NavController_OfPan = "__k_DLTransition_NavController_OfPan";

extension UIGestureRecognizer {
    var __DLTransition_NavController:UINavigationController {
        get {
            return objc_getAssociatedObject(self, &k_DLTransition_NavController_OfPan) as! UINavigationController
        }
        set (newValue) {
            self.willChangeValueForKey(k_DLTransition_NavController_OfPan)
            objc_setAssociatedObject(self, &k_DLTransition_NavController_OfPan, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValueForKey(k_DLTransition_NavController_OfPan)
        }
    }
    
}

var k_DLTransition_UIView_DisableMLTransition = "__DLTransition_UIView_DisableMLTransition";
extension UIView {
    var disableDLTransition:Bool? {
        get {
            return objc_getAssociatedObject(self, &k_DLTransition_UIView_DisableMLTransition) as? Bool
        }
        set (newValue) {
            self.willChangeValueForKey(k_DLTransition_UIView_DisableMLTransition)
            objc_setAssociatedObject(self, &k_DLTransition_UIView_DisableMLTransition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey(k_DLTransition_UIView_DisableMLTransition)
        }
    }
    
}

extension UIScrollView {
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer .isEqual(self.panGestureRecognizer) {
            if otherGestureRecognizer .isMemberOfClass(UIPanGestureRecognizer.classForCoder()) {
                var location = otherGestureRecognizer.locationInView(otherGestureRecognizer.view)
                if location.x <= 10.0 {
                    return true
                }
                func isHorizontalBlock(scrollView:UIScrollView)->(Bool) {
                    if CGAffineTransformEqualToTransform(CGAffineTransformMakeRotation(-CGFloat(M_PI*0.5)), scrollView.transform) ||
                        CGAffineTransformEqualToTransform(CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5)), scrollView.transform){
                        return true
                    } else {
                        if scrollView.contentSize.width > scrollView.frame.size.width {
                            return true
                        }
                    }
                    return false
                }
                var superView = self;
                
                while !superView .isEqual(otherGestureRecognizer.__DLTransition_NavController.view) {
                    if superView.isKindOfClass(UIScrollView.classForCoder()) {
                        if isHorizontalBlock(superView) {
                            return false
                        }
                        superView = superView.superview as! UIScrollView
                    }
                }
                return true
            }
        }
        return false
    }
}

extension NSString {
    
    func __dlEncryptString() -> NSString{
        let data:NSData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64 = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return base64
    }
    
    func __dlDecryptString() -> NSString {
        let rot13 = self.__dlRot13()
        let data = NSData.init(base64EncodedString: rot13 as String, options: .IgnoreUnknownCharacters)
        return NSString.init(data: data!, encoding: NSUTF8StringEncoding)!
    }
    
    func __dlRot13() -> NSString {
        
        let dest = NSMutableString.init(capacity: self.length)
        
        for c in 0  ..< self.length  {
            var asciiCode = self.characterAtIndex(c)
            let A = "A" as NSString
            let Z = "Z" as NSString
            let a = "a" as NSString
            let z = "z" as NSString
            if asciiCode > A.characterAtIndex(0) && asciiCode <= Z.characterAtIndex(0) {
                asciiCode = (asciiCode - A.characterAtIndex(0) + 13) % 26 + A.characterAtIndex(0)
            } else if asciiCode > a.characterAtIndex(0) && asciiCode <= z.characterAtIndex(0) {
                asciiCode = (asciiCode - a.characterAtIndex(0) + 13) % 26 + a.characterAtIndex(0)
            }
            
            dest.appendString("\(Character(UnicodeScalar(asciiCode)))")
        }
        
        dest.appendString("\0")
        
        return dest
    }
    
    func ASCII(n:Int) -> String? {
        guard (n > 0 && n < 255) else {
            return nil
        }
        return String(format: "%c",n)
    }
    
    func ASCII(c:String) -> Int8? {
        let str:NSString = c
        let n = str.UTF8String[0]
        guard n>=0 else {
            return nil
        }
        return n
    }
}