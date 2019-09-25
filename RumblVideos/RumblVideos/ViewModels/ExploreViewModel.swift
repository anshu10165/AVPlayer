import Foundation

protocol ExploreViewModelDisplayable {
    var cellViewModels: [ExploreViewCellModel] { get }
    var navigationTitle: String { get }
    func getCellViewModelForIndex(index: Int) -> ExploreViewCellModelDisplayable
    func getPlayerViewModel(title: String, index: Int) -> PlayerViewModelDisplayable
}

class ExploreViewModel: ExploreViewModelDisplayable {
    
    private let videoCategories: [VideoCategories]
    let navigationTitle: String = "EXPLORE"
    
    init(request: CatgoriesRequest = CatgoriesRequest()) {
        self.videoCategories = request.videoCategories
    }
    
    lazy var cellViewModels: [ExploreViewCellModel] = {
        var cellViewModels: [ExploreViewCellModel] = []
        for categories in videoCategories {
            let cellViewModel = ExploreViewCellModel(title: categories.title,
                                                     nodes: categories.nodes)
            cellViewModels.append(cellViewModel)
        }
        return cellViewModels
    }()
    
    func getCellViewModelForIndex(index: Int) -> ExploreViewCellModelDisplayable {
        return cellViewModels[index]
    }
    
    func getPlayerViewModel(title: String, index: Int) -> PlayerViewModelDisplayable {
        var myCategory: VideoCategories?
        for category in videoCategories where category.title == title {
            myCategory = category
        }
        return PlayerViewModel(nodes: (myCategory?.nodes)!, index: index)
    }
}
