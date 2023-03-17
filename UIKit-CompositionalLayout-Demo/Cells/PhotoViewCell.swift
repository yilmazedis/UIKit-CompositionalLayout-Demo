//
//  PhotoViewCell.swift
//  UIKit-CompositionalLayout-Demo
//
//  Created by yilmaz on 7.10.2022.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {

    private var currentPhotoID: String?
    private var imageDownloader = ImageDownloader()
//    private var screenScale: CGFloat { return UIScreen.main.scale }

    lazy var imageView: UIImageView = {
       let view = UIImageView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        downloadImage()
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        downloadImage()
        setLayout()
    }
    
    private func setLayout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    override func prepareForReuse() {
        currentPhotoID = nil
        imageView.backgroundColor = .clear
        imageView.image = nil
        imageDownloader.cancel()
    }

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        let fontSize: CGFloat = traitCollection.horizontalSizeClass == .compact ? 10 : 13
//        userNameLabel.font = UIFont.systemFont(ofSize: fontSize)
//    }

    // MARK: - Setup

//    func configure(with photo: UnsplashPhoto, showsUsername: Bool = true) {
//        imageView.backgroundColor = photo.color
//        currentPhotoID = photo.identifier
//        downloadImage(with: photo)
//    }

     func downloadImage() {
//        guard let regularUrl = photo.urls[.regular] else { return }
//
//        let url = sizedImageURL(from: regularUrl)
//
//        let downloadPhotoID = photo.identifier
        
        let url = URL(string: "https://images.unsplash.com/photo-1665001423954-df4c8c0d564a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjY3OTh8MHwxfGNvbGxlY3Rpb258MXwzMTcwOTl8fHx8fDJ8fDE2NjUxNjYxNzM&ixlib=rb-1.2.1&q=80&w=1080")!

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
//            guard let strongSelf = self, strongSelf.currentPhotoID == downloadPhotoID else { return }
            
            guard let self = self else { return }
            
            if isCached {
                self.imageView.image = UIImage(named: "myCode")
                print("got from cache")
            } else {
                UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.imageView.image = image
                }, completion: nil)
            }
        })
    }

//    private func sizedImageURL(from url: URL) -> URL {
//        layoutIfNeeded()
//        return url.appending(queryItems: [
//            URLQueryItem(name: "w", value: "\(frame.width)"),
//            URLQueryItem(name: "dpr", value: "\(Int(screenScale))")
//        ])
//    }
}
