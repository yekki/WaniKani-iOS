//
//  DashboardLayout.swift
//  
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

class DashboardLayout: StratchyHeaderLayout {
  
  let defaultCellInset: CGFloat = 7
  let rowsSpacing: CGFloat = 1
  let aspectRatio:CGFloat = 320/50
  let maxHeight: CGFloat = 60
  
  var originalBotIset: CGFloat?
  
  override func prepareLayout() {
    
    if originalBotIset == nil {
      originalBotIset = collectionView!.contentInset.bottom
    }
    
    let maxSide = max(collectionView!.bounds.size.width, collectionView!.bounds.size.height)
    let contentSize = CGSize(width: collectionView!.bounds.size.width, height: maxSide - originalBotIset!)
    
    let leftInset = defaultCellInset
    let rightInset = defaultCellInset
    
    let width = contentSize.width - (leftInset + rightInset)
    let height = min(width / aspectRatio, maxHeight)
    stratchyHeaderSize = CGSize(width: width * 0.85, height: 85)
    
    let headerHeight = height * 0.5
    
    if let collectionView = collectionView, let numberOfSections = collectionView.dataSource?.numberOfSectionsInCollectionView!(collectionView) {
      var usedHeight = headerHeight * CGFloat(numberOfSections) + stratchyHeaderSize.height
      for var i = 0; i < numberOfSections; i++ {
        if let numberOfCells = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: i) {
          usedHeight += height * CGFloat(numberOfCells)
        }
      }
      
      let freeSpace = contentSize.height - usedHeight
      let freeSpacePerSection = freeSpace / CGFloat(numberOfSections + 1)
      
      headerReferenceSize = CGSize(width: width, height: headerHeight)
      itemSize = CGSize(width: width, height: height)
      
      sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: freeSpacePerSection, right: rightInset)
      minimumInteritemSpacing = defaultCellInset
      minimumLineSpacing = rowsSpacing
      
      let insets = collectionView.contentInset
      collectionView.contentInset = UIEdgeInsets(top: 0, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
}
