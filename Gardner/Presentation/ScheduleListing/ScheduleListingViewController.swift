//
//  ScheduleListingViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class ScheduleListingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: ScheduleListingPresenterType!
    private var schedulledRequests: [ServiceRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Schedule"
        
        self.presenter = ScheduleListingPresenter(service: ServiceRequestService(apiClient: APIClient(session: .default)))
        (self.presenter as? ScheduleListingPresenter)?.outputs = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: .main), forCellReuseIdentifier: "ScheduleTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.fetchScheduleSlots()
    }
}

extension ScheduleListingViewController: ScheduleListingPresenterOutput {
    func scheduleListingPresenter(scheduleOrderFetchSuccess requests: [ServiceRequest]) {
        self.schedulledRequests = requests
        self.tableView.reloadData()
    }
    
    func scheduleListingPresenter(scheduleOrderFetchFailed message: String) {
        
    }
}

extension ScheduleListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedulledRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        cell.configure(serviceRequest: self.schedulledRequests[indexPath.row])
        return cell
    }
    
    
}
