//
//  DHLCustomDatePickerModal.swift
//  DHLCustomDatePicker
//
//  Created by Daniel Hernandez on 1/6/26.
//

import Foundation
import UIKit

class DHLCustomDatePickerModal: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var cancelButtonLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var saveButtonLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var backgroundButton: UIButton!
    
    private var datePickedAction: ((Date) -> Void)?
    private var cancelAction: (() -> Void)?
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {

        backgroundColor = .clear
        
        let bundle = Bundle.dhlResources

        if let xibView = bundle.loadNibNamed("DHLCustomDatePickerModal",
                                             owner: self,
                                             options: nil)?.first as? UIView {

            xibView.frame = self.bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(xibView)

            commonInit()
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()

        commonInit()
    }

    func commonInit() {
        self.accessibilityViewIsModal = true
        
        backgroundButton.isAccessibilityElement = false
        cancelButton.accessibilityLabel = NSLocalizedString("back", tableName: "Strings", bundle: Bundle.dhlResources, comment: "")
        saveButton.accessibilityLabel = NSLocalizedString("next", tableName: "Strings", bundle: Bundle.dhlResources, comment: "")
        cancelButtonLabel.isAccessibilityElement = false
        saveButtonLabel.isAccessibilityElement = false
        
        containerView.layer.cornerRadius = 8
        
        cancelButtonView.layer.cornerRadius = 8
        saveButtonView.layer.cornerRadius = 8
        cancelButtonView.layer.borderWidth = 1
        
        cancelButtonLabel.text = NSLocalizedString("back", tableName: "Strings", bundle: Bundle.dhlResources, comment: "")
        saveButtonLabel.text = NSLocalizedString("next", tableName: "Strings", bundle: Bundle.dhlResources, comment: "")
    }

    func setUp(type: UIDatePicker.Mode?, minimumDate: Date? = nil, maximumDate: Date? = nil, selectedDate: Date? = nil, textFont: UIFont? = nil, saveText: String? = nil, customTintColor: UIColor = .black, datePickedAction: @escaping ((Date) -> Void), cancelAction: @escaping (() -> Void)) {

        self.datePickedAction = datePickedAction
        self.cancelAction = cancelAction
        datePicker.datePickerMode = type ?? .date
        
        cancelButtonView.layer.borderColor = customTintColor.cgColor
        saveButtonView.backgroundColor = customTintColor
        
        cancelButtonLabel.font = textFont ?? .systemFont(ofSize: 14)
        saveButtonLabel.font = textFont ?? .systemFont(ofSize: 14)
        
        if let saveText = saveText {
            saveButtonLabel.text = saveText
        }
        
        if type == .time {
            datePicker.preferredDatePickerStyle = .wheels
            
        } else if type == .dateAndTime {
            datePicker.datePickerMode = .date
        }
        
        if let minimumDate = minimumDate {
            datePicker.minimumDate = minimumDate
        }
        
        if let maximumDate = maximumDate {
            datePicker.maximumDate = maximumDate
        }
        
        if let selectedDate = selectedDate {
            datePicker.date = selectedDate
        }
    }

    @IBAction func datePicked(_ sender: Any) {
        // datePickedAction?(datePicker.date)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelAction?()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        datePickedAction?(datePicker.date)
    }
}
