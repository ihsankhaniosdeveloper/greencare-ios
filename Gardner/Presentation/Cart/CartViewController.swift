//
//  CartViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var viewPromoCode: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewPromoCode.layer.borderColor = UIColor(named: "primaryColor")!.cgColor
        self.viewPromoCode.layer.borderWidth = 1
        
    }
}
