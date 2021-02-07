//
//  BookCell.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 07.02.2021.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cellImageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
        priceLabel.text = ""
    }
}
