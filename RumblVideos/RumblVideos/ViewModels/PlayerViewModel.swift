import Foundation

protocol PlayerViewModelDisplayable {
    var playerCellViewModels: [PlayerCellViewModel] { get }
    var selectedIndex: Int { get }
    func getCellViewModelFor(index: Int) -> PlayerCellViewModel
}

class PlayerViewModel: PlayerViewModelDisplayable {
    
    private let nodes: [Nodes]
    var selectedIndex: Int
     
    init(nodes: [Nodes], index: Int) {
        self.nodes = nodes
        self.selectedIndex = index
    }
    
    lazy var playerCellViewModels: [PlayerCellViewModel] = {
        var playerCellViewModels: [PlayerCellViewModel] = []
        for node in nodes {
            let cellViewModel = PlayerCellViewModel(videoItemURl: node)
            playerCellViewModels.append(cellViewModel)
        }
        return playerCellViewModels
    }()
    
    func getCellViewModelFor(index: Int) -> PlayerCellViewModel {
        return playerCellViewModels[index]
    }
    
}
