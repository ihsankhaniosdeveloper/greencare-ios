//
//  ViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.collectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        self.collectionView.register(UINib(nibName: "ServiceCollectionViewHeader", bundle: .main), forCellWithReuseIdentifier: "ServiceCollectionViewHeader")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return 5
            case 1: return 50
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        
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
        return UIEdgeInsets(top: 20, left: 24, bottom: 10, right: 24)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      switch kind {
      case UICollectionView.elementKindSectionHeader:
          let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ServiceCollectionViewHeader.self)",for: indexPath)

        guard let typedHeaderView = headerView as? ServiceCollectionViewHeader else { return headerView }
        return typedHeaderView
          
      default:
        // 5
        assert(false, "Invalid element type")
      }
    }
    
}

extension ViewController: HomePresenterOutput {
    
}
