//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Albert Yu on 6/17/19.
//  Copyright © 2019 AlbertLLC. All rights reserved.
//


// The Boss

import UIKit

// 1 Step one is declaring the protocol
protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}


class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // 2 We declare this variable titled "delegate" which will be assigned in the TableViewController as itself.
    weak var delegate: SwitchTableViewCellDelegate?
    
    
    var alarm: Alarm? {
        didSet{
            updateViews()
        } 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(cell: self) // 4 This is the delegate set in the TableViewController. This is the TableViewController doing the work for us. The "intern" has returned and is now excuting the work for the boss.
    }
    
    
    func updateViews(){
        guard let alarm = alarm else {return}
        
        nameLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }

  
    
}
