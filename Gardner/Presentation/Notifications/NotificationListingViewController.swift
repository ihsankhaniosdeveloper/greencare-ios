//
//  NotificationListingViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 23/06/2023.
//

import UIKit

class NotificationListingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: NotificationListingPresetnerType!
    
    static func make(presenter: NotificationListingPresetnerType) -> NotificationListingViewController {
        let vc = NotificationListingViewController(nibName: "NotificationListingViewController", bundle: .main)
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Notifications"
        self.navigationController?.navigationBar.isHidden = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: .main), forCellReuseIdentifier: "NotificationsTableViewCell")
    }
}

extension NotificationListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        return cell
    }
}
