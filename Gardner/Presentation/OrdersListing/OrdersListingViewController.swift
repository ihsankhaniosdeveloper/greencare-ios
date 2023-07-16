//
//  ScheduleListingViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class OrdersListingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: OrderListingPresenterType!
    private var requests: [ServiceRequest] = []
    private var isLoadingCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Orders"
        
        self.presenter = OrdersListingPresenter(service: ServiceRequestService(apiClient: APIClient(session: .default)))
        (self.presenter as? OrdersListingPresenter)?.outputs = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "OrdersTableViewCell", bundle: .main), forCellReuseIdentifier: "OrdersTableViewCell")
        self.tableView.register(UINib(nibName: "EmptyCell", bundle: .main), forCellReuseIdentifier: "EmptyCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.fetchPendingServiceRequests()
    }
}

extension OrdersListingViewController: OrdersListingPresenterOutput {
    func ordersListingPresenter(pendingRequestsFetchingSuccess requests: [ServiceRequest]) {
        self.tableView.isScrollEnabled = !requests.isEmpty
        self.isLoadingCompleted = true
        
        self.requests = requests
        self.tableView.reloadData()
    }
    
    func ordersListingPresenter(pendingRequestsFetchingFailure message: String) {
        tableView.isScrollEnabled = false
        self.isLoadingCompleted = true
        self.tableView.reloadData()
        
        self.showSnackBar(message: message)
    }
    
    
    func ordersListingPresenter(requestStatusUpdated requestId: String) {
        self.requests.removeAll(where: { $0.id == requestId })
        self.tableView.reloadData()
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}

extension OrdersListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.isEmpty && isLoadingCompleted ? 1 :  self.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.requests.isEmpty && isLoadingCompleted {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            cell.configure(message: "No schedule request found")
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        
        cell.acceptButtonTapHandler = { [weak self] indexPath in
            guard let self = self else { return }
            
            let requestId = self.requests[indexPath.row].id
            self.presenter.updateRequestStatus(requestId: requestId, status: .accepted)
        }
        
        cell.rejectButtonTapHandler = { [weak self] indexPath in
            guard let self = self else { return }
            
            let requestId = self.requests[indexPath.row].id
            self.presenter.updateRequestStatus(requestId: requestId, status: .rejected)
        }
        
        cell.configure(serviceRequest: self.requests[indexPath.row], indexPath: indexPath)
        return cell
    }
}
