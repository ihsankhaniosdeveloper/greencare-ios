//
//  AddAddressViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import UIKit

class AddAddressViewController: UIViewController {
    @IBOutlet weak var tfArea: UITextField!
    @IBOutlet weak var tfStreetName: UITextField!
    @IBOutlet weak var tfBuildingName: UITextField!
    
    private var presenter: AddressAddPresenterType!
    
    static func make(presenter: AddressAddPresenterType) -> AddAddressViewController {
        let vc = AddAddressViewController(nibName: "AddAddressViewController", bundle: .main)
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Address"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTap(_ :)))
        
        (self.presenter as! AddressAddPresenter).outputs = self
        
    }

    @objc func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmButtonTap(_ sender: Any) {
        self.presenter.addAddress(area: self.tfArea.text, streetName: self.tfStreetName.text, buildingName: self.tfBuildingName.text)
    }
}

extension AddAddressViewController: AddressAddPresenterOutput {
    
}
