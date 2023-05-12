//
//  ServiceDetailsViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 11/05/2023.
//

import UIKit

class ServiceDetailsViewController: UIViewController {
    @IBOutlet weak var viewTableBG: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    private var presenter: ServiceDetailsPresenterType!
    
    private var service: Service!
    
    static func make(presenter: ServiceDetailsPresenterType) -> ServiceDetailsViewController {
        let vc = ServiceDetailsViewController(nibName: "ServiceDetailsViewController", bundle: .main)
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Details"
        
        tableView.register(UINib(nibName: "DetailsTableViewHeader", bundle: .main), forHeaderFooterViewReuseIdentifier: "DetailsTableViewHeader")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewTableBG.roundWithShadow(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16, withShadow: true)
        
        (self.presenter as! ServiceDetailsPresenter).outputs = self
        self.presenter.loadDefaultData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension ServiceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailsTableViewHeader") as! DetailsTableViewHeader
        
        header.configure(service: self.service)
        
        header.continueButtonTap = { [weak self] in
            let serviceAddVC = ScheduleAddViewController.make(presenter: ScheduleAddPresenter())
            self?.navigationController?.pushViewController(serviceAddVC, animated: true)
        }
        return header
    }
}

extension ServiceDetailsViewController: ServiceDetailsPresenterOutput {
    func serviceDetailsPresenter(updatedService: Service) {
        self.service = updatedService
        self.tableView.reloadData()
    }
}
