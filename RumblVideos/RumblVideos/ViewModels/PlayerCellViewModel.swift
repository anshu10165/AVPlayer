import Foundation

protocol PlayerCellViewModelDisplayable {
    func videoToBePlayed() -> URL?
}

class PlayerCellViewModel: PlayerCellViewModelDisplayable {
    
    private let videoItemURl: Nodes
    init(videoItemURl: Nodes) {
        self.videoItemURl = videoItemURl
    }
    
    func videoToBePlayed() -> URL? {
        var videoURLToBePlayed: URL?
        for (key, _) in videoItemURl.video {
            guard let urlFound = videoItemURl.video[key] else {
                return nil
            }
            videoURLToBePlayed = URL(string: urlFound)
        }
        return videoURLToBePlayed
    }
}
