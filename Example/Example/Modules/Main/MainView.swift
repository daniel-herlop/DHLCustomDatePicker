//
//  MainView.swift
//  Example
//
//  Created by Daniel Hernandez on 26/06/2026.
//

import Foundation
import UIKit
import DHLCustomDatePicker

class MainView: UIViewController {
    
    @IBOutlet weak var startDateTitle: UILabel!
    @IBOutlet weak var startDatePicker: DHLCustomDatePicker!
    
    @IBOutlet weak var startHourTitle: UILabel!
    @IBOutlet weak var startHourPicker: DHLCustomDatePicker!
    
    private var router = MainRouter()
    private var viewModel = MainViewModel()
    
    //********************************************
    // MARK: Initialization
    //********************************************
    override func viewDidLoad() {
        viewModel.bind(view: self, router: router)
        
        startDatePicker.layer.borderWidth = 1
        startDatePicker.layer.borderColor = UIColor.gray.cgColor
        startDatePicker.layer.cornerRadius = 8

        startHourPicker.layer.borderWidth = 1
        startHourPicker.layer.borderColor = UIColor.gray.cgColor
        startHourPicker.layer.cornerRadius = 8
        
        startDatePicker.setUp(parent: self, type: .date, saveText: "Save", customTintModalColor: UIColor.systemBlue, datePickedAction: { date in
            
            UIAccessibility.post(notification: .screenChanged, argument: self.startDatePicker)
        })

        startHourPicker.setUp(parent: self, type: .time, saveText: "Save", customTintModalColor: UIColor.systemBlue, datePickedAction: { date in
            
            UIAccessibility.post(notification: .screenChanged, argument: self.startHourPicker)
        })
    }
}
