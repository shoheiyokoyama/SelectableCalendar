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
    
    let sectionSpace: CGFloat = 1
    let cellSpace: CGFloat    = 0
    
    private var selectedRange: [String: Range<Int>?] = [:]
    
    let model = CalenderModel()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerNib()
        configure()
        selectedRange = [model.headerTitle(.current): nil]
    }
}

// MARK: - Private Methods -

private extension CalenderView {
    func configure() {
        delegate = self
        dataSource = self
        backgroundColor = UIColor.lightGrayColor()
    }
    
    func registerNib() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func headerTitle(direction: CalenderModel.MonthDirection) -> String {
        return model.headerTitle(direction)
    }
}

// MARK: - UICollectionViewDelegate -

extension CalenderView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        setRange(indexPath: indexPath)
        collectionView.reloadData()
    }
    
    private func setRange(indexPath indexPath: NSIndexPath) {
        if let range = selectedRange[headerTitle(.current)]?.flatMap({$0}) {
            let selectedSingle = range == range.startIndex..<range.startIndex + 1
            if selectedSingle && range.startIndex == indexPath.row {
                self.selectedRange[headerTitle(.current)] = nil
            } else if selectedSingle {
                self.selectedRange[headerTitle(.current)] = range.startIndex > indexPath.row ? indexPath.row...range.startIndex : range.startIndex...indexPath.row
            } else {
                selectedRange[headerTitle(.current)] = indexPath.row...indexPath.row
            }
        } else {
            selectedRange[headerTitle(.current)] = indexPath.row...indexPath.row
        }
        setRangeForOtherMonth(indexPath: indexPath)
    }
    
    private func setRangeForOtherMonth(indexPath indexPath: NSIndexPath) {
        guard let range = selectedRange[headerTitle(.current)]?.flatMap({$0}) else { return }

        var includeFirstWeek = false
        (0..<CalenderModel.weeks.count).forEach({ if range ~= $0 { includeFirstWeek = true } })
        if model.indexForFirstDate(monthDirection: .current) != 0 && includeFirstWeek {
            var previousLastWeeks = model.cellCount(monthDirection: .previous) - CalenderModel.weeks.count..<model.cellCount(monthDirection: .previous)
            previousLastWeeks.startIndex += range.startIndex
            if range.endIndex < CalenderModel.weeks.count {
                previousLastWeeks.endIndex -= CalenderModel.weeks.count - range.endIndex
            }
            self.selectedRange[headerTitle(.previous)] = previousLastWeeks
        }
        
        var includeLastWeek = false
        (model.cellCount(monthDirection: .current) - CalenderModel.weeks.count..<model.cellCount(monthDirection: .current)).forEach({ if range ~= $0 { includeLastWeek = true } })
        if model.indexForLastDate(monthDirection: .current) + 1 != model.cellCount(monthDirection: .current) && includeLastWeek {
            var nextfirstWeeks = 0..<CalenderModel.weeks.count
            nextfirstWeeks.endIndex -= model.cellCount(monthDirection: .current) - range.endIndex
            if range.startIndex >= model.cellCount(monthDirection: .current) - CalenderModel.weeks.count {
                nextfirstWeeks.startIndex += CalenderModel.weeks.count - (model.cellCount(monthDirection: .current) - range.startIndex)
            }
            self.selectedRange[headerTitle(.next)] = nextfirstWeeks
        }
    }
}

// MARK: - UICollectionViewDataSource -

extension CalenderView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? CalenderModel.weeks.count : model.cellCount(monthDirection: .current)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalenderCell
        confifuereCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func confifuereCell(cell: CalenderCell, indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            cell.contentLabel.text = CalenderModel.weeks[indexPath.row]
            cell.contentLabel.textColor = UIColor.blackColor()
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.contentLabel.text = model.stringFromDate(indexPath)
            cell.contentLabel.textColor = {
                if indexPath.row < model.indexForFirstDate(monthDirection: .current) || indexPath.row > model.indexForLastDate(monthDirection: .current)  {
                    return UIColor.lightGrayColor()
                } else if indexPath.row % 7 == 0 {
                    return UIColor.redColor()
                } else if indexPath.row % 7 == 6 {
                    return UIColor.blueColor()
                } else {
                    return UIColor.blackColor()
                }
            }()
            cell.backgroundColor = {
                if let range = selectedRange[headerTitle(.current)]?.flatMap({$0}) {
                    if range ~= indexPath.row {
                        return UIColor.greenColor()
                    } else if range.startIndex - 2..<range.startIndex ~= indexPath.row ||
                        range.endIndex..<range.endIndex + 2 ~= indexPath.row {
//                        return UIColor.lightGrayColor()
                    }
                }
               return UIColor.whiteColor()
            }()
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