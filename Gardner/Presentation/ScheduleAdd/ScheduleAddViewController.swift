//
//  ScheduleAddViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import UIKit
import ActionSheetPicker_3_0

class ScheduleAddViewController: UIViewController {
    @IBOutlet weak var viewSelectDays: DropDownView!
    @IBOutlet weak var viewSelectDate: DropDownView!
    @IBOutlet weak var viewTotalPlants: DropDownView!
    @IBOutlet weak var viewTotalHours: DropDownView!
    @IBOutlet weak var viewTotalPersons: DropDownView!
    
    private var presenter: ScheduleAddPresenterType!
    
    static func make(presenter: ScheduleAddPresenterType) -> ScheduleAddViewController {
        let vc = ScheduleAddViewController(nibName: "ScheduleAddViewController", bundle: .main)
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Schedule"
        (self.presenter as! ScheduleAddPresenter).outputs = self
        
        self.viewSelectDays.configure(title: "Select Days", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
        self.viewSelectDate.configure(title: "Select Date", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
        self.viewTotalPlants.configure(title: "", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
        self.viewTotalHours.configure(title: "", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
        self.viewTotalPersons.configure(title: "", data: [1, 2, 3, 4, 5, 6, 7, 8, 9], delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func cancelButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        let vc = CartViewController(nibName: "CartViewController", bundle: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ScheduleAddViewController: DropDownDelegate {
    func dropDown(itemSelected item: Int) {
        
    }
}

extension ScheduleAddViewController: ScheduleAddPresenterOutput {
    
}
