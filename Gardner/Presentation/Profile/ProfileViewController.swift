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
    private var image: UIImage?
    
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
    
    func profilePresenter(profileUpdateSuccess profile: UserProfile) {
        self.showSnackBar(message: "Profile updated successfully")
        UserSession.instance.profile = profile
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        cell.configure(profile: self.userProfile, selectedImage: self.image)
        
        cell.saveButtonTapHandler = { [weak self] (image, fName, lName) in
            guard let self = self else { return }
            
            if let imageData = image?.jpegData(compressionQuality: 0.1) {
                self.presenter.updateProfile(imageData: imageData, fName: fName, lName: lName)
            }
        }
        
        cell.changeAvatorTapHandler = { [weak self] in
            guard let self = self else { return }
            
            self.showImageSelectionActionSheet()
        }
        
        return cell
    }
    
    private func showImageSelectionActionSheet() {
        let actionsheet = UIAlertController(title: "Select Profile Photo", message: "", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.openPhotoLibrary()
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.openCamera()
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionsheet, animated: true)
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            self.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    private func openCamera() {
        
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.image = image
            self.tableView.reloadData()
        }
          
        self.dismiss(animated: true, completion: nil)
    }
}
