//
//  NotificationListingViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 23/06/2023.
//

import UIKit

class NotificationListingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications: [Notification] = []
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
        
        (self.presenter as? NotificationListingPresetner)?.outputs = self
        
        self.presenter.getNotification()
    }
}

extension NotificationListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        cell.configure(notification: self.notifications[indexPath.row])
        return cell
    }
}

extension NotificationListingViewController: NotificationListingPresetnerOutput {
    func notificationsListingPresenter(fetchingSuccess notifications: [Notification]) {
        self.notifications = notifications
        self.tableView.reloadData()
    }
    
    func notificationsListingPresenter(fetchingFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}
