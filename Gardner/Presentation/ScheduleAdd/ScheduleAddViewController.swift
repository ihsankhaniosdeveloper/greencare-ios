//
//  ScheduleAddViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import UIKit

class ScheduleAddViewController: UIViewController {
    private var presenter: ScheduleAddPresenterType!
    
    @IBOutlet weak var lblSelectDays: UITextField!
    @IBOutlet weak var lblSelectDate: UITextField!
    @IBOutlet weak var lblTotalPlants: UITextField!
    @IBOutlet weak var lblTotalHours: UITextField!
    @IBOutlet weak var lblTotalPersons: UITextField!
    
    static func make(presenter: ScheduleAddPresenterType) -> ScheduleAddViewController {
        let vc = ScheduleAddViewController(nibName: "ScheduleAddViewController", bundle: .main)
        vc.presenter = presenter
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Schedule"
        (self.presenter as! ScheduleAddPresenter).outputs = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func cancelButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        
    }
}

extension ScheduleAddViewController: ScheduleAddPresenterOutput {
    
}
