//
//  ScheduleAddViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import UIKit
import HMSegmentedControl

class ScheduleAddViewController: UIViewController {
    @IBOutlet weak var viewSelectAddress: UIView!
    @IBOutlet weak var lblSelectedAddress: UILabel!
    @IBOutlet weak var segmentedView: HMSegmentedControl!
    @IBOutlet weak var selectedSlotsCollectionView: UICollectionView!
    
    private var presenter: ScheduleAddPresenterType!
    
    // Available slots
    private var availableSlots: [Slot] = []
    private var selectedAddress: Address?
    private var service: Service?
    
    private var selectedSlots: [Slot] = []
    private var selectedDateIndex = 0
    private var selectedSlotsIndexes: [IndexPath] = []
    private var selectedSlotsDictionary: [Date: [Date]] = [:]
    
    private let cellIdentifier = "SelectedSlotCollectionViewCell"
    
    static func make(presenter: ScheduleAddPresenterType, service: Service) -> ScheduleAddViewController {
        let vc = ScheduleAddViewController(nibName: "ScheduleAddViewController", bundle: .main)
        
        vc.presenter = presenter
        vc.service = service
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Schedule"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        (self.presenter as! ScheduleAddPresenter).outputs = self
        
        
        self.selectedSlotsCollectionView.delegate = self
        self.selectedSlotsCollectionView.dataSource = self
        
        self.selectedSlotsCollectionView.register(UINib(nibName: cellIdentifier, bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
        
        
        segmentedView.backgroundColor = UIColor(named: "GreyColor")!
        segmentedView.selectionStyle = .box
        segmentedView.selectionIndicatorBoxColor = UIColor(named: "primaryColor")!
        segmentedView.selectionIndicatorColor = UIColor(named: "primaryColor")!
        segmentedView.selectionIndicatorBoxOpacity = 1.0
        
        segmentedView.indexChangeBlock = { index in
            self.selectedDateIndex = Int(index)
            self.selectedSlotsCollectionView.reloadData()
        }
        
        self.viewSelectAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.navigateToAddressListing(_ :))))
    }
    
    @objc func navigateToAddressListing(_ sender: UITapGestureRecognizer) {
        let addressListingVC = AddressListingViewController.make(presenter: AddressListingPresenter(service: AddressService(apiClient: APIClient(session: .default))), isPresented: true)
        
        let navVC = UINavigationController(rootViewController: addressListingVC)
        navVC.modalPresentationStyle = .fullScreen
        
        addressListingVC.addressSelected = { [weak self] selectedAddress in
            self?.lblSelectedAddress.text = selectedAddress.instructions
            self?.selectedAddress = selectedAddress
        }

        self.present(navVC, animated: true)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.presenter.getServiceSlots(serviceId: self.service?.id, serviceType: self.service?.type)
    }
    
    @IBAction func cancelButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        let selectedSlots: [Slot] = self.selectedSlotsDictionary.map { Slot(date: $0, timeSlots: $1) }
        self.presenter.calculateAmount(addressId: self.selectedAddress?.id, serviceId: service?.id, slots: selectedSlots)
    }
    
    @objc func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension ScheduleAddViewController: ScheduleAddPresenterOutput {
    func scheduleAddPresenter(scheduleRequestSuccess requestServiceResponse: CalculateAmountResponse) {
        let selectedSlots: [Slot] = self.selectedSlotsDictionary.map { Slot(date: $0, timeSlots: $1) }
        let vc = CartViewController.make(serviceRequest: requestServiceResponse, selectedSlots: selectedSlots)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scheduleAddPresenter(slotsFetchingSuccess slots: [Slot]) {
        let titles: [String] = slots.map { $0.date.toDateString(format: "dd MMM yyyy") }
        segmentedView.sectionTitles = titles
        self.availableSlots = slots
        
        self.selectedSlotsCollectionView.reloadData()
    }
    
    func scheduleAddPresenter(operationFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func scheduleAddPresenter(scheduleRequestValidationFailed message: String) {
        self.showSnackBar(message: message)
    }
}


extension ScheduleAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.availableSlots.isEmpty {
            return 0
        }
        
        return availableSlots[selectedDateIndex].timeSlots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SelectedSlotCollectionViewCell

        let selectedDate = availableSlots[selectedDateIndex].date
        let selectedTimeSlot = availableSlots[selectedDateIndex].timeSlots[indexPath.row]
        
        // remove item
        let isSelected = self.selectedSlotsDictionary[selectedDate] != nil && self.selectedSlotsDictionary[selectedDate]?.contains(selectedTimeSlot) == true
        cell.configure(timeSlot: self.availableSlots[selectedDateIndex].timeSlots[indexPath.row], isSelected: isSelected, minHours: self.service?.minHours ?? 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 32) / 2, height: 45)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSlot = availableSlots[self.selectedDateIndex]

        let selectedDate = selectedSlot.date
        let selectedTimeSlot = selectedSlot.timeSlots[indexPath.row]

        // remove item
        if let test = self.selectedSlotsDictionary[selectedDate], test.contains(selectedTimeSlot) {
            self.selectedSlotsDictionary[selectedDate]?.removeAll(where: { cDate in
                return cDate == selectedTimeSlot
            })
            self.selectedSlotsCollectionView.reloadItems(at: [indexPath])
            return
        }

        // Add item
        if self.selectedSlotsDictionary[selectedDate] != nil && self.selectedSlotsDictionary[selectedDate]?.isEmpty == false {
            self.selectedSlotsDictionary[selectedDate]?.append(selectedTimeSlot)
        } else {
            self.selectedSlotsDictionary[selectedDate] = [selectedTimeSlot]
        }

        self.selectedSlotsCollectionView.reloadItems(at: [indexPath])
    }
}
