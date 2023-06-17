//
//  HistoryViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPending: UIButton!
    @IBOutlet weak var buttonCompleted: UIButton!
    
    private var requests: [ServiceRequest] = []
    private var presenter: HistoryPresenterType!
    private var selectedSegment: ButtonSegment = .pending
    
    static func make(presenter: HistoryPresenterType) -> HistoryViewController {
        let vc = HistoryViewController(nibName: "HistoryViewController", bundle: .main)
        
        vc.presenter = presenter
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Order History"
        self.navigationController?.navigationBar.isHidden = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: .main), forCellReuseIdentifier: "HistoryTableViewCell")
        
        (self.presenter as? HistoryPresenter)?.outputs = self
        
        self.presenter.fetchServiceRequest(_for: .pending)
    }
    
    @IBAction func pendingButtonTapped(_ sender: Any) {
        self.presenter.fetchServiceRequest(_for: .pending)
        self.updateSegmentButton(_for: .pending)
    }
    
    @IBAction func completedButtonTap(_ sender: Any) {
        self.presenter.fetchServiceRequest(_for: .completed)
        self.updateSegmentButton(_for: .completed)
    }
    
    private func updateSegmentButton(_for state: ButtonSegment) {
        switch state {
            
        case .pending:
            self.buttonPending.backgroundColor = UIColor(named: "primaryColor")
            self.buttonCompleted.backgroundColor = UIColor.lightGray
            
        case .completed:
            self.buttonCompleted.backgroundColor = UIColor(named: "primaryColor")
            self.buttonPending.backgroundColor = UIColor.lightGray
        }
    }
    
}

extension HistoryViewController: HistoryPresenterOutput {
    func historyPresenter(serviceRequestFetchSuccess serviceRequests: [ServiceRequest]) {
        self.requests = serviceRequests
        self.tableView.reloadData()
    }
    
    func historyPresenter(serviceRequestFetchFailed message: String) {
        self.showSnackBar(message: message)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

fileprivate enum ButtonSegment {
    case pending
    case completed
}
