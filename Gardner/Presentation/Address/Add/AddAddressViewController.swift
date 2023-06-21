//
//  AddAddressViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import UIKit

enum AddressControllerMode {
    case add
    case update
}

class AddAddressViewController: UIViewController {
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfArea: UITextField!
    @IBOutlet weak var tfBuildingName: UITextField!
    @IBOutlet weak var tfStreetName: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    
    private var presenter: AddressAddPresenterType!
    private var mode: AddressControllerMode = .add
    private var address: Address?
    
    static func make(presenter: AddressAddPresenterType, mode: AddressControllerMode = .add, address: Address? = nil) -> AddAddressViewController {
        let vc = AddAddressViewController(nibName: "AddAddressViewController", bundle: .main)
        
        vc.presenter = presenter
        vc.mode = mode
        vc.address = address
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.mode == .update ? "Update Address" : "Add Address"
        if self.mode != .update {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTap(_ :)))
        }
        
        (self.presenter as! AddressAddPresenter).outputs = self
        
        self.fillAddressFieldsForUpdate()
    }
    
    private func fillAddressFieldsForUpdate() {
        tfTitle.text = self.address?.title
        tfArea.text = self.address?.area
        tfBuildingName.text = self.address?.buildingName
        tfStreetName.text = self.address?.streetName
        tfCity.text = self.address?.city
    }

    @objc func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmButtonTap(_ sender: Any) {
        switch mode {
        case .add:
            self.presenter.addAddress(
                title: self.tfTitle.text,
                area: self.tfArea.text,
                streetName: tfStreetName.text,
                buildingName: tfBuildingName.text,
                city: tfCity.text
            )
            
        case .update:
            guard let addressId = self.address?.id else { return }
            
            self.presenter.updateAddress(address: Address(
                title: self.tfTitle.text,
                area: self.tfArea.text,
                streetName: self.tfStreetName.text,
                buildingName: self.tfBuildingName.text,
                city: self.tfCity.text,
                instructions: self.tfTitle.text,
                id: "",
                createdAt: nil,
                v: nil, addressId: addressId)
            )
        }
    }
}

extension AddAddressViewController: AddressAddPresenterOutput {
    func addressPresenter(addressUpdated message: String) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addressAddPresenter(addressAdded address: Address) {
        self.dismiss(animated: true)
    }
    
    func addressAddPresenter(addressAddingFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func addressAddPresenter(addressValidationError validationError: FieldValidationError) {
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}
