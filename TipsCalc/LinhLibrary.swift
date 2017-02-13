//
//  LinhLibrary.swift
//  TipsCalc
//
//  Created by Linh Le on 12/10/16.
//  Copyright © 2016 Linh Le. All rights reserved.
//

import Foundation

class log {
    static let infoLog = "[log] INFO:    "
    static let warning = "[log] WARNING: "
    static let error =   "[log] ERROR:   "
    
    static func warning (_ input : String)->(){
        print("\(warning) \(input)")
    }
    static func info (_ input : String)->(){
        print("\(infoLog) \(input)")
    }
    static func error (_ input : String)->(){
        print("\(error) \(input)")
    }
}

class utilities {
    static func numberToCurrency(_ number: Double = 0) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = NSLocale.current
        return currencyFormatter.string(from: NSNumber(value: number))!
    }
    static func getTime() -> Double{
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let time = ("\(year)\(month)\(day)\(hour)\(minutes)\(seconds)")
        return Double(time)!
    }
}
