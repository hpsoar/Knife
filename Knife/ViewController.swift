//
//  ViewController.swift
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

import UIKit

class DateView: UIView {
    var solarDateView: UIView!
    var lunarDateView: UIView!
    var weekLabel: UILabel!
    var yearLabel: UILabel!
    var dateLabel: UILabel!
    var lunarDateLabel: UILabel!
    
     init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    func weekString(week: NSInteger) -> String {
        let weekString = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        return weekString[week - 1]
    }
    
    func setup() {
        let date = NSDate()
        /*
         * ---------------------------
         * solar date:  week
         *              ----  month / day
         *              year
         * ---------------------------
         * lunar date:  month day
         * ---------------------------
         */
    
        solarDateView = UIView(frame: CGRectMake(0, 0, 110, 44))
        solarDateView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(solarDateView)
        
        weekLabel = UILabel(frame: CGRectMake(4, 3, 30, solarDateView.frame.height / 2))
        weekLabel.font = UIFont.systemFontOfSize(12)
        weekLabel.textColor = UIColor.whiteColor()
        
        yearLabel = UILabel(frame: CGRectMake(4, weekLabel.frame.height - 3, 30, solarDateView.frame.height / 2))
        yearLabel.font = UIFont.systemFontOfSize(12)
        yearLabel.textColor = UIColor.whiteColor()
        
        weekLabel.text = self.weekString(date.week)
        yearLabel.text = String(date.year)
        
        solarDateView.addSubview(weekLabel)
        solarDateView.addSubview(yearLabel)
        
        dateLabel = UILabel(frame: CGRectMake(40, 0, solarDateView.frame.width - weekLabel.frame.width, solarDateView.frame.height))
        dateLabel.font = UIFont.systemFontOfSize(28)
        dateLabel.text = String(date.month) + "/" + String(date.day)
        dateLabel.textColor = UIColor.whiteColor()
        
        solarDateView.addSubview(dateLabel)
        
        lunarDateView = UIView(frame: CGRectMake(0, solarDateView.frame.origin.y + solarDateView.frame.height, 110, 22))
        lunarDateView.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        
        self.addSubview(lunarDateView)
        
        var lunarDate = LunarDate(date: date)
        lunarDateLabel = UILabel(frame: CGRectMake(4, 0, lunarDateView.frame.width, lunarDateView.frame.height))
        lunarDateLabel.text = "农历 \(lunarDate.monthString)月\(lunarDate.dayString)"
        lunarDateLabel.textColor = UIColor.whiteColor()
        lunarDateLabel.font = UIFont.systemFontOfSize(12)

        lunarDateView.addSubview(lunarDateLabel)
    }
}

class ViewController: UIViewController, WeatherUtilityDelegate {
    var backgroundImageView: UIImageView?
    var scrollView: UIScrollView?
    var dateView: DateView?
    
    var imageNames: NSString[] = NSString[]()
    
    let weatherUtility = YahooWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageNames = [ "nature-wallpaper-beach-wallpapers-delightful-tropical-images_Beaches_wallpapers_196.jpg" ]
        var image = UIImage(named: imageNames[0])
        image = image.applyBlurWithRadius(40, tintColor:nil, saturationDeltaFactor: 0.85, maskImage: nil, atFrame:CGRectMake(0, 0, image.size.width, image.size.height))
        backgroundImageView = UIImageView(image: image)
        backgroundImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView!.frame = self.view.bounds

        self.view.addSubview(backgroundImageView!)
        
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView!.alwaysBounceVertical = true
        
        self.view.addSubview(scrollView!)
        
        dateView = DateView(frame: CGRectMake(0, 20, 320, 44))
        self.view.addSubview(dateView!)
        
        weatherUtility.delegate = self
        weatherUtility.updateWeather("Beijing")
        weatherUtility.updatePM10("beijing")
        weatherUtility.updatePM2_5("beijing")
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
                
    }
    
    func geometricLocationUpdated()  {
        println("hello")
    }
    
    func weatherUpdated()  {
        
    }
    
    func pm10Updated()  {
        
    }
    
    func pm2_5Updated()  {
    }
}

