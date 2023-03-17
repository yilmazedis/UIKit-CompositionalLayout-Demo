//
//  ViewController.swift
//  UIKit-CompositionalLayout-Demo
//
//  Created by yilmaz on 21.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var pagingCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getPagingCompositionalLayout())
        view.register(PhotoViewCell.self, forCellWithReuseIdentifier: "pagingCollectionViewCell")
        return view
    }()
    
    lazy var groupCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getGroupCompositionalLayout())
        view.register(PhotoViewCell.self, forCellWithReuseIdentifier: "groupCollectionViewCell")
        return view
    }()
    
    // this line is just for testing
    private let pagingDataSource = PagingCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLayout()
    }
    
    func setupCollectionView() {
        pagingCollectionView.delegate = self
        pagingCollectionView.dataSource = self
        
//        pagingCollectionView.collectionViewLayout = pagingDataSource
//        pagingCollectionView.delegate = pagingDataSource
//        pagingCollectionView.dataSource = pagingDataSource
        
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
    }
    
    private func setupLayout() {
        setPagingCollectionViewLayout()
        setGroupCollectionViewLayout()
    }
    
    private func setPagingCollectionViewLayout() {
        view.addSubview(pagingCollectionView)
        pagingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pagingCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pagingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pagingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pagingCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setGroupCollectionViewLayout() {
        view.addSubview(groupCollectionView)
        groupCollectionView.translatesAutoresizingMaskIntoConstraints = false
        groupCollectionView.topAnchor.constraint(equalTo: pagingCollectionView.bottomAnchor, constant: 20).isActive = true
        groupCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        groupCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        groupCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func getPagingCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // --------- Carousel ---------                                           // make fraction 1 if needs no whitespace
        let carouselItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95),
                                                                                     heightDimension: .absolute(200)))
        carouselItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let carouselGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [carouselItem])

        let carouselSection = NSCollectionLayoutSection(group: carouselGroup)
        carouselSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // animation
        carouselSection.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        let layout = UICollectionViewCompositionalLayout(section: carouselSection)
        return layout
    }
    
    private func getGroupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        //--------- Group 1 ---------//
        let group1Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        group1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)


        let nestedGroup1Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)))
        nestedGroup1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

         let nestedGroup2Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        nestedGroup2Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        let nestedGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)), subitems: [nestedGroup2Item1])

        let nestedGroup1 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)), subitems: [nestedGroup1Item1, nestedGroup2])

        let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitems: [group1Item1, nestedGroup1])

        //--------- Group 2 ---------//
        let group2Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))
        group2Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitems: [group2Item1])

        //--------- Container Group ---------//
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(600)), subitems: [item, group1, group2])

        let section = NSCollectionLayoutSection(group: containerGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pagingCollectionView {
            return 20
        } else {
            return 70
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == pagingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagingCollectionViewCell",
                                                                for: indexPath) as? PhotoViewCell else { return UICollectionViewCell() }
//            let imageView = UIImageView(frame: cell.frame)
//            imageView.image = UIImage(named: "\(indexPath.row + 1)")
//            imageView.contentMode = .scaleToFill
//            cell.backgroundColor = .random
            cell.downloadImage()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCollectionViewCell", for: indexPath) as? PhotoViewCell else { return UICollectionViewCell() }
            
//            let imageView = UIImageView(frame: cell.frame)
//            imageView.image = UIImage(named: "\(indexPath.row + 1)")
//            imageView.contentMode = .scaleToFill
//            cell.backgroundColor = .random
            cell.downloadImage()
            return cell
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0.4...1),
                       green: .random(in: 0.4...1),
                       blue: .random(in: 0.4...1),
                       alpha: 1)
    }
}
