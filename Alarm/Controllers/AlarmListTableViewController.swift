//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Albert Yu on 6/17/19.
//  Copyright © 2019 AlbertLLC. All rights reserved.
//

import UIKit



// The Intern
class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else {return UITableViewCell()}
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        // 3 Now a SwitchTableViewCell, this cell's delegate will be set as the AlarmListViewController. The "boss" has found its "intern".
        cell.alarm = alarm
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
         
    }

    // Implemented as part of the protocol.
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleEnabled(for: alarm)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? AlarmDetailTableViewController else {return}
            let alarm = AlarmController.shared.alarms[indexPath.row]
            destinationVC.alarm = alarm
        }
    }
  

}
