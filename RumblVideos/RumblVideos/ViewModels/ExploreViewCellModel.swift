import AVFoundation
import Foundation
import UIKit

protocol VideoPlayerPresenter: class {
    func presentVideoPlayer(forIndex: Int, title: String)
}

protocol ExploreViewCellModelDisplayable {
    var title: String { get set }
    var numberOfImagesToDisplay: Int { get }
    var presenter: VideoPlayerPresenter? { get set }
    func getVideoThumbnail(forIndex: Int, completion: @escaping ((_ image: UIImage?)->Void))
    func didTapCell(forIndex: Int)
}

class ExploreViewCellModel: ExploreViewCellModelDisplayable {

    var title: String
    private let nodes: [Nodes]
    weak var presenter: VideoPlayerPresenter?
    private let imageDownloader: ImageDownloader
    private let backgroundQueue: OperationQueue
    
    init(title: String,
         nodes: [Nodes],
         imageDownloader: ImageDownloader = ThumbnailImageDownloader(),
         backgroundQueue: OperationQueue = OperationQueue()) {
        self.title = title
        self.nodes = nodes
        self.imageDownloader = imageDownloader
        self.backgroundQueue = backgroundQueue
    }
    
    private lazy var imageGalleryURLs: [String] = {
        var galleryURLs : [String] = []
        for node in nodes {
            let imageUrl = node.video
            for value in imageUrl.values {
                galleryURLs.append(value)
            }
        }
        return galleryURLs
    }()
    
    var numberOfImagesToDisplay: Int {
        return imageGalleryURLs.count
    }
    
    func getVideoThumbnail(forIndex: Int, completion: @escaping ((UIImage?) -> Void)) {
        let urlString = imageGalleryURLs[forIndex]
        let url = URL(string: urlString)
        backgroundQueue.addOperation {
            self.imageDownloader.getThumbnailImageFromVideoUrls(url: url!) { (image) in
                completion(image)
            }
        }
    }
    
    func didTapCell(forIndex: Int) {
        presenter?.presentVideoPlayer(forIndex: forIndex, title: title)
    }
}
