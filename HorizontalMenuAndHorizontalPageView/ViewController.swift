//
//  ViewController.swift
//  HorizontalMenuAndHorizontalPageView
//
//  Created by 丁偉哲 on 2017/7/25.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit
//MARK:- 水平菜單＋水平pageview Delegate
extension ViewController : View4HorizontalMenuDelegate {
    func sendDidSelectMuneTag(buttonTag: Int) {
        horizontalPageVC.horizontalPageView(scrollTo: buttonTag)
    }
}
extension ViewController : HorizontalPageViewDelegate {
    func sendDidSelectPageViewIndexPathRow(row: Int) {
        horizontalMenu?.setDefaultSelectButton(defaultButtonIs: row)
        horizontalMenu?.offsetBottomLine(tag: row)
    }
}
class ViewController: UIViewController {
    @IBOutlet weak var view4HorizontalMenu: UIView!
    @IBOutlet weak var view4HorizontalPageView: UIView!
    //水平菜單＋水平PageView用
    fileprivate var horizontalMenu:View4HorizontalMenu!
    fileprivate var horizontalPageVC:HorizontalPageVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setHorizontalMenu()
        setHorizontalPageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-產生水平菜單跟水平PageView
    private func setHorizontalMenu(){
        horizontalMenu = View4HorizontalMenu(frame: view4HorizontalMenu.bounds,
                                             menuTitles: [" 第一頁"," 第二頁", "第三頁"],
                                             isMenuButtonHaveImage: true,
                                             image4MenuButtons: ["item-dc","item-down", "item-down4CustomerChannelVideoPlayVC"],
                                             selectMenuBackgroundColor: UIColor(red: 18/255, green: 47/255, blue: 147/255, alpha: 1),
                                             deselectMenuBackgroundColor: UIColor(red: 18/255, green: 47/255, blue: 167/255, alpha: 1),
                                             selectMenuTitleColor: .white,
                                             deselectMenuTitleColor: .lightGray,
                                             showBottomLine: true,
                                             bottomLineColor: .white,
                                             bottomLineHeight: 5)
        view4HorizontalMenu.addSubview(horizontalMenu)
        horizontalMenu.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        horizontalMenu.delegate = self
        horizontalMenu.setDefaultSelectButton(defaultButtonIs: 0)
        
    }
    private func setHorizontalPageView(){
        horizontalPageVC = HorizontalPageVC()
        horizontalPageVC.parentView = view4HorizontalPageView
        horizontalPageVC.storyBoardNames = ["Page1","Page2","Page3"]
        horizontalPageVC.delegate = self
        addChildViewController(horizontalPageVC)
        view4HorizontalPageView.addSubview(horizontalPageVC.view)
        horizontalPageVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view4HorizontalPageView.bringSubview(toFront: horizontalPageVC.view)
        horizontalPageVC.didMove(toParentViewController: self)
    }
    
    
    
}

