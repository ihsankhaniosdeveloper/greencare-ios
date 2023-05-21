//
//  ScheduleAddViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import UIKit
import ActionSheetPicker_3_0

class ScheduleAddViewController: UIViewController {
    @IBOutlet weak var viewSelectSlots: DropDownView!
    @IBOutlet weak var viewSelectDate: DropDownView!
    @IBOutlet weak var viewTotalPlants: DropDownView!
    @IBOutlet weak var viewTotalHours: DropDownView!
    @IBOutlet weak var viewTotalPersons: UIView!
    
    @IBOutlet weak var lblSelectedAddress: UILabel!
    @IBOutlet weak var lblSelectedSlots: UILabel!
    
    private var presenter: ScheduleAddPresenterType!
        
    private var selectedAddress: Address?
    private var selectedSlots: [Slot]?
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
        
//        let vc = CartViewController(nibName: "CartViewController", bundle: .main)
//        self.navigationController?.pushViewController(vc, animated: true)
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
    func scheduleAddPresenter(scheduleRequestSuccess requestServiceResponse: RequestServiceResponse) {
        
    }
    
    func scheduleAddPresenter(scheduleRequestFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    
}
