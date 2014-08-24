//
//  WeatherUtility.swift
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

import UIKit
import CoreLocation

extension GDataXMLElement {
    override func nodesForXPath(xpath: String!, namespaces: NSDictionary!, error: NSErrorPointer) -> AnyObject[]! {
        let result = super.nodesForXPath(xpath, namespaces: namespaces, error: error)
        println("\(result)")
        return result
    }
}

class PM2_5Info : NSObject {
    
}

class PM10Info : NSObject {
    
}

class ForeCast: NSObject {
    var date: NSDate = NSDate()
    var day: String = ""
    var temperature: Float = 0
    var temperatureHigh: Float = 0
    var temperatureLow: Float = 0
    var code: Int = 0
    var desc: String = ""
}

class WeatherInfo : NSObject {
    var pubDate: NSDate = NSDate()
    var updateDate: NSDate = NSDate()
    
    var locationCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var city: String = ""
    var country: String = ""
    var region: String = ""
    
    var humidity: Float = 0
    var visibility: Float = 0
    var pressure: Float = 0
    var pressureSstate: Int = 0
    
    var windChill: Float = 0
    var windDirection: Float = 0
    var windSpeed: Float = 0
    
    var sunrise: NSDate = NSDate()
    var sunset: NSDate = NSDate()
    
    var condition: ForeCast = ForeCast()
    var forecasts: ForeCast[] = ForeCast[]()
}

class AQI : NSObject {
    var type = ""
    var area = ""
    var positionName = ""
    var primaryPollutant = ""
    var quality = ""
    var stationCode = ""
    var time: NSDate = NSDate()
    var aqi: Float = 0
    var aqi_24h: Float = 0
}

protocol WeatherUtilityDelegate {
    func weatherUpdated()
    func pm2_5Updated()
    func pm10Updated()
}

class WeatherUtility: NSObject {
    var delegate: WeatherUtilityDelegate?
    var weatherInfo = WeatherInfo()
    var pm2_5Info = AQI[]()
    var pm10Info = AQI[]()
    
    // pm2.5
    // eg. beijing
    func updatePM2_5(city: String) {
        let url = "http://www.pm25.in/api/querys/pm2_5.json"
        let params = [ "city": city, "token": "5j1znBVAsnSf5xQyNQyq" ]
        
        self.fetchData(url, params: params, serializer: "json", callback: self.processPM2_5Object)
    }
    
    // eg. beijing
    func updatePM10(city: String) {
        let url = "http://www.pm25.in/api/querys/pm10.json"
        let params = [ "city": city, "token": "5j1znBVAsnSf5xQyNQyq" ]
        self.fetchData(url, params: params, serializer: "json", callback: self.processPM10Object)
    }
    
    // weather info
    
    func updateWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["lat": "\(latitude)", "lon":"\(longitude)", "cnt": "\(0)" ]
    
        self.fetchData(url, params: params, serializer: "json", callback: self.processWeatherObject)
    }
    
    func updateWeather(city: String) {
        
    }
    
    func fetchData(url: String, params: Dictionary<String, String>, serializer: String, callback: (AnyObject) -> Void) {
        println(url)
        println(params)
        
        let manager = AFHTTPRequestOperationManager()
        
        switch serializer {
        case "json":
            println("json")
        case "xml":
            manager.responseSerializer = AFGDataXMLResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: [ "application/rss+xml"])
        default:
            println("")
        }
        
        manager.GET(url, parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                println("response: " + responseObject.description)
                
                callback(responseObject)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                
                println("Error: " + error.localizedDescription)
                
                //self.loading.text = "Internet appears down!"
            })

    }

    func processWeatherObject(object: AnyObject!) {
        
    }
    
    func processPM2_5Object(object: AnyObject!) {
        self.processAQI("pm2_5", object: object)
    }
    
    func processPM10Object(object: AnyObject!) {
        self.processAQI("pm10", object: object)
    }
    
    func processAQI(type: String, object: AnyObject!) {
        let items = object as NSArray
        var aqis = AQI[]()
        for item: AnyObject in items {
            let aqiData = item as NSDictionary
            println("\(aqiData)")
            var aqi = AQI()
            aqi.type = type
            aqi.area = aqiData["area"] as String
            aqi.aqi = aqiData["\(type)"] as Float
            aqi.aqi_24h = aqiData["\(type)_24h"] as Float
            aqi.quality = aqiData["quality"] as String
            
            if let positionName = aqiData["position_name"] as? String {
                aqi.positionName = positionName
            }
            
            if let stationCode = aqiData["station_code"] as? String {
                aqi.stationCode = stationCode
            }
            
            if let pollutant = aqiData["primary_pollutant"] as? String {
                aqi.primaryPollutant = pollutant
            }
//            aqi.time =
            println("\(aqi.primaryPollutant)")
        }
    }
}

