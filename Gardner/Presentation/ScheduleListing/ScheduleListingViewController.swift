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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Schedule"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: .main), forCellReuseIdentifier: "ScheduleTableViewCell")
    }
}

extension ScheduleListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        return cell
    }
    
    
}
