//
//  LaunchTableViewCell.swift
//  Devskiller
//
//  Created by Anderson Franco on 27/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import UIKit

class LaunchTableViewCell: UITableViewCell {
    @IBOutlet weak var patchImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var labelMission: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRocket: UILabel!
    @IBOutlet weak var labelDaysValue: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func load(layoutViewModel: LaunchLayoutViewModel?) {
        guard let layoutViewModel = layoutViewModel else { return }
        
        self.labelMission.text = layoutViewModel.missionName
        self.labelDate.text = layoutViewModel.launchDateTimeString
        self.labelRocket.text = layoutViewModel.rocketString
        self.labelDaysValue.text = layoutViewModel.daysInString
    }
}
