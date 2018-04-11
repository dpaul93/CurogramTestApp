//
//  ListTableViewCell.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 10.04.18.
//Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupValueLabel()
        setupPositionLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupValueLabelLayer()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//    }
    
    func populate(with viewModel: ListTableViewCellViewModel) {
        let themeColor = UIColor(hexString: viewModel.color)
        valueLabel.text = String(viewModel.value)
        valueLabel.textColor = themeColor
        valueLabel.layer.borderColor = themeColor.cgColor
        
        positionLabel.text = viewModel.position
    }

    // MARK: - Helpers
    
    private func setupValueLabel() {
        valueLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        valueLabel.textAlignment = .center
    }
    
    private func setupPositionLabel() {
        positionLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        positionLabel.textColor = .lightGray
        positionLabel.textAlignment = .right
    }
    
    private func setupValueLabelLayer() {
        valueLabel.layer.cornerRadius = valueLabel.bounds.width / 2
        valueLabel.layer.borderWidth = 1
    }
}
