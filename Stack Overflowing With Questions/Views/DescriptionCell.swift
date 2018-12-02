//
//  DescriptionCell.swift
//  Stack Overflowing With Questions
//
//  Created by Andrew Olson on 12/1/18.
//  Copyright © 2018 Andrew Olson. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var displayNameLabel = UILabel()
    var profileImageView = UIImageView()
    var activityIndicator: UIActivityIndicatorView!
    var labelHeight: CGFloat!
    var labelwidth: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelHeight = (contentView.bounds.height / 3) - 8
        labelwidth = (contentView.bounds.width - 70)
        initCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initCell() {
        configActivityIndicator()
        configTitleLabel(title: "")
        configDisplayNameLabel(name: "")
        configureProfileImage(url: nil)
    }
    
    func configureCell(title: String, displayName: String, url: String) {
        // Clear the cell
        titleLabel.text = nil
        displayNameLabel.text = nil
        profileImageView.image = UIImage(named: "default_image")
        
        // Reconfigure the cell for new data
        configActivityIndicator()
        configTitleLabel(title: title)
        configDisplayNameLabel(name: displayName)
        let image_url = URL(string: url)
        configureProfileImage(url: image_url)
    }
    
    private func configActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = CGPoint(x: 25, y: center.y)
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func configTitleLabel(title: String) {
        let frame = CGRect(x: 50, y: 8, width: labelwidth, height: labelHeight)
        titleLabel = UILabel(frame: frame)
        titleLabel.text = title
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLabel)
    }
    
    private func configDisplayNameLabel(name: String) {
        let frame = CGRect(x: 50, y: labelHeight + 16, width: labelwidth, height: labelHeight)
        displayNameLabel = UILabel(frame: frame)
        displayNameLabel.text = name
        displayNameLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        displayNameLabel.numberOfLines = 1
        displayNameLabel.textAlignment = .left
        contentView.addSubview(displayNameLabel)
    }
    
    private func configureProfileImage(url: URL?) {
        let frame = CGRect(x: 10, y: 8, width: 30, height: 30)
        profileImageView = UIImageView(frame: frame)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 3
        
        contentView.addSubview(profileImageView)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        if let url = url {
            URLClient.loadProfileImage(url: url) { (image) in
                performUIUpdatesOnMain {
                    if let image = image {
                        self.profileImageView.image = image
                    } else {
                        self.profileImageView.image = UIImage(named: "default_image")
                    }
                    self.activityIndicator.stopAnimating()
                }

            }
        } else {
            self.profileImageView.image = UIImage(named: "default_image")
            activityIndicator.stopAnimating()
        }
    }
}
