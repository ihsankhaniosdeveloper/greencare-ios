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
    
    var slotSelected: ((Slot)->())?
    
    static func make(presenter: SlotListingPresenterType) -> SlotListingViewController {
        let vc = SlotListingViewController(nibName: "SlotListingViewController", bundle: .main)
        
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Slots"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTap(_ :)))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "SlotsTableViewCell", bundle: .main), forCellReuseIdentifier: "SlotsTableViewCell")
        self.tableView.register(UINib(nibName: "SlotsTableSectionHeader", bundle: .main), forHeaderFooterViewReuseIdentifier: "SlotsTableSectionHeader")
    }
    
    @objc func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SlotListingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlotsTableViewCell", for: indexPath) as! SlotsTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SlotsTableSectionHeader") as! SlotsTableSectionHeader
        return header
    }
}
