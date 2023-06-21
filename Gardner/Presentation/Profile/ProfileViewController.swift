//
//  ProfileViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 18/06/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: ProfilePresenterType!
    private var userProfile: UserProfile?
    
    static func make(presenter: ProfilePresenterType) -> ProfileViewController {
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: .main)
        
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile Details"
        self.navigationController?.navigationBar.isHidden = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: .main), forCellReuseIdentifier: "ProfileTableViewCell")
        
        (self.presenter as? ProfilePresenter)?.outputs = self
        
        self.presenter.fetchUserProfile()
    }
}

extension ProfileViewController: ProfilePresenterOutput {
    func profilePresenter(profileFetchSuccess profile: UserProfile) {
        self.userProfile = profile
        self.tableView.reloadData()
    }
    
    func profilePresenter(profileFetchFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        cell.configure(profile: self.userProfile)
        
        cell.saveButtonTapHandler = { [weak self] (image, fName, lName) in
            guard let self = self else { return }
            
            self.presenter.updateProfile(imageData: image?.pngData(), fName: fName, lName: lName)
        }
        
        return cell
    }
}
