//
//  DropDownView.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit
import ActionSheetPicker_3_0

protocol DropDownDelegate: AnyObject {
    func dropDown(itemSelected item: Int)
}

class DropDownView: UIView {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblSelectedValue: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    
    private let NIB_NAME = "DropDownView"
    
    private var title: String?
    private var data: [Int] = []
    private var placeholder: String = ""
    
    weak var delegate: DropDownDelegate?
    
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(NIB_NAME, owner: self, options: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropDownTap(_ :)))
        self.viewBG.addGestureRecognizer(tapGesture)
        
        viewBG.fixInView(self)
    }
    
    func configure(title: String, data: [Int], placeholder: String = "", delegate: DropDownDelegate) {
        self.title = title
        self.data = data
        self.placeholder = placeholder
        self.delegate = delegate
    }
    
    @objc func dropDownTap(_ sender: UITapGestureRecognizer) {
        ActionSheetStringPicker.show(withTitle: title, rows: self.data, initialSelection: 0, doneBlock: { sheet, index, value in
            self.delegate?.dropDown(itemSelected: self.data[index])
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender.view)
    }
}
