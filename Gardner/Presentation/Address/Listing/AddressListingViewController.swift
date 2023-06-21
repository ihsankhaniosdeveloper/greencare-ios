//
//  AddressListingViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import UIKit

class AddressListingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var addressList: [Address] = []
    private var isPresented: Bool = false
    private var isLoaded: Bool = false
    
    private var presenter: AddressListingPresenterType!
    
    var addressSelected: ((Address)->())?
    
    static func make(presenter: AddressListingPresenterType, isPresented: Bool = false) -> AddressListingViewController {
        let vc = AddressListingViewController(nibName: "AddressListingViewController", bundle: .main)
        
        vc.presenter = presenter
        vc.isPresented = isPresented
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Addresses"
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTap(_ :)))
        
        if isPresented {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTap(_ :)))
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "AddressTableViewCell", bundle: .main), forCellReuseIdentifier: "AddressTableViewCell")
        self.tableView.register(UINib(nibName: "EmptyTableViewCell", bundle: .main), forCellReuseIdentifier: "EmptyTableViewCell")
        
        (self.presenter as! AddressListingPresenter).outputs = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.getAllAddresses()
    }
    
    @objc func addAddressTap(_ sender: Any) {
        let addressAddPresenter = AddressAddPresenter(service: AddressService(apiClient: APIClient(session: .default)))
        let addressAddVC = AddAddressViewController.make(presenter: addressAddPresenter)
        
        let navVC = UINavigationController(rootViewController: addressAddVC)
        navVC.modalPresentationStyle = .fullScreen
        
        self.present(navVC, animated: true)
    }
    
    @objc func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension AddressListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressList.isEmpty && isLoaded ? 1 : self.addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.addressList.isEmpty && isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.configure(message: "No address found, press + buttton to add address.")
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        
        cell.configure(address: self.addressList[indexPath.row], indexPath: indexPath)
        
        cell.editButtonTapHandler = { [weak self] cIndexPath in
            let selectedAddress = self?.addressList[cIndexPath.row]
            
            let vc = AddAddressViewController.make(
                presenter: AddressAddPresenter(
                    service: AddressService(
                        apiClient: APIClient(session: .default)
                    )
                ), mode: .update, address: selectedAddress)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.deleteButtonTapHandler = { [weak self] cIndexPath in
            guard let selectedAddressId = self?.addressList[cIndexPath.row].id else { return }
            
            self?.presenter.deleteAddress(addressId: selectedAddressId)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let addressSelected = self.addressSelected {
            addressSelected(self.addressList[indexPath.row])
            self.dismiss(animated: true)
        }
    }
}

extension AddressListingViewController: AddressListingPresenterOutput {
    func addressListingPresenter(addressesFetchingSuccess addresses: [Address]) {
        self.isLoaded = true
        self.addressList = addresses
        self.tableView.reloadData()
    }
    
    func addressListingPresenter(addressesFetchingFailed message: String) {
        self.isLoaded = true
        self.showSnackBar(message: message)
        self.isLoaded = true
        self.tableView.reloadData()
    }
    
    func addressListingPresenter(addressesDeleteSuccess message: String) {
        self.presenter.getAllAddresses()
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}
