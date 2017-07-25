//
//  Extension.swift
//  HorizontalMenuAndHorizontalPageView
//
//  Created by 丁偉哲 on 2017/7/25.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    func instantiateInitialViewController(storyboardName:String)->UIViewController{
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        return vc
    }
    
    func changeButtonImageColor(button:UIButton, imageName:String, imageColor:UIColor? = .white) -> UIButton{
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = imageColor
        return button
    }
    
}
