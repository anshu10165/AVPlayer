import UIKit
import AVFoundation
import AVKit

class VideoPlayer: UITableViewCell {
    
    private let reuasbaleIdenitifer = "reusableIdentifier"
    private let videoCache = NSCache<NSString, AVAsset>()
    private var playerCellViewModelDisplayable: PlayerCellViewModelDisplayable?

    private var videoItemUrl: URL? {
        didSet {
            initNewPlayerItem()
        }
    }
    
    private var avPlayer: AVPlayer?
    private var avPlayerViewConroller: AVPlayerViewController?
    private var avPlayerLayer: AVPlayerLayer?
    private var videoAsset: AVAsset?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setUpContainer()
        setUpContainerConstraints()
    }
    
    private func setUpContainer() {
        self.avPlayer = AVPlayer()
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayerViewConroller = AVPlayerViewController()
        avPlayerViewConroller?.player = avPlayer
        avPlayerViewConroller?.showsPlaybackControls = true
        avPlayerViewConroller?.view.isUserInteractionEnabled = false
    }
    
    private func setUpContainerConstraints() {
        avPlayerViewConroller?.view.translatesAutoresizingMaskIntoConstraints = false
               insertSubview(avPlayerViewConroller!.view, at: 0)
        avPlayerViewConroller?.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        avPlayerViewConroller?.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        avPlayerViewConroller?.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        avPlayerViewConroller?.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(cellViewModel: PlayerCellViewModelDisplayable?) {
        self.playerCellViewModelDisplayable = cellViewModel
        guard let viewModel =  self.playerCellViewModelDisplayable else { return }
        self.videoItemUrl = viewModel.videoToBePlayed()
    }
    
    
    deinit {
        self.avPlayer = nil
        self.videoAsset = nil
        self.videoItemUrl = nil
        self.avPlayerLayer = nil
        self.avPlayerViewConroller = nil
    }
    
    private func initNewPlayerItem() {
        guard let videoPlayerItemUrl = self.videoItemUrl else {
            return
        }
        videoAsset = AVAsset(url: videoPlayerItemUrl)
        if let cachedVideAsset = videoCache.object(forKey: videoPlayerItemUrl.absoluteString as NSString) {
            let videoPlayerItem = AVPlayerItem(asset: cachedVideAsset)
            self.avPlayer?.replaceCurrentItem(with: videoPlayerItem)
        } else {
            videoAsset?.loadValuesAsynchronously(forKeys: ["duration"]) {
                guard let asset = self.videoAsset, asset.statusOfValue(forKey: "duration", error: nil) == .loaded else {
                    return
                }
                let videoPlayerItem = AVPlayerItem(asset: asset)
                self.videoCache.setObject(asset, forKey: videoPlayerItemUrl.absoluteString as NSString)
                DispatchQueue.global(qos: .background).async {
                    self.avPlayer?.replaceCurrentItem(with: videoPlayerItem)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        self.videoAsset = nil
        self.avPlayer?.replaceCurrentItem(with: nil)
    }
}
