//
//  SettingsViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 26/04/2023.
//

import UIKit

struct SettingsCell {
    let title: String
    let color: String
    let type: SettingsCellType
}

enum SettingsCellType {
    case profileDetails
    case myAddresses
    case orderHistory
    case support
    case logout
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var models: [SettingsCell] = []
    private var presenter: SettingsPresenterType!
    private var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = SettingsPresenter(profileService: SettingsService())
        (self.presenter as! SettingsPresenter).outputs = self
        
        self.presenter.getTableData()
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: .main), forCellReuseIdentifier: "SettingsTableViewCell")
        self.tableView.register(UINib(nibName: "SettingsTableViewHeader", bundle: .main), forHeaderFooterViewReuseIdentifier: "SettingsTableViewHeader")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userProfile = UserSession.instance.profile
        self.tableView.reloadData()
    }
    
    private func navigateToProfile() {
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
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        cell.configure(for: self.models[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsTableViewHeader") as! SettingsTableViewHeader
        
        if let userProfile = UserSession.instance.profile {
            header.configure(userProfile: userProfile)
        }
        
        header.editButtonTapHandler = { [weak self] in
            self?.navigateToProfile()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.models[indexPath.row].type {
            
        case .profileDetails:
            self.navigateToProfile()
            break
            
        case .myAddresses:
            let addressListingVC = AddressListingViewController.make(presenter: AddressListingPresenter(service: AddressService(apiClient: APIClient(session: .default))))
            addressListingVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addressListingVC, animated: true)
            
        case .orderHistory:
            let historyVC = HistoryViewController.make(
                presenter: HistoryPresenter(
                    service: ServiceRequestService(apiClient: APIClient(session: .default))
                )
            )
            historyVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(historyVC, animated: true)
            break
            
        case .support:
            let supportVC = SupportViewController(nibName: "SupportViewController", bundle: .main)
            supportVC.modalPresentationStyle = .custom
            supportVC.modalTransitionStyle = .crossDissolve
            present(supportVC, animated: true)
            break
            
        case .logout:
            self.showConfirmationAlert(title: "Are you sure you want to logout?", message: "", positiveActionTitle: "Logout") {
                UserSession.instance.destroy()
                
                if #available(iOS 13.0, *) {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate {
                        sceneDelegate.decideRootViewController()
                    }

                } else {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.decideRootViewController()
                    }
                }
            }
            break
        }
    }
}

extension SettingsViewController: SettingsPresenterOutput {
    func profilePresenter(profileTableData: [SettingsCell]) {
        self.models = profileTableData
        self.tableView.reloadData()
    }
}
