//
//  ProfileViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 26/04/2023.
//

import UIKit

struct ProfileCell {
    let title: String
    let color: String
    let type: ProfileCellType
}

enum ProfileCellType {
    case profileDetails
    case myAddresses
    case settings
    case support
    case logout
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var models: [ProfileCell] = []
    private var presenter: ProfilePresenterType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = ProfilePresenter(profileService: ProfileService())
        (self.presenter as! ProfilePresenter).outputs = self
        
        self.presenter.getTableData()
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: .main), forCellReuseIdentifier: "ProfileTableViewCell")
        self.tableView.register(UINib(nibName: "ProfileTableViewHeader", bundle: .main), forHeaderFooterViewReuseIdentifier: "ProfileTableViewHeader")
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        cell.configure(for: self.models[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileTableViewHeader") as! ProfileTableViewHeader
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.models[indexPath.row].type {
            
        case .profileDetails:
            break
            
        case .myAddresses:
            break
            
        case .settings:
            break
            
        case .support:
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

extension ProfileViewController: ProfilePresenterOutput {
    func profilePresenter(profileTableData: [ProfileCell]) {
        self.models = profileTableData
        self.tableView.reloadData()
    }
}
