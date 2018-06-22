//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by MTMAC18 on 22/06/18.
//  Copyright © 2018 Wisnu Anggoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var currencyArray = ["AUD", "BRL", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getUrlThenUpdateLabel(row: 0)
    }
    
    // MARK: - Networking
    
    func getBitcoinTicker(url: String) {
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess {
                let json : JSON = JSON(response.result.value!)
                self.updateBitcoinTicker(json: json)
            }
            else {
                self.bitcoinPriceLabel.text = "Connection Issue"
            }
        }
    }
    
    // MARK: - Fetching Data From Server
    
    func updateBitcoinTicker(json: JSON) {
        let average = json["averages"]["day"].stringValue
        if average != "" {
            if let averageDouble = Double(average) {
//                let str = NSString(format: "%.2f", averageDouble)
                
                // Round averageDouble with 2 digits precision
                let roundAverage = Double(round(100 * averageDouble) / 100)
                
                // Format roundAverage so it has digit group
                // based on locale
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let formattedString = formatter.string(for: roundAverage)
                
                // Display formattedString
                bitcoinPriceLabel.text = formattedString
            }
            else {
                bitcoinPriceLabel.text = "Parsing Error"
            }
        }
        else {
            bitcoinPriceLabel.text = "Unavailable Data"
        }
    }
    
    func getUrlThenUpdateLabel(row: Int) {
        bitcoinPriceLabel.text = "Calculating..."
        let finalUrl = baseUrl + currencyArray[row]
        print(finalUrl)
        getBitcoinTicker(url: finalUrl)
    }

}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getUrlThenUpdateLabel(row: row)
    }
}

