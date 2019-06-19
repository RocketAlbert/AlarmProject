//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Albert Yu on 6/17/19.
//  Copyright © 2019 AlbertLLC. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTextField: UITextField!
    @IBOutlet weak var onButton: UIButton!
    

    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func enableButtonTapped(_ sender: UIButton) {
        if let alarm = alarm {
            AlarmController.shared.toggleEnabled(for: alarm)
            alarmIsOn = alarm.enabled
        }else{
            alarmIsOn = !alarmIsOn
        }
        setUpAlarmButton()
    }
    
    func setUpAlarmButton(){
        
        switch alarmIsOn {
        case true:
            onButton.backgroundColor = UIColor.blue
           onButton.setTitle("On", for: .normal)
        case false:
            onButton.backgroundColor = UIColor.gray
            onButton.setTitle("Off", for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = alarmTextField.text, title != "" else {return}
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: alarmDatePicker.date, name: title, enabled: alarmIsOn)
        } else {
           AlarmController.shared.addAlarm(fireDate: alarmDatePicker.date, name: title, enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func updateViews() {
        guard let alarm = alarm else {return}
        alarmIsOn = alarm.enabled
        alarmDatePicker.date = alarm.fireDate
        alarmTextField.text = alarm.name
        setUpAlarmButton()
    }
}
