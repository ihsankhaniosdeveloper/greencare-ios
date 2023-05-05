//
//  CountryCodePicker.swift
//  Gardner
//
//  Created by Rashid Khan on 03/05/2023.
//

import UIKit

class CountryCodeView: UIView {

    @IBOutlet weak var ivCountryFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "CountryCodeView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
