import Foundation
import UIKit

class ImageCollectionView: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16.0
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 0.1
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15.0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpView()
        setUpConstraints()
    }
    
    private func setUpView() {
        self.contentView.addSubview(imageView)
    }
    
    private func setUpConstraints() {
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

