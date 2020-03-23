//
//  WeatherTableCell.swift
//  BlubDeveloperTest
//
//  Created by Marko Pranjić on 23/03/2020.
//  Copyright © 2020 Marko Pranjić. All rights reserved.
//

import UIKit

class WeatherTableCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
