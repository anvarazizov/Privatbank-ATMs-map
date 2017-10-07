//
//  CityPickerViewController.swift
//  PrivatbankATMMap
//
//  Created by Anvar Azizov on 06.10.17.
//  Copyright © 2017 Anvar Azizov. All rights reserved.
//

import UIKit

protocol CityPickerViewControllerDelegate: class {
    func cityDidPicked(city: City)
}

class CityPickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: CityPickerViewControllerDelegate?
    fileprivate var pickedCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickedCity = Shared.cities.first
     }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        if let delegate = delegate, let city = pickedCity {
            dismiss(animated: true, completion: nil)
            delegate.cityDidPicked(city: city)
        }
    }
}

extension CityPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Shared.cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Shared.cities[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCity = Shared.cities[row]
    }
}
