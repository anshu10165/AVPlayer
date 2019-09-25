import UIKit
import AVFoundation

class ExploreCell: UITableViewCell {
    
    private var viewModel: ExploreViewCellModelDisplayable?
    private let reuasbaleIdenitifer = "reusableIdentifier"
    
    private let categoriesContainerView: UIView = {
        let categoriesContainerView = UIView()
        categoriesContainerView.translatesAutoresizingMaskIntoConstraints = false
        categoriesContainerView.backgroundColor = UIColor.white
        return categoriesContainerView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12.0
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(imageCollectionView)
        return stack
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCollectionView.self, forCellWithReuseIdentifier: reuasbaleIdenitifer)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setUpcategoriesContainerView()
        setUpConstraints()
    }
    
    private func setUpcategoriesContainerView() {
        categoriesContainerView.addSubview(mainStackView)
        self.contentView.addSubview(categoriesContainerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithViewModel(cellViewModel: ExploreViewCellModelDisplayable?,
                             delegate: VideoPlayerPresenter) {
        self.viewModel = cellViewModel
        guard var viewModel = self.viewModel else { return }
        viewModel.presenter = delegate
        titleLabel.text = viewModel.title
    }
    
    func getLabel(lable: String) {
        self.titleLabel.text = lable
    }
    
    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(categoriesContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0))
        constraints.append(categoriesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(categoriesContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(categoriesContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0))
        constraints.append(mainStackView.topAnchor.constraint(equalTo: categoriesContainerView.topAnchor, constant: 8.0))
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: categoriesContainerView.leadingAnchor, constant: 16.0))
        constraints.append(imageCollectionView.bottomAnchor.constraint(equalTo: categoriesContainerView.bottomAnchor, constant: -4.0))
        constraints.append(imageCollectionView.trailingAnchor.constraint(equalTo: categoriesContainerView.trailingAnchor, constant: -16.0))
        NSLayoutConstraint.activate(constraints)
    }
}

extension ExploreCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfImagesToDisplay ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuasbaleIdenitifer, for: indexPath) as? ImageCollectionView {
            cell.tag = indexPath.row
            cell.imageView.image = UIImage(named: "gallerySmallPlaceholder")
            viewModel?.getVideoThumbnail(forIndex: indexPath.row, completion: { (image) in
                DispatchQueue.main.async {
                    if(cell.tag == indexPath.row) {
                        cell.imageView.image = image
                    }
                }
            })
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ExploreCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 4
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension ExploreCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didTapCell(forIndex: indexPath.row)
    }
}
