//
//  DetailCell.swift
//  Devskiller
//
//  Created by Anderson Franco on 27/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class DetailCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // ImageView
    lazy var imageViewPatch: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        return imageView
    }()
    
    // ImageView
    lazy var imageViewCheck: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .init(systemName: "checkmark.circle")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    lazy var imageViewInfo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .init(systemName: "info.circle")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    // Mission
    lazy var labelMissionKey: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines =  0
        label.textAlignment = .right
        return label
    }()
    
    lazy var labelMissionValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines =  0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // Datetime
    lazy var labelDateTimeKey: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    lazy var labelDateTimeValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // Rocket
    lazy var labelRocketKey: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    lazy var labelRocketValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // Days count
    lazy var labelDaysCountKey: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    lazy var labelDaysCountValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    func setUpViews() {
        contentView.addSubview(imageViewPatch)
        imageViewPatch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        imageViewPatch.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        imageViewPatch.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageViewPatch.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        contentView.addSubview(imageViewCheck)
        imageViewCheck.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        imageViewCheck.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        imageViewCheck.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageViewCheck.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(imageViewInfo)
        imageViewInfo.topAnchor.constraint(equalTo: imageViewCheck.bottomAnchor, constant: 16).isActive = true
        imageViewInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        imageViewInfo.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageViewInfo.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(labelMissionKey)
        labelMissionKey.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        labelMissionKey.leadingAnchor.constraint(equalTo: imageViewPatch.trailingAnchor, constant: 8).isActive = true
        labelMissionKey.widthAnchor.constraint(equalToConstant: 80).isActive = true
        labelMissionKey.text = "Mission:"
        
        contentView.addSubview(labelMissionValue)
        labelMissionValue.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        labelMissionValue.leadingAnchor.constraint(equalTo: labelMissionKey.trailingAnchor, constant: 8).isActive = true
        labelMissionValue.trailingAnchor.constraint(equalTo: imageViewCheck.leadingAnchor, constant: -8).isActive = true
        let labelMissionHeightAnchor = labelMissionValue.heightAnchor.constraint(equalToConstant: 24)
        labelMissionHeightAnchor.priority = .defaultLow
        labelMissionHeightAnchor.isActive = true
        
        contentView.addSubview(labelDateTimeKey)
        labelDateTimeKey.topAnchor.constraint(equalTo: labelMissionValue.bottomAnchor, constant: 8).isActive = true
        labelDateTimeKey.leadingAnchor.constraint(equalTo: imageViewPatch.trailingAnchor, constant: 8).isActive = true
        labelDateTimeKey.widthAnchor.constraint(equalToConstant: 80).isActive = true
        labelDateTimeKey.text = "Date / Time:"
        
        contentView.addSubview(labelDateTimeValue)
        labelDateTimeValue.topAnchor.constraint(equalTo: labelMissionValue.bottomAnchor, constant: 8).isActive = true
        labelDateTimeValue.leadingAnchor.constraint(equalTo: labelDateTimeKey.trailingAnchor, constant: 8).isActive = true
        labelDateTimeValue.trailingAnchor.constraint(equalTo: imageViewCheck.leadingAnchor, constant: -8).isActive = true
        labelDateTimeValue.heightAnchor.constraint(greaterThanOrEqualTo: labelDateTimeKey.heightAnchor).isActive = true
        
        let labelDateTimeHeightAnchor = labelDateTimeValue.heightAnchor.constraint(equalToConstant: 24)
        labelDateTimeHeightAnchor.priority = .defaultLow
        labelDateTimeHeightAnchor.isActive = true
        
        contentView.addSubview(labelRocketKey)
        labelRocketKey.topAnchor.constraint(equalTo: labelDateTimeValue.bottomAnchor, constant: 8).isActive = true
        labelRocketKey.leadingAnchor.constraint(equalTo: imageViewPatch.trailingAnchor, constant: 8).isActive = true
        labelRocketKey.widthAnchor.constraint(equalToConstant: 80).isActive = true
        labelRocketKey.text = "Rocket:"
        
        contentView.addSubview(labelRocketValue)
        labelRocketValue.topAnchor.constraint(equalTo: labelDateTimeValue.bottomAnchor, constant: 8).isActive = true
        labelRocketValue.leadingAnchor.constraint(equalTo: labelRocketKey.trailingAnchor, constant: 8).isActive = true
        labelRocketValue.trailingAnchor.constraint(equalTo: imageViewCheck.leadingAnchor, constant: -8).isActive = true
        let labelRocketHeightAnchor = labelRocketValue.heightAnchor.constraint(equalToConstant: 24)
        labelRocketHeightAnchor.priority = .defaultLow
        labelRocketHeightAnchor.isActive = true
        
        contentView.addSubview(labelDaysCountKey)
        labelDaysCountKey.topAnchor.constraint(equalTo: labelRocketValue.bottomAnchor, constant: 8).isActive = true
        labelDaysCountKey.leadingAnchor.constraint(equalTo: imageViewPatch.trailingAnchor, constant: 8).isActive = true
        labelDaysCountKey.widthAnchor.constraint(equalToConstant: 80).isActive = true
        labelDaysCountKey.text = "Days:"
        
        contentView.addSubview(labelDaysCountValue)
        labelDaysCountValue.topAnchor.constraint(equalTo: labelRocketValue.bottomAnchor, constant: 8).isActive = true
        labelDaysCountValue.leadingAnchor.constraint(equalTo: labelDaysCountKey.trailingAnchor, constant: 8).isActive = true
        labelDaysCountValue.trailingAnchor.constraint(equalTo: imageViewCheck.leadingAnchor, constant: -8).isActive = true
        labelDaysCountValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        let labelDaysHeightAnchor = labelDaysCountValue.heightAnchor.constraint(equalToConstant: 24)
        labelDaysHeightAnchor.priority = .defaultLow
        labelDaysHeightAnchor.isActive = true
    }
    
    override func prepareForReuse() {
        self.imageViewPatch.image = nil
        self.imageViewCheck.image = nil 
        self.imageViewInfo.isHidden = true
    }
    
    func load(with layoutViewModel: LaunchLayoutViewModel?) {
        imageViewPatch.sd_setImage(with: URL(string: layoutViewModel?.pathString ?? ""), placeholderImage: UIImage(named: "spacex-icon")?.withTintColor(.label))
        
        imageViewCheck.image = UIImage(systemName: layoutViewModel?.succeed ?? false ? "checkmark.circle" : "x.circle")
        imageViewCheck.tintColor = layoutViewModel?.succeed ?? false ? .systemGreen : .systemRed
        
        imageViewInfo.isHidden = !(layoutViewModel?.hasLink ?? false)
        
        labelMissionValue.text = layoutViewModel?.missionName ?? ""
        labelRocketValue.text = layoutViewModel?.rocketString ?? ""
        labelDateTimeValue.text = layoutViewModel?.launchDateTimeString ?? ""
        labelDaysCountValue.text = layoutViewModel?.daysInString ?? ""
    }
}
