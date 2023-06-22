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
            
            if self.service.type == .contactOnly {
                self.openWhatsApp()
            } else {
                self.navigateToServiceAddVC()
            }
        }
        
        
        return cell
    }
    
    private func openWhatsApp() {
        let phoneNumber = "1234567890"
        
        let message = "Hello, I need services for following for: \n \(service.title ?? "") \n\n \(service.description ?? "") \n Service ID: \(service.id)"
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        let url = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=\(encodedMessage)")!
            
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            self.showConfirmationAlert(
                title: "What's App Not Installed",
                message: "Contact only services required you what's app to contact out egent.",
                positiveAction: nil
            )
        }
    }
    
    private func navigateToServiceAddVC() {
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
}

extension ServiceDetailsViewController: ServiceDetailsPresenterOutput {
    func serviceDetailsPresenter(updatedService: Service) {
        self.service = updatedService
        self.tableView.reloadData()
    }
}
