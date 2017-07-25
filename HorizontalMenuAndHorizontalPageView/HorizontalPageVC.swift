//
//  HorizontalPageView.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/6/2.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit
import SnapKit

extension HorizontalPageVC : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (storyBoardNames.count == 0) ? 0 : storyBoardNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HorizontalPageViewCVCell
        let view = pageViews[indexPath.row]
        view.tag  = 100//給view tag,用它來移除舊的view，加入新的view
        
        if let oldView = cell.view4Page.viewWithTag(100){
            oldView.removeFromSuperview()
        }
        
        cell.view4Page.addSubview(view)
        
        view.snp.makeConstraints({ (m) in
            m.edges.equalToSuperview()
        })

        return cell
    }
}
extension HorizontalPageVC : UICollectionViewDelegateFlowLayout {
    //設置集合視圖單元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: collectionView.bounds.width , height: collectionView.bounds.height)
    }
    
    // 設置cell和視圖邊的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 設置每一個cell最小 行 間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 設置每一個cell的 列 間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    // 設置Header的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: 0, height: 0)
    }
    
    // 設置Footer的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: 0, height: 0)
    }
}
//MARK:- 偵測當前的PageViewIndexPath
extension HorizontalPageVC : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    fileprivate func checkScrollViewPoint(scrollView: UIScrollView){
        if scrollView == collectionView {
            var currentCellOffset = collectionView.contentOffset
            currentCellOffset.x += collectionView.frame.size.width / 2.0
            //取得當前的indexpath
            guard let indexPath = collectionView.indexPathForItem(at: currentCellOffset) else { return }
            print("indexPath=\(indexPath)")
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            //傳值給首頁去改變下面的位置
            delegate?.sendDidSelectPageViewIndexPathRow(row: indexPath.row)
        }
    }
}
protocol  HorizontalPageViewDelegate : class{
    func sendDidSelectPageViewIndexPathRow(row:Int)
}

class HorizontalPageVC: UIViewController {
    var parentView:UIView!
    var storyBoardNames = [String]()
    weak var delegate:HorizontalPageViewDelegate?
    
    fileprivate var cellId = "Cell"
    fileprivate var pageViewControllers = [UIViewController]()
    fileprivate var pageViews = [UIView]()
    
    fileprivate var collectionView:UICollectionView!
    
    fileprivate var currentCellIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = parentView.bounds
        initPageVCs()
        setCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        parentView = nil
        delegate = nil
    }
    
    //MARK:- Public method
    public func resetPageViewsWhenViewWillTransition(viewFrame:CGRect){
        for view in pageViews {
            view.frame = viewFrame
        }
        self.view.frame = viewFrame
        collectionView.frame = viewFrame
        collectionView.reloadData()
    }
    public func horizontalPageView(scrollTo:Int){
        let indexPath = IndexPath(row: scrollTo, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    

    
    //MARK:- Private method
   

    private func initPageVCs(){
        for (_, value) in storyBoardNames.enumerated() {
            let vc = self.instantiateInitialViewController(storyboardName: value)
            addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            if let subView = vc.view{
                pageViews.append(subView)
            }
            pageViewControllers.append(vc)
        }


    }
    private func setCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .green
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        self.view.bringSubview(toFront: collectionView)
        collectionView.frame = self.view.bounds
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.allowsSelection = false
        collectionView.register(HorizontalPageViewCVCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}
