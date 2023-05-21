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
    var selectedSlotsHandler: (([Slot])->())?
    
    private var selectedSlotsDictionary: [Date: [Date]] = [:]
    private var selectedSlotsIndexPath: [IndexPath] = []
    
    private var expandedSection: Int?
    private var lastSelectedSection: Int = -1
    
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
    
    
    @IBAction func doneButtonTap(_ sender: Any) {
        if let selectedSlotsHandler = self.selectedSlotsHandler {
            var selectedSlots: [Slot] = []
            
            for (key, value) in self.selectedSlotsDictionary {
                let sortedTimeSlots = value.sorted { date1, date2 in
                    return date1 < date2
                }
                selectedSlots.append(Slot(date: key, timeSlots: sortedTimeSlots))
            }
            
            selectedSlotsHandler(selectedSlots)
            dismiss(animated: true)
        }
    }
}

extension SlotListingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.slots.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (slots[section].isExpanded ?? false) ? self.slots[section].timeSlots.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlotsTableViewCell", for: indexPath) as! SlotsTableViewCell
        
        let isSelected = self.selectedSlotsIndexPath.contains(indexPath)
        cell.configure(timeSlot: self.slots[indexPath.section].timeSlots[indexPath.row], isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SlotsTableSectionHeader") as! SlotsTableSectionHeader
        
        header.configure(date: self.slots[section].date, isExpanded: self.slots[section].isExpanded ?? false)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderTapped(_:)))
                header.addGestureRecognizer(tapGestureRecognizer)
                header.tag = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedSlotsIndexPath.contains(indexPath) {
            self.selectedSlotsIndexPath.removeAll { cIndexPath in
                return cIndexPath == indexPath
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        
        if self.selectedSlotsIndexPath.count != 0 {
            if self.selectedSlotsIndexPath.contains(IndexPath(row: indexPath.row + 1, section: indexPath.section)) == false
                && self.selectedSlotsIndexPath.contains(IndexPath(row: indexPath.row - 1, section: indexPath.section)) == false
                && indexPath.section == lastSelectedSection {
                self.showSnackBar(message: "Please select consecutive slots")
                return
            }
        }
        
        let selectedDate = self.slots[indexPath.section].date
        let selectedSlot = self.slots[indexPath.section].timeSlots[indexPath.row]

        if self.selectedSlotsDictionary[selectedDate] != nil {
            self.selectedSlotsDictionary[selectedDate]?.append(selectedSlot)
        } else {
            self.selectedSlotsDictionary[selectedDate] = [selectedSlot]
        }
        
        self.selectedSlotsIndexPath.append(indexPath)
        self.lastSelectedSection = indexPath.section
        
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else {
            return
        }
        
        slots[section].isExpanded = !(slots[section].isExpanded ?? false)
        
        self.tableView.reloadSections(IndexSet(integer: section), with: .none)
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .middle, animated: true)
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
