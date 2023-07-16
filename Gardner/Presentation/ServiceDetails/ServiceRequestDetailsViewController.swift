//
//  ServiceDetailsViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 11/05/2023.
//

import UIKit

class ServiceRequestDetailsViewController: UIViewController {
    @IBOutlet weak var viewTableBG: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    private var presenter: ServiceRequestDetailsPresenterType!
    
    private var serviceRequest: ServiceRequest!
    
    static func make(presenter: ServiceRequestDetailsPresenterType, serviceRequest: ServiceRequest) -> ServiceRequestDetailsViewController {
        let vc = ServiceRequestDetailsViewController(nibName: "ServiceRequestDetailsViewController", bundle: .main)
        vc.serviceRequest = serviceRequest
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.title = "Details"
        
        tableView.register(UINib(nibName: "ServiceRequestDetailsTableViewCell", bundle: .main), forCellReuseIdentifier: "ServiceDetailsTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewTableBG.roundWithShadow(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16, withShadow: true)
        
        (self.presenter as! ServiceRequestDetailsPresenter).outputs = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension ServiceRequestDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailsTableViewCell", for: indexPath) as! ServiceRequestDetailsTableViewCell
        
        cell.configure(serviceRequest: self.serviceRequest)
        
        cell.continueButtonTap = { [weak self] in
            guard let self = self else { return }
            
            self.presenter.updateServiceRequestStatus(requestId: self.serviceRequest.id, currentStatus: self.serviceRequest.status)
        }
        
        return cell
    }
}

extension ServiceRequestDetailsViewController: ServiceRequestDetailsPresenterOutput {
    func serviceRequestDetailsPresenter(statusUpdatedSuccess updatedStatus: ServiceRequestStatus) {
        self.serviceRequest.status = updatedStatus
        self.tableView.reloadData()
    }
    
    func serviceRequestDetailsPresenter(statusUpdatedFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}
