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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.title = "Details"
        
        tableView.register(UINib(nibName: "DetailsTableViewHeader", bundle: .main), forHeaderFooterViewReuseIdentifier: "DetailsTableViewHeader")
        tableView.register(UINib(nibName: "ServiceDetailsTableViewCell", bundle: .main), forCellReuseIdentifier: "ServiceDetailsTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewTableBG.roundWithShadow(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16, withShadow: true)
        
        (self.presenter as! ServiceDetailsPresenter).outputs = self
        self.presenter.getServiceDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension ServiceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailsTableViewCell", for: indexPath) as! ServiceDetailsTableViewCell
        
        cell.configure(service: self.service)
        
        cell.continueButtonTap = { [weak self] in
            guard let self = self else { return }
            
            let serviceAddVC = ScheduleAddViewController.make(
                presenter: ScheduleAddPresenter(
                    service: ServicesService(
                        apiClient: APIClient(session: .default)
                    )
                ),
                service: self.service
            )
            
            self.navigationController?.pushViewController(serviceAddVC, animated: true)
        }
        
        
        return cell
    }
}

extension ServiceDetailsViewController: ServiceDetailsPresenterOutput {
    func serviceDetailsPresenter(updatedService: Service) {
        self.service = updatedService
        self.tableView.reloadData()
    }
}
