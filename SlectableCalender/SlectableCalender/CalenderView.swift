//
//  CalenderView.swift
//  SlectableCalender
//
//  Created by Shohei Yokoyama on 2016/09/04.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

final class CalenderView: UICollectionView {
    
    private let cellIdentifier = "CalenderCell"
    
    private let weeks: [String] = ["日", "月", "火", "水", "木", "金", "土"]
    
    let sectionSpace: CGFloat = 5
    let cellSpace: CGFloat    = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCell()
        configure()
    }
}

// MARK: - Private Methods -

private extension CalenderView {
    func configure() {
        delegate = self
        dataSource = self
        
        backgroundColor = UIColor.lightGrayColor()
    }
    
    func registerCell() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UICollectionViewDataSource -

extension CalenderView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = CalenderModel()
        return section == 0 ? weeks.count : model.cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalenderCell
        confifuereCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func confifuereCell(cell: CalenderCell, indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            cell.contentLabel.text = weeks[indexPath.row]
        } else {
            let model = CalenderModel()
            cell.contentLabel.text = model.conversionDateFormat(indexPath)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -

extension CalenderView: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let rowCount: CGFloat = 7
        let availableLength = collectionView.frame.width - cellSpace
        return CGSize(width: availableLength / rowCount, height: availableLength / rowCount)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellSpace
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellSpace
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: sectionSpace, right: 0)
        }
        return UIEdgeInsetsZero
    }
}