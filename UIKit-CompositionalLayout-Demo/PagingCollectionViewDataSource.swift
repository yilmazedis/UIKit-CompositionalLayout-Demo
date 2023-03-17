//
//  PagingCollectionViewDataSource.swift
//  UIKit-CompositionalLayout-Demo
//
//  Created by yilmaz on 18.03.2023.
//

import UIKit

class PagingCollectionViewDataSource: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PagingCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    
}

extension PagingCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
