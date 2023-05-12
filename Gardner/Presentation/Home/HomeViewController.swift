//
//  ViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import UIKit
import Alamofire

struct Service: Decodable {
    let id, title, description: String?
    let plants, hours, persons: Int?
    let subType, instructions, type: String?
    let price: Int?
    let promo: [String]?
    let isDeleted, isActive: Bool?
    let image, backgroundImage: String?
    let contactLink: String?
    let isContactOnly: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, plants, hours, persons, subType, instructions, type, price, promo, isDeleted, isActive, image, backgroundImage, contactLink, isContactOnly, createdAt, updatedAt
        case v = "__v"
    }
}

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var model: [[Service]] = []
    private var presenter: HomePresenterType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.collectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        self.collectionView.register(UINib(nibName: "ServiceCollectionViewHeader", bundle: .main), forCellWithReuseIdentifier: "ServiceCollectionViewHeader")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.presenter = HomePresenter(homeService: HomeService(apiClient: APIClient(session: .default)))
        (self.presenter as! HomePresenter).outputs = self
        self.presenter.getServices()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        
        cell.configure(service: self.model[indexPath.section][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            case 0: return CGSize(width: (collectionView.frame.size.width - 68) / 2, height: 100)
            case 1: return CGSize(width: (collectionView.frame.size.width - 72) / 3, height: 80)
            default: return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ServiceCollectionViewHeader.self)",for: indexPath)
                guard let typedHeaderView = headerView as? ServiceCollectionViewHeader else { return headerView }
                return typedHeaderView
            default:
                assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let service = self.model[indexPath.section][indexPath.row]
        let serviceDetailsPresenter = ServiceDetailsPresenter(apiClient: APIClient(session: .default), service: service)
        let serviceDetailsVC = ServiceDetailsViewController.make(presenter: serviceDetailsPresenter)
        
        serviceDetailsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(serviceDetailsVC, animated: true)
    }
}

extension HomeViewController: HomePresenterOutput {
    func homePresenter(homeDataFetchSuccess model: [[Service]]) {
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
