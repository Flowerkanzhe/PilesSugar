//
//  HomeAttentionController.swift
//  PilesSugar
//
//  Created by SoloKM on 16/1/12.
//  Copyright © 2016年 SoloKM. All rights reserved.
//

import UIKit

private let HomeHotCellID = "HomeHotCell"


class HomeAttentionController: UICollectionViewController {
    
    
    
    var models = [HomeHotModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
    }
    
    
    init() {
        
        let layout = WaterfallLayout()
        
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupCollectionView() {
        
        collectionView!.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        collectionView!.contentInset.top = kNavgationBarH
        
        registerCellWithID(HomeHotCellID)
        collectionView!.mj_header = RefreshHeader.init(refreshingBlock: { () -> Void in
            
            self.loadNewData()
        })
        
        collectionView!.mj_header.beginRefreshing()
        collectionView!.mj_footer = RefreshFooter.init(refreshingBlock: { () -> Void in
            self.loadMoreData()
        })
    }
    
    
    private func loadNewData(){
        
        
        
        let urlString = "http://www.duitang.com/napi/index/hot/?app_code=gandalf&app_version=5.8%20rv%3A149591&device_name=Unknown%20iPhone&device_platform=iPhone6%2C1&include_fields=sender%2Cfavroite_count%2Calbum%2Cicon_url%2Creply_count%2Clike_count&limit=0&locale=zh_CN&platform_name=iPhone%20OS&platform_version=9.2.1&screen_height=568&screen_width=320&start=0"
        
        
        NetWorkTool.sharedInstance.get(urlString, parameters: nil, success: { (response) -> () in
            
            self.models = HomeHotModel.loadHomeModels(response!)
            
            self.collectionView!.reloadData()
            self.collectionView!.mj_header.endRefreshing()
            }) { (error) -> () in
                
                self.collectionView!.mj_header.endRefreshing()
                
                DEBUGLOG(error)
                
        }
        
    }
    
    
    private func loadMoreData(){
        
        let urlString = "http://www.duitang.com/napi/index/hot/?__dtac=%257B%2522_r%2522%253A%2520%2522538800%2522%257D&app_code=gandalf&app_version=5.9%20rv%3A150681&device_name=Unknown%20iPhone&device_platform=iPhone6%2C1&include_fields=sender%2Cfavroite_count%2Calbum%2Cicon_url%2Creply_count%2Clike_count&limit=0&locale=zh_CN&platform_name=iPhone%20OS&platform_version=9.2.1&screen_height=568&screen_width=320&start=0"
        
        
        NetWorkTool.sharedInstance.get(urlString, parameters: nil, success: { (response) -> () in
            
            self.models += HomeHotModel.loadHomeModels(response!)
            
            self.collectionView!.reloadData()
            self.collectionView!.mj_footer.endRefreshing()
            
            }) { (error) -> () in
                self.collectionView!.mj_footer.endRefreshing()
                
                DEBUGLOG(error)
                
        }
    }
}

extension HomeAttentionController {
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return models.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HomeHotCellID, forIndexPath: indexPath) as! HomeHotCell
        
        cell.homeHotModel = models[indexPath.row]
        
        return cell
    }
    
}


extension HomeAttentionController: WaterfallLayoutDetegate {
    
    func waterfallLayout(waterfallLayout: WaterfallLayout, heightForRowAtIndexPath indexPath: NSIndexPath, columnWidth: CGFloat) -> CGFloat {
        
        let model = models[indexPath.row]
        model.columnWidth = columnWidth

        return model.modelHeight!
    }
    
    func columnCountInWaterflowLayout(waterfallLayout: WaterfallLayout) -> Int {
        
        return 2
    }
}

