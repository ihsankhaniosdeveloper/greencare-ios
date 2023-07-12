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
    private var schedulledRequests: [ServiceRequest] = []
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
        
        self.presenter.fetchScheduleSlots()
    }
}

extension OrdersListingViewController: OrdersListingPresenterOutput {
    func scheduleListingPresenter(scheduleOrderFetchSuccess requests: [ServiceRequest]) {
        self.tableView.isScrollEnabled = !requests.isEmpty
        self.schedulledRequests = requests
        self.isLoadingCompleted = true
        self.tableView.reloadData()
    }
    
    func scheduleListingPresenter(scheduleOrderFetchFailed message: String) {
        tableView.isScrollEnabled = false
        self.isLoadingCompleted = true
        self.tableView.reloadData()
        
        self.showSnackBar(message: message)
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
        return self.schedulledRequests.isEmpty && isLoadingCompleted ? 1 :  self.schedulledRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.schedulledRequests.isEmpty && isLoadingCompleted {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            cell.configure(message: "No schedule request found")
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        
        cell.configure(serviceRequest: self.schedulledRequests[indexPath.row])
        return cell
    }
    
    
}
