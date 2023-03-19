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

     func downloadImage() {
        let url = URL(string: "https://picsum.photos/200")!

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            guard let self = self else { return }
            
            if isCached {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                print("got from cache")
            } else {
                print("got from URL")
                UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
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
