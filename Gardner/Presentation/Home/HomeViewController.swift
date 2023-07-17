//
//  ViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var ivProfileAvaror: UIImageView!
    @IBOutlet weak var lblMsgWithName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblWelcomeMsg: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var serviceRequests: [ServiceRequest] = []
    private var refreshControl = UIRefreshControl()
    private var presenter: HomePresenterType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: .main), forCellReuseIdentifier: "HomeTableViewCell")
        self.tableView.refreshControl = self.refreshControl
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefreshAction(_ :)), for: .valueChanged)
        
        self.presenter = HomePresenter(
            requestsService: ServiceRequestService(apiClient: APIClient(session: .default)),
            userService: AuthenticationService(apiClient:APIClient(session: .default))
        )
        
        (self.presenter as! HomePresenter).outputs = self
        
        // add tap gesture to profile image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileTapped(_:)))
        self.ivProfileAvaror.isUserInteractionEnabled = true
        self.ivProfileAvaror.addGestureRecognizer(tap)
        
        let message = "Welcomen to GreenCare"
        let range = (message as NSString).range(of: "GreenCare")
        
        let mutableAttributedString = NSMutableAttributedString.init(string: message)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "primaryColor")!, range: range)
        lblWelcomeMsg.attributedText = mutableAttributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.presenter.fetchServiceRequest()
        self.presenter.fetchUserProfile()
    }
    
    @objc func profileTapped(_ sender: UITapGestureRecognizer) {
        let profileVC = ProfileViewController.make(
            presenter: ProfilePresenter(
                service: AuthenticationService(
                    apiClient: APIClient(session: .default)
                )
            )
        )
        
        profileVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func pullToRefreshAction(_ sender: Any) {
        self.presenter.fetchServiceRequest()
    }
    
    
    @IBAction func notificationsButtonTap(_ sender: Any) {
        let presenter = NotificationListingPresetner(service: NotificationService(apiClient: APIClient(session: .default)))
        let notificationListingVC = NotificationListingViewController.make(presenter: presenter)
        notificationListingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(notificationListingVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.configure(serviceRequest: self.serviceRequests[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = ServiceRequestDetailsViewController.make(
            presenter: ServiceRequestDetailsPresenter(service: ServiceRequestService(apiClient: APIClient(session: .default))),
            serviceRequest: self.serviceRequests[indexPath.row]
        )
        
        detailsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension HomeViewController: HomePresenterOutput {
    func homePresenter(serviceRequestsFetchingSuccess requests: [ServiceRequest]) {
        self.serviceRequests = requests
        self.tableView.reloadData()
    }
    
    
    func homePresenter(serviceRequestsFetchingFail message: String) {
        self.showSnackBar(message: message)
    }
    
    func homePresenter(userProfileFetchingSuccess profile: UserProfile) {
        if let firstName = UserSession.instance.profile?.firstName {
            self.lblMsgWithName.text = "Hello \(firstName) \(UserSession.instance.profile?.lastName ?? "")"
        } else {
            self.lblMsgWithName.text = "Hello"
        }
        
        self.lblMobileNumber.text = UserSession.instance.contact
        self.ivProfileAvaror.sd_setImage(with: URL(string: profile.profilePicture ?? ""), placeholderImage: UIImage(named: "profile_placeholder"), context: nil)
    }
    
    func startLoading() {
        if self.refreshControl.isRefreshing == false {
            self.startActivityIndicator()
        }
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
        self.refreshControl.endRefreshing()
    }
}
