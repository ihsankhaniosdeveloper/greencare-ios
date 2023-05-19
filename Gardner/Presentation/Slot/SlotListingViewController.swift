//
//  SlotListingViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import UIKit

class SlotListingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var presenter: SlotListingPresenterType!
    
    static func make(presenter: SlotListingPresenterType) -> SlotListingViewController {
        let vc = SlotListingViewController(nibName: "SlotListingViewController", bundle: .main)
        
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
