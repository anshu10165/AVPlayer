import Foundation
import UIKit
import AVKit

protocol ImageDownloader {
    func getThumbnailImageFromVideoUrls(url: URL,
                                        completion: @escaping ((_ image: UIImage?)->Void))
}

class ThumbnailImageDownloader: ImageDownloader {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func getThumbnailImageFromVideoUrls(url: URL,
                                        completion: @escaping ((UIImage?) -> Void)) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            var thmbnlImg = UIImage()
            let asset: AVAsset = AVAsset(url: url as URL)
            let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time: CMTime = CMTimeMakeWithSeconds(0.1, preferredTimescale: 30)
            var img: CGImage?
            do {
                img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                thmbnlImg =  UIImage(cgImage: img!)
                self.imageCache.setObject(thmbnlImg, forKey: url.absoluteString as NSString)
                completion(thmbnlImg)
            } catch {
                completion(nil)
            }
        }
    }
}
