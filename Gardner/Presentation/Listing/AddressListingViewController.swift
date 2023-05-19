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
    
    private var presenter: AddressListingPresenterType!
    
    static func make(presenter: AddressListingPresenterType) -> AddressListingViewController {
        let vc = AddressListingViewController(nibName: "AddressListingViewController", bundle: .main)
        
        vc.presenter = presenter
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Addresses"
        self.navigationController?.navigationBar.isHidden = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "AddressTableViewCell", bundle: .main), forCellReuseIdentifier: "AddressTableViewCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension AddressListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        
        cell.configure(address: self.addressList[indexPath.row])
        
        return cell
    }
}
