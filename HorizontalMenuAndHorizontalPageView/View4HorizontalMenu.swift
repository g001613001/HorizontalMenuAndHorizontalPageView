//
//  View4HorizontalMenu.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/6/2.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit
protocol  View4HorizontalMenuDelegate : class {
    func sendDidSelectMuneTag(buttonTag:Int)
}
class View4HorizontalMenu: UIView {
    weak var delegate:View4HorizontalMenuDelegate?
    
    fileprivate var menuTitles = [String]()
    fileprivate var isMenuButtonHaveImage:Bool!
    fileprivate var image4MenuButtons = [String]()
    fileprivate var selectMenuBackgroundColor:UIColor!
    fileprivate var deselectMenuBackgroundColor:UIColor!
    fileprivate var selectMenuTitleColor:UIColor!
    fileprivate var deselectMenuTitleColor:UIColor!
    fileprivate var showBottomLine:Bool!
    fileprivate var bottomLineColor:UIColor!
    fileprivate var bottomLineHeight:CGFloat!
    fileprivate var buttons = [UIButton]()//用來儲存所有的按鈕
    
    fileprivate var bottomLine:UIView!
    fileprivate var lastDidSelectButtonIndex:Int! = 0
    
    init(frame: CGRect, menuTitles:[String],isMenuButtonHaveImage:Bool? = nil,image4MenuButtons:[String]? = nil, selectMenuBackgroundColor:UIColor , deselectMenuBackgroundColor:UIColor,selectMenuTitleColor:UIColor, deselectMenuTitleColor:UIColor, showBottomLine:Bool, bottomLineColor:UIColor, bottomLineHeight:CGFloat) {
        super.init(frame: frame)
        self.menuTitles = menuTitles
        if let isMenuButtonHaveImage = isMenuButtonHaveImage{
            self.isMenuButtonHaveImage = isMenuButtonHaveImage
        }
        if let image4MenuButtons = image4MenuButtons {
            self.image4MenuButtons = image4MenuButtons
        }
        self.selectMenuBackgroundColor = selectMenuBackgroundColor
        self.deselectMenuBackgroundColor = deselectMenuBackgroundColor
        self.selectMenuTitleColor = selectMenuTitleColor
        self.deselectMenuTitleColor = deselectMenuTitleColor
        self.showBottomLine = showBottomLine
        self.bottomLineColor = bottomLineColor
        self.bottomLineHeight = bottomLineHeight
        setMenuViewBottomLine()
        creatMenuButton()
        if showBottomLine {
            creatBottomLine()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //public method
    /// 裝置旋轉時重新設定按鈕寬度的方法
    ///
    /// - Parameter viewFrame: 要傳入旋轉後你的superView
    public func resetButtonsWidthWhenViewWillTransition(viewFrame:CGRect){
        self.frame = viewFrame
        let menuWidth = viewFrame.width / CGFloat(buttons.count)
        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(x: menuWidth * CGFloat(index), y: 0, width: menuWidth, height: viewFrame.height)
        }
        bottomLine.frame = CGRect(x: menuWidth * CGFloat(lastDidSelectButtonIndex), y: self.bounds.height - bottomLineHeight, width: menuWidth, height: bottomLine.bounds.height)
    }
    
    public func setDefaultSelectButton(defaultButtonIs:Int? = nil){
        if let defaultButtonIs = defaultButtonIs {
            lastDidSelectButtonIndex = defaultButtonIs
            if defaultButtonIs > buttons.count {
                print("Error default button index out of buttons range.")
                return
            }
            changeAllButtonsTitleColorAndBackgroundColor()
            var defaultButton = buttons[defaultButtonIs]
            
            UIView.transition(with: defaultButton, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                if self.isMenuButtonHaveImage {//有按鈕圖案的話也要改變顏色
                    defaultButton = defaultButton.changeButtonImageColor(button: defaultButton, imageName: self.image4MenuButtons[self.lastDidSelectButtonIndex], imageColor: .white)
                }
                defaultButton.setTitleColor(self.selectMenuTitleColor, for: .normal)
                defaultButton.backgroundColor = self.selectMenuBackgroundColor
                self.offsetBottomLine(tag: defaultButtonIs)
            }, completion: nil)
        }else{
            changeAllButtonsTitleColorAndBackgroundColor()
        }
        
    }
    
    public func offsetBottomLine(tag:Int){
        UIView.animate(withDuration: 0.3) {
            let menuWidth = self.bounds.width / CGFloat(self.menuTitles.count)
            self.bottomLine.frame.origin.x =   menuWidth * CGFloat(tag)
            self.layoutIfNeeded()
        }
    }
    
    
    //private method
    private func setMenuViewBottomLine(){
        let menuViewBottomLine = UIView(frame: CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1))
        menuViewBottomLine.backgroundColor = bottomLineColor
        self.addSubview(menuViewBottomLine)
    }
    private func creatMenuButton(){
        let menuWidth = self.bounds.width / CGFloat(menuTitles.count)
        
        for (index , value) in menuTitles.enumerated() {
            let button = UIButton(frame: CGRect(x: menuWidth * CGFloat(index), y: 0, width: menuWidth, height: self.bounds.height))
            button.tag = index//用來判斷點的是哪個按鈕
            button.backgroundColor = deselectMenuBackgroundColor
            if isMenuButtonHaveImage{
                let image = UIImage(named: image4MenuButtons[index])
                button.imageView?.contentMode = .scaleToFill
                button.setImage(image, for: UIControlState.normal)
            }
            button.setTitle(value, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(deselectMenuTitleColor, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.addSubview(button)
            buttons.append(button)
        }
    }
    
    @objc private func buttonAction( sender:UIButton){
        var button = sender
        print("sender=\(sender.tag)")
        setDefaultSelectButton()
        delegate?.sendDidSelectMuneTag(buttonTag: sender.tag)
        lastDidSelectButtonIndex = sender.tag
        UIView.animate(withDuration: 0.3) {
            //移動底部線位置
            self.bottomLine.frame.origin.x = button.bounds.width * CGFloat(button.tag)
            self.layoutIfNeeded()
        }
        UIView.transition(with: button, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            //改變按鈕圖片顏色
            if self.isMenuButtonHaveImage {//有按鈕圖案的話也要改變顏色
                button = sender.changeButtonImageColor(button: button, imageName: self.image4MenuButtons[sender.tag], imageColor: .white)
            }
            //改變按鈕標題顏色
            button.setTitleColor(self.selectMenuTitleColor, for: .normal)
            button.backgroundColor = self.selectMenuBackgroundColor
        }, completion: nil)
        
        
    }
    
    
    private func creatBottomLine(){
        let menuWidth = self.bounds.width / CGFloat(menuTitles.count)
        bottomLine = UIView(frame: CGRect(x: 0, y: self.bounds.height - bottomLineHeight, width: menuWidth, height: bottomLineHeight))
        bottomLine.backgroundColor = bottomLineColor
        self.addSubview(bottomLine)
        
    }
    
    private func changeAllButtonsTitleColorAndBackgroundColor(){
        
        for (index, var button) in self.buttons.enumerated() {
            UIView.transition(with: button, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                if self.isMenuButtonHaveImage {//有按鈕圖案的話也要改變顏色
                    button = button.changeButtonImageColor(button: button, imageName: self.image4MenuButtons[index], imageColor: .gray)
                }
                
                button.setTitleColor(self.deselectMenuTitleColor, for: .normal)
                button.backgroundColor = self.deselectMenuBackgroundColor
            }, completion: nil)
        }
        
    }
    
}
