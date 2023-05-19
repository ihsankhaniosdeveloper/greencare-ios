//
//  AddAddressViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import UIKit

class AddAddressViewController: UIViewController {
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfArea: UITextField!
    @IBOutlet weak var tfBuildingName: UITextField!
    @IBOutlet weak var tfStreetName: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    
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
        self.presenter.addAddress(
            title: self.tfTitle.text,
            area: self.tfArea.text,
            streetName: tfStreetName.text,
            buildingName: tfBuildingName.text,
            city: tfCity.text
        )
    }
}

extension AddAddressViewController: AddressAddPresenterOutput {
    func addressAddPresenter(addressAdded address: Address) {
        self.dismiss(animated: true)
    }
    
    func addressAddPresenter(addressAddingFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func addressAddPresenter(addressValidationError validationError: FieldValidationError) {
        
    }
    
    
}
