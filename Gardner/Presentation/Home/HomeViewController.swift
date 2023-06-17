//
//  ViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblMsgWithName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    private var model: [SectionItemsData] = []
    private var presenter: HomePresenterType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isHidden = true
        
        self.collectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        self.collectionView.register(UINib(nibName: "ServiceCollectionViewHeader", bundle: .main), forCellWithReuseIdentifier: "ServiceCollectionViewHeader")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.lblMsgWithName.text = "Hello \(UserSession.instance.name)"
        self.lblMobileNumber.text = UserSession.instance.contact
        
        self.presenter = HomePresenter(homeService: ServicesService(apiClient: APIClient(session: .default)))
        (self.presenter as! HomePresenter).outputs = self
        self.presenter.getServices()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        
        cell.configure(service: self.model[indexPath.section].data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            case 0: return CGSize(width: (collectionView.frame.size.width - 68) / 2, height: 100)
            case 1: return CGSize(width: (collectionView.frame.size.width - 72) / 3, height: 80)
            case 2: return CGSize(width: (collectionView.frame.size.width - 72) / 3, height: 80)
            default: return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ServiceCollectionViewHeader",for: indexPath)
            
                guard let typedHeaderView = headerView as? ServiceCollectionViewHeader else { return headerView }
            
            typedHeaderView.configure(title: self.model[indexPath.section].title)
                return typedHeaderView
            default:
                assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let service = self.model[indexPath.section].data[indexPath.row]
        
        let serviceDetailsPresenter = ServiceDetailsPresenter(service: ServicesService(apiClient: APIClient(session: .default)), serviceEntity: service)
        let serviceDetailsVC = ServiceDetailsViewController.make(presenter: serviceDetailsPresenter)
        
        serviceDetailsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(serviceDetailsVC, animated: true)
    }
}

extension HomeViewController: HomePresenterOutput {
    func homePresenter(homeDataFetchSuccess model: [SectionItemsData]) {
        self.model = model
        self.collectionView.reloadData()
    }
    
    func homePresenter(homeDataFetchFail message: String) {
        self.showSnackBar(message: message)
    }
    
    func showLoader() {
        self.startLoader()
    }
    
    func hideLoader() {
        self.stopLoader()
    }
}
