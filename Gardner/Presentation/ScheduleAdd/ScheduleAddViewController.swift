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
    @IBOutlet weak var slotsCollectionView: UICollectionView!
    
    private var presenter: ScheduleAddPresenterType!
    
    // Available slots
    private var availableSlots: [Slot] = []
    private var selectedAddress: Address?
    private var service: Service!
    
    private var selectedSlots: [Slot] = []
    private var selectedDateIndex = 0
    private var selectedSlotsIndexes: [IndexPath] = []
    private var selectedSlotsDictionary: [Date: [Date]] = [:]
    
    private var isLoadingCompleted: Bool = false
    private lazy var slotsLoader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.hidesWhenStopped = true
        view.style = .large
        view.color = UIColor(named: "primaryColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
        
        
        self.slotsCollectionView.delegate = self
        self.slotsCollectionView.dataSource = self
        
        self.slotsCollectionView.register(UINib(nibName: cellIdentifier, bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
        
        
        segmentedView.backgroundColor = UIColor(named: "GreyColor")!
        segmentedView.selectionStyle = .box
        segmentedView.selectionIndicatorBoxColor = UIColor(named: "primaryColor")!
        segmentedView.selectionIndicatorColor = UIColor(named: "primaryColor")!
        segmentedView.selectionIndicatorBoxOpacity = 1.0
        
        segmentedView.indexChangeBlock = { index in
            self.selectedDateIndex = Int(index)
            self.slotsCollectionView.reloadData()
        }
        
        self.viewSelectAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.navigateToAddressListing(_ :))))
        
        // MARK: Fetch slots
        self.presenter.getServiceSlots(serviceId: self.service?.id, serviceType: self.service?.type.rawValue)
        
        self.view.addSubview(self.slotsLoader)
        
        slotsLoader.centerXAnchor.constraint(equalTo: self.slotsCollectionView.centerXAnchor).isActive = true
        slotsLoader.centerYAnchor.constraint(equalTo: self.slotsCollectionView.centerYAnchor).isActive = true
    }
    
    @objc func navigateToAddressListing(_ sender: UITapGestureRecognizer) {
        let addressListingVC = AddressListingViewController.make(presenter: AddressListingPresenter(service: AddressService(apiClient: APIClient(session: .default))), isPresented: true)
        
        let navVC = UINavigationController(rootViewController: addressListingVC)
        navVC.modalPresentationStyle = .fullScreen
        
        addressListingVC.addressSelected = { [weak self] selectedAddress in
            self?.lblSelectedAddress.text = selectedAddress.completeAddress
            self?.selectedAddress = selectedAddress
        }

        self.present(navVC, animated: true)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
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
        guard let selectedAddressId = self.selectedAddress?.id else {
            self.showSnackBar(message: "Plese select the address and then continue ...")
            return
        }
        
        let sortedSelectedSlots: [Slot] = self.selectedSlotsDictionary.map { Slot(date: $0, timeSlots: $1) }
        
        let vc = CartViewController.make(
            presenter: CartPresenter(
                service: ServicesService(apiClient: APIClient(session: .default)),
                selectedSlots: sortedSelectedSlots,
                paymentService: paymentService(apiClient: APIClient(session: .default)),
                selectedServiceId: self.service.id,
                selectedAddressId: selectedAddressId
            ),
            calculateAmoutResponse: requestServiceResponse
        )
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scheduleAddPresenter(slotsFetchingSuccess slots: [Slot]) {
        let titles: [String] = slots.map { $0.date.toDateString(format: "dd MMM yyyy") }
        segmentedView.sectionTitles = titles
        self.availableSlots = slots
        
        isLoadingCompleted = true
        self.slotsCollectionView.reloadData()
    }
    
    func scheduleAddPresenter(operationFailed message: String) {
        isLoadingCompleted = true
        slotsCollectionView.reloadData()
        self.showSnackBar(message: message)
    }
    
    func scheduleAddPresenter(scheduleRequestValidationFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func startNonblockingLoading() {
        self.slotsLoader.startAnimating()
    }
    
    func stopNonblockingLoading() {
        self.slotsLoader.stopAnimating()
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
}


extension ScheduleAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.availableSlots.isEmpty || self.availableSlots[selectedDateIndex].timeSlots.isEmpty) && isLoadingCompleted {
            return 1
        }
        
        return availableSlots.count > selectedDateIndex ? availableSlots[selectedDateIndex].timeSlots.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SelectedSlotCollectionViewCell
        
        if (self.availableSlots.isEmpty || self.availableSlots[selectedDateIndex].timeSlots.isEmpty) && isLoadingCompleted {
            cell.configureForEmptyView()
            
            return cell
        }

        let selectedDate = availableSlots[selectedDateIndex].date
        let selectedTimeSlot = availableSlots[selectedDateIndex].timeSlots[indexPath.row]
        
        // remove item
        let isSelected = self.selectedSlotsDictionary[selectedDate] != nil && self.selectedSlotsDictionary[selectedDate]?.contains(selectedTimeSlot) == true
        cell.configure(timeSlot: self.availableSlots[selectedDateIndex].timeSlots[indexPath.row], isSelected: isSelected, minHours: self.service?.minHours ?? 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.availableSlots.isEmpty || self.availableSlots[selectedDateIndex].timeSlots.isEmpty {
            return CGSize(width: collectionView.frame.width - 32, height: 45)
        }
        return CGSize(width: (collectionView.frame.width - 32) / 2, height: 45)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.availableSlots.isEmpty || self.availableSlots[selectedDateIndex].timeSlots.isEmpty {
            return
        }
        
        
        let selectedSlot = availableSlots[self.selectedDateIndex]

        let selectedDate = selectedSlot.date
        let selectedTimeSlot = selectedSlot.timeSlots[indexPath.row]

        // remove item
        if let test = self.selectedSlotsDictionary[selectedDate], test.contains(selectedTimeSlot) {
            self.selectedSlotsDictionary[selectedDate]?.removeAll(where: { cDate in
                return cDate == selectedTimeSlot
            })
            self.slotsCollectionView.reloadItems(at: [indexPath])
            return
        }

        // Add item
        if self.selectedSlotsDictionary[selectedDate] != nil && self.selectedSlotsDictionary[selectedDate]?.isEmpty == false {
            self.selectedSlotsDictionary[selectedDate]?.append(selectedTimeSlot)
        } else {
            self.selectedSlotsDictionary[selectedDate] = [selectedTimeSlot]
        }

        self.slotsCollectionView.reloadItems(at: [indexPath])
    }
}
