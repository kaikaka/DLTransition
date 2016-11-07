//
//  TempViewController.swift
//  DLTransition
//
//  Created by xiangkai yin on 16/7/11.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    
    var button:UIButton!
    
    var audoChangeNavBarHidden:Bool!
    
    var _imageView:UIImageView!
    var imageView:UIImageView {
        get {
            if _imageView == nil {
                _imageView = UIImageView.init()
                if (self.navigationController?.viewControllers.index(of: self))!%2 == 0 {
                    _imageView.image = UIImage.init(named: "IMG_2079")
                } else {
                    _imageView.image = UIImage.init(named:"IMG_2078.jpg")
                }
                _imageView.contentMode = .scaleAspectFit
                _imageView.isUserInteractionEnabled = true
            }
            return _imageView
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        let rightBar = UIBarButtonItem.init(title: "cessss", style: .plain, target: self, action: nil)
        rightBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = rightBar
        
        let lastIndex = (self.navigationController?.viewControllers.index(of: self))!-1
        var lastColor:UIColor = UIColor.init()
        if lastIndex < (self.navigationController?.viewControllers.count)! {
            let viewController = self.navigationController?.viewControllers[lastIndex]
            lastColor = (viewController?.view.backgroundColor)!
        }
        let colors = [UIColor.white,UIColor.lightGray]
        
        var bkgColor = colors[Int(arc4random())%colors.count]
        while bkgColor.isEqual(lastColor) {
            bkgColor = colors[Int(arc4random())%colors.count]
        }
        self.view.backgroundColor = bkgColor
        self.imageView.frame = self.view.frame
        
        self.view.addSubview(self.imageView)
        
        let gesture = UITapGestureRecognizer.init(target: self, action:#selector(pressed(sender:)))
        self.imageView.addGestureRecognizer(gesture)
        let c = (self.navigationController?.viewControllers.index(of: self))!%2
        if c == 0 {
            self.title = "一张照片"
        } else {
            self.title = "LIKESTYLE"
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "<", style: .plain, target: self, action: #selector(pop(sender:)))
        
    }
    
    func pop(sender:UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func pressed(sender:UITapGestureRecognizer) {
        let vc = TempViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
