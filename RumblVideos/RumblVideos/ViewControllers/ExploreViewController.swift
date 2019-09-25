import UIKit
import AVKit

class ExploreViewController: UIViewController {
    
    private let cellReusableIdentifier = "cellReusableIdentifier"
    private let viewModel: ExploreViewModelDisplayable
    
    private lazy var categoriesListView: UITableView = {
        let categoriesListView  = UITableView()
        categoriesListView.dataSource = self
        categoriesListView.backgroundColor = UIColor.white
        categoriesListView.translatesAutoresizingMaskIntoConstraints = false
        categoriesListView.rowHeight = 250.0
        categoriesListView.separatorStyle = UITableViewCell.SeparatorStyle.none
        categoriesListView.register(ExploreCell.self, forCellReuseIdentifier:
            cellReusableIdentifier)
        return categoriesListView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpViews()
        setUpConstraints()
    }
    
    init(viewModel: ExploreViewModelDisplayable = ExploreViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ExploreViewModel()
        super.init(coder: aDecoder)
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = viewModel.navigationTitle
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0)]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    private func setUpViews() {
        view.addSubview(categoriesListView)
    }
    
    private func setUpConstraints() {
        categoriesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoriesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoriesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoriesListView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

extension ExploreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReusableIdentifier, for: indexPath) as? ExploreCell {
            let cellViewModel = viewModel.getCellViewModelForIndex(index: indexPath.row)
            cell.updateWithViewModel(cellViewModel: cellViewModel, delegate: self)
            return cell
        } else {
            return UITableViewCell()
        }        
    }
}

extension ExploreViewController: VideoPlayerPresenter {
    
    func presentVideoPlayer(forIndex: Int, title: String) {
        let viewModel = self.viewModel.getPlayerViewModel(title: title, index: forIndex)
        let videoPlayerController = PlayerViewController(viewModel: viewModel)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(videoPlayerController, animated: true)
        }
    }
}


