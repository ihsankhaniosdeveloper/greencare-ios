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
    private var slots: [Slot] = []
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
        
        (self.presenter as! SlotListingPresenter).outputs = self
        self.presenter.getSlots(serviceId: "recurring")
    }
    
    @objc func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SlotListingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.slots.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.slots[section].timeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlotsTableViewCell", for: indexPath) as! SlotsTableViewCell
        
        cell.configure(timeSlot: self.slots[indexPath.section].timeSlots[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SlotsTableSectionHeader") as! SlotsTableSectionHeader
        
        header.configure(date: self.slots[section].date)
        return header
    }
}

extension SlotListingViewController: SlotListingPresenterOutput {
    func slotPresenter(slotsFetchingSuccess slots: [Slot]) {
        self.slots = slots
        self.tableView.reloadData()
    }
    
    func slotPresenter(slotsFetchingFailed message: String) {
        self.showSnackBar(message: message)
    }
}
