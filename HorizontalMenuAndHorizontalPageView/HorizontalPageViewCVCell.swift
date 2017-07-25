//
//  HorizontalPageViewCVCell.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/6/2.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit

class HorizontalPageViewCVCell: UICollectionViewCell {

    lazy var view4Page: UIView = { [weak self] in
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view4Page)
        bringSubview(toFront: view4Page)
        view4Page.snp.makeConstraints({ (m) in
            m.edges.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
