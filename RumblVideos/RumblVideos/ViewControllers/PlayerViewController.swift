import UIKit
import AVKit

class PlayerViewController: UIViewController {
    
    private let cellReusableIdentifier = "cellReusableIdentifier"
    private let viewModel: PlayerViewModelDisplayable

    private lazy var videoList: UITableView = {
        let videoList  = UITableView()
        videoList.delegate = self
        videoList.dataSource = self
        videoList.backgroundColor = UIColor.white
        videoList.translatesAutoresizingMaskIntoConstraints = false
        videoList.rowHeight = self.view.frame.height
        videoList.register(VideoPlayer.self, forCellReuseIdentifier: cellReusableIdentifier)
        return videoList
    }()
    
    private lazy var navigationBarBackButton: UIBarButtonItem = {
        let image = UIImage(named: "back-button")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PlayerViewController.popToPreviousViewController))
        return backButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpView()
        setUpConstraints()
        setUpSwipeGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let indexPath = IndexPath(row: self.viewModel.selectedIndex, section: 0)
            self.videoList.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func setUpNavigationBar() {
        self.navigationItem.leftBarButtonItem = navigationBarBackButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    func setUpView() {
        view.addSubview(videoList)
    }
    
    func setUpSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func setUpConstraints() {
        videoList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        videoList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        videoList.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .right {
            navigationController?.popViewController(animated: true)
            navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }
    }
    
    init(viewModel: PlayerViewModelDisplayable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = PlayerViewModel(nodes: [], index: 0)
        super.init(coder: aDecoder)
    }
    
    @objc private func popToPreviousViewController() {
        navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
}

extension PlayerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playerCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReusableIdentifier, for: indexPath) as? VideoPlayer {
            cell.tag = indexPath.row
            let cellViewModel = viewModel.getCellViewModelFor(index: indexPath.row)
            if(cell.tag == indexPath.row) {
                cell.configureCell(cellViewModel: cellViewModel)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}


