//
//  ScheduleAddViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import UIKit
import ActionSheetPicker_3_0

class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}

class ScheduleAddViewController: UIViewController {
    @IBOutlet weak var viewSelectSlots: DropDownView!
    @IBOutlet weak var viewSelectDate: DropDownView!
    @IBOutlet weak var viewTotalPlants: DropDownView!
    @IBOutlet weak var viewTotalHours: DropDownView!
    @IBOutlet weak var viewTotalPersons: UIView!
    
    @IBOutlet weak var lblSelectedAddress: UILabel!
    @IBOutlet weak var lblSelectedSlots: UILabel!
    
    @IBOutlet weak var selectedSlotsTableView: ContentSizedTableView!
    private var presenter: ScheduleAddPresenterType!
        
    private var selectedAddress: Address?
    private var selectedSlots: [Slot] = []
    private var serviceId: String?
    
    static func make(presenter: ScheduleAddPresenterType, serviceId: String?) -> ScheduleAddViewController {
        let vc = ScheduleAddViewController(nibName: "ScheduleAddViewController", bundle: .main)
        
        vc.presenter = presenter
        vc.serviceId = serviceId
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Schedule"
        (self.presenter as! ScheduleAddPresenter).outputs = self
        
        self.viewSelectDate.isHidden = true //configure(title: "Select Date", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
        self.viewTotalPlants.isHidden = true //configure(title: "", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
        self.viewTotalHours.isHidden = true //configure(title: "", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAddressTapped(_ :)))
        viewTotalPersons.addGestureRecognizer(tapGesture)
        
        let tapGestureSelectSlot = UITapGestureRecognizer(target: self, action: #selector(selectSlotsTap(_ :)))
        viewSelectSlots.addGestureRecognizer(tapGestureSelectSlot)
        
        self.selectedSlotsTableView.register(UINib(nibName: "SelectedSlotsTableViewCell", bundle: .main), forCellReuseIdentifier: "SelectedSlotsTableViewCell")
        
        self.selectedSlotsTableView.delegate = self
        self.selectedSlotsTableView.dataSource = self
        
        self.selectedSlotsTableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func cancelButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        self.presenter.requestService(addressId: self.selectedAddress?.id, serviceId: serviceId, slots: self.selectedSlots)
    }
    
    @objc func selectAddressTapped(_ sender: UITapGestureRecognizer) {
        let addressListingVC = AddressListingViewController.make(presenter: AddressListingPresenter(service: AddressService(apiClient: APIClient(session: .default))), isPresented: true)
        
        let navVC = UINavigationController(rootViewController: addressListingVC)
        navVC.modalPresentationStyle = .fullScreen
        
        addressListingVC.addressSelected = { [weak self] address in
            self?.lblSelectedAddress.text = address.instructions
            self?.selectedAddress = address
        }

        
        self.present(navVC, animated: true)
    }
    
    @objc func selectSlotsTap(_ sender: UITapGestureRecognizer) {
        let slotListingVC = SlotListingViewController.make(presenter: SlotListingPresenter(service: SlotService(apiClient: APIClient(session: .default))))
        
        let navVC = UINavigationController(rootViewController: slotListingVC)
        navVC.modalPresentationStyle = .fullScreen
        
        slotListingVC.selectedSlotsHandler = { [weak self] slots in
            self?.selectedSlots = slots
            self?.lblSelectedSlots.text = "Slots selected"
            self?.selectedSlotsTableView.reloadData()
        }

        self.present(navVC, animated: true)
    }
    
    @objc func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ScheduleAddViewController: DropDownDelegate {
    func dropDown(itemSelected item: Int) {
        
    }
}

extension ScheduleAddViewController: ScheduleAddPresenterOutput {
    func scheduleAddPresenter(scheduleRequestSuccess requestServiceResponse: ServiceRequest) {
        let vc = CartViewController.make(serviceRequest: requestServiceResponse)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scheduleAddPresenter(scheduleRequestValidationFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func scheduleAddPresenter(scheduleRequestFailed message: String) {
        self.showSnackBar(message: message)
    }
}

extension ScheduleAddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedSlotsTableViewCell", for: indexPath) as! SelectedSlotsTableViewCell
        
        cell.configure(slot: self.selectedSlots[indexPath.row])
        return cell
    }
}
//extension ScheduleAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.selectedSlots.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedSlotCollectionViewCell", for: indexPath) as! SelectedSlotCollectionViewCell
//        
//        cell.configure(date: self.selectedSlots[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24)
//    }
//
//}
