//
//  AirQualityView.swift
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

import UIKit

class AirQualityView: UIView {
    var aqiLabel: UILabel
    
    init(frame: CGRect) {
        aqiLabel = UILabel(frame: CGRectMake(20, 20, 50, 50))
        super.init(frame: frame)
        
        self.setup()
    }
    
    func setup() {
        aqiLabel.font = UIFont.systemFontOfSize(48)
        aqiLabel.textColor = UIColor.whiteColor()
        
        self.addSubview(aqiLabel)
    }

    func updateWithAQI(aqi: AQI) {
        aqiLabel.text = String(aqi.aqi)
    }
}
