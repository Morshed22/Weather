//
//  WeeklyTableViewCell.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
   
    
    
    func configureCell(_ temp:String?, time:String?, des:String?){
        self.cityDegreesLabel.text = temp
        self.dateLabel.text = time
        self.weatherMessageLabel.text = des
    }
    
//    var viewModel: WeeklyCellViewModel? {
//        didSet {
//            bindViewModel()
//        }
//    }
//
//    private func bindViewModel() {
//
//        if let temp = viewModel?.tempStr{
//            cityDegreesLabel.text = temp
//        }
//        if let msg = viewModel?.msg {
//            print(msg)
//           weatherMessageLabel.text = msg
//        }
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