class YahooWeather: WeatherUtility {
    func woeidForCity(city: String) -> String? {
        return "2151330"
    }
    
    override func updateWeather(city: String)  {
        let woeid = self.woeidForCity(city)
        if (woeid != nil) {
            let url = "http://weather.yahooapis.com/forecastrss"
            let params = [ "w": woeid!, "u": "c" ]
            self.fetchData(url, params: params, serializer: "xml", callback: self.processWeatherObject)
        }
    }
    
    func elements(root: GDataXMLElement, path: NSString) -> AnyObject[]! {
        let ns = [ "yweather": "http://xml.weather.yahoo.com/ns/rss/1.0"]
        var error: NSError?
        let element = root.nodesForXPath(path, namespaces: ns, error: &error)
        if (error != nil) {
            println("\(error)")
            return []
        }
        else {
            return element
        }
    }
    
    func element(root: GDataXMLElement, path: NSString) -> GDataXMLElement! {
        var elements = self.elements(root, path: path)
        if elements.count > 0 {
            return elements[0] as GDataXMLElement
        }
        else {
            return nil
        }
    }
    
    override func processWeatherObject(object: AnyObject!)  {
        /*
        <yweather:location city="Beijing" region="" country="China"/>
        <yweather:units temperature="C" distance="km" pressure="mb" speed="km/h"/>
        <yweather:wind chill="22" direction="340" speed="17.7"/>
        <yweather:atmosphere humidity="83" visibility="9.99" pressure="982.05" rising="0"/>
        <yweather:astronomy sunrise="5:31 am" sunset="6:58 pm"/>
        */
        let xml = object as GDataXMLDocument

        let root = xml.rootElement()
        
        // location
        let location = self.element(root, path: "//channel/yweather:location")
        
        if let city = location.attributeForName("city") {
            weatherInfo.city = city.stringValue()
        }
        if let region = location.attributeForName("region") {
            weatherInfo.region = region.stringValue()
        }
        if let country = location.attributeForName("country") {
            weatherInfo.country = country.stringValue()
        }
        
        let units = self.element(root, path: "//channel/yweather:units")
        
        // wind
        let wind = self.element(root, path: "//channel/yweather:wind")
        
        if let windChill = wind.attributeForName("chill") {
            weatherInfo.windChill = (windChill.stringValue() as NSString).floatValue
        }
        
        if let windDirection = wind.attributeForName("direction") {
            weatherInfo.windDirection = (windDirection.stringValue() as NSString).floatValue
        }
        
        if let windSpeed = wind.attributeForName("speed") {
            weatherInfo.windSpeed = (windSpeed.stringValue() as NSString).floatValue
        }
        
        let atmosphere = self.element(root, path: "//channel/yweather:atmosphere")
        let astronomy = self.element(root, path: "//channel/yweather:astronomy")
        let forecasts = self.elements(root, path: "//channel/item/yweather:forecast")
        let pubDate = root.nodesForXPath("//channel/item/pubDate", error: nil)//self.elementForPath(root, path: "//channel/item/pubDate")
        let condition = self.elements(root, path: "//channel/item/yweather:condition")
        
        println("hello:\(weatherInfo.city)")
        // TODO: update info
    }
}
