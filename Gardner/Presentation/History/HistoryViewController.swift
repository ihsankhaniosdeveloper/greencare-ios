//
//  HistoryViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    
    private var requests: [ServiceRequest] = []
    private var presenter: HistoryPresenterType!
    private var selectedSegment: ButtonSegment = .pending
    
//    static func make(presenter: HistoryPresenterType) -> HistoryViewController {
//        let vc = HistoryViewController(nibName: "HistoryViewController", bundle: .main)
//
//        vc.presenter = presenter
//
//        return vc
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Order History"
        self.navigationController?.navigationBar.isHidden = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: .main), forCellReuseIdentifier: "HistoryTableViewCell")
        
        self.presenter = HistoryPresenter(service: ServiceRequestService(apiClient: APIClient(session: .default)))
        (self.presenter as? HistoryPresenter)?.outputs = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.fetchServiceRequest()
    }
}

extension HistoryViewController: HistoryPresenterOutput {
    func historyPresenter(serviceRequestFetchSuccess serviceRequests: [ServiceRequest]) {
        self.requests = serviceRequests
        self.tableView.reloadData()
    }
    
    func historyPresenter(serviceRequestFetchFailed message: String) {
        self.showSnackBar(message: message)
        
        self.requests = []
        self.tableView.reloadData()
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.configure(serviceRequest: self.requests[indexPath.row])
        return cell
    }
}

fileprivate enum ButtonSegment {
    case pending
    case completed
}
