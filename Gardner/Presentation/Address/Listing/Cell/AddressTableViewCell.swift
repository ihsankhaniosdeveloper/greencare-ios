//
//  AddressTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!
    
    var indexPath: IndexPath?
    var deleteButtonTapHandler: ((IndexPath)->())?
    var editButtonTapHandler: ((IndexPath)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func configure(address: Address, indexPath: IndexPath) {
        self.indexPath = indexPath
        
        self.lblTitle.text = address.title?.capitalized
        self.lblInstructions.text = address.completeAddress
    }
    
    @IBAction func deleteButtonTap(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        
        if let deleteButtonTapHandler = self.deleteButtonTapHandler {
            deleteButtonTapHandler(indexPath)
        }
    }
    
    @IBAction func editButtonTap(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        
        if let editButtonTapHandler = self.editButtonTapHandler {
            editButtonTapHandler(indexPath)
        }
    }
    
}
