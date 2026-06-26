//
//  DHLCustomDatePicker.swift
//  DHLCustomDatePicker
//
//  Created by Daniel Hernandez on 1/6/26.
//

import Foundation
import UIKit

public class DHLCustomDatePicker: UIView {
    
    @IBOutlet public weak var textLabel: UILabel!
    @IBOutlet public weak var iconImageView: UIImageView!
    @IBOutlet public weak var showDateButton: UIButton!
    
    private var datePickedAction: ((Date) -> Void)?
    private var type: UIDatePicker.Mode?
    private var parent: UIViewController?
    private var minimumDate: Date?
    private var maximumDate: Date?
    private var accessibilityTextLabel: String?
    
    public var selectedDate: Date?
    private var showUTC: Bool = true
    private var customTintColor: UIColor = .black
    private var customTintModalColor: UIColor = .black
    private var saveText: String?
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        
        let bundle = Bundle.dhlResources

        if let xibView = bundle.loadNibNamed("DHLCustomDatePicker",
                                             owner: self,
                                             options: nil)?.first as? UIView {


            xibView.frame = self.bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(xibView)

            commonInit()
        }
    }

    public override func awakeFromNib() {

        super.awakeFromNib()

        commonInit()
    }

    func commonInit() {
        textLabel.isAccessibilityElement = false
        textLabel.text = ""
    }

    public func setUp(parent: UIViewController?, type: UIDatePicker.Mode, accessibilityTextLabel: String? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, showUTC: Bool = true, textFont: UIFont? = nil, saveText: String? = nil, customTintColor: UIColor = .black, customTintModalColor: UIColor = .black, datePickedAction: @escaping ((Date) -> Void)) {
        self.parent = parent
        self.type = type
        self.datePickedAction = datePickedAction
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.accessibilityTextLabel = accessibilityTextLabel
        self.customTintColor = customTintColor
        self.customTintModalColor = customTintModalColor
        self.saveText = saveText
        
        textLabel.font = textFont ?? .systemFont(ofSize: 14)
        
        switch type {
            
        case .date:
            iconImageView.image = UIImage(named: "ic_calendar", in: Bundle.dhlResources, compatibleWith: nil)?.withTintColor(customTintColor)
            
        case .time:
            iconImageView.image = UIImage(named: "ic_time_clock", in: Bundle.dhlResources, compatibleWith: nil)?.withTintColor(customTintColor)
            
        default:
            break
        }
        
        showDateButton.accessibilityLabel = accessibilityTextLabel
    }
    
    public func setDate(_ date: Date?, performCompletion: Bool = false) {
        guard let date = date else {
            self.selectedDate = nil
            textLabel.text = ""
            showDateButton.accessibilityLabel = accessibilityTextLabel
            return
        }
        
        self.selectedDate = date
        
        let offset = TimeZone.current.secondsFromGMT() / 3600
        let sign = offset >= 0 ? "+" : ""
        
        switch type {
            
        case .date:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            textLabel.text = dateFormatter.string(from: date)
            
        case .time:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            if showUTC {
                textLabel.text = "\(dateFormatter.string(from: date)) (UTC \(sign)\(offset))"
            } else {
                textLabel.text = dateFormatter.string(from: date)
            }
        case .dateAndTime:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            if showUTC {
                textLabel.text = "\(dateFormatter.string(from: date)) (UTC \(sign)\(offset))"
            } else {
                textLabel.text = dateFormatter.string(from: date)
            }
            
        default:
            break
        }
        
        showDateButton.accessibilityLabel = accessibilityTextLabel?.appending(NSLocalizedString("selected_string", tableName: "Strings", bundle: Bundle.dhlResources, comment: textLabel.text ?? ""))
        
        if performCompletion {
            datePickedAction?(date)
        }
    }
    
    func showPicker() {
        let customDatePickerModal = DHLCustomDatePickerModal(frame: .zero)
        customDatePickerModal.translatesAutoresizingMaskIntoConstraints = false
        
        if let parent = self.parent?.view {
            
            parent.addSubview(customDatePickerModal)
            
            NSLayoutConstraint.activate([
                customDatePickerModal.topAnchor.constraint(equalTo: parent.topAnchor),
                customDatePickerModal.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
                customDatePickerModal.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                customDatePickerModal.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
            ])
        }

        customDatePickerModal.setUp(
            type: self.type,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            selectedDate: selectedDate,
            saveText: saveText,
            customTintColor: customTintModalColor,
            datePickedAction: { date in
                
                if self.type == .dateAndTime {
                    self.showHourPicker(date)
                } else {
                    
                    self.setDate(date)
                    self.datePickedAction?(date)
                }
                
                customDatePickerModal.removeFromSuperview()
            },
            cancelAction: {
                // self.setUpDate(nil) // si se quiere eliminar la fecha al dar a cancelar
                customDatePickerModal.removeFromSuperview()
            }
        )
    }
    
    func showHourPicker(_ date: Date) {
        let customDatePickerModal = DHLCustomDatePickerModal(frame: .zero)
        customDatePickerModal.translatesAutoresizingMaskIntoConstraints = false

        if let parent = self.parent?.view {
            
            parent.addSubview(customDatePickerModal)
            
            NSLayoutConstraint.activate([
                customDatePickerModal.topAnchor.constraint(equalTo: parent.topAnchor),
                customDatePickerModal.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
                customDatePickerModal.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                customDatePickerModal.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
            ])
        }
        
        customDatePickerModal.setUp(
            type: .time,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            selectedDate: selectedDate,
            saveText: saveText,
            customTintColor: customTintModalColor,
            datePickedAction: { hour in
                
                if let dateAndHour = date.combineWithDateHour(hour) {
                    self.setDate(dateAndHour)
                    self.datePickedAction?(dateAndHour)
                }
           
                customDatePickerModal.removeFromSuperview()
            },
            cancelAction: {
                self.showPicker()
                customDatePickerModal.removeFromSuperview()
            }
        )
    }
    
    @IBAction func showDateButtonPressed(_ sender: UIButton) {
        
        showPicker()
    }
}

extension Date {
    
    func combineWithDateHour(_ hours: Date) -> Date? {
        let calendar = Calendar.current
        
        // Extraer componentes de la fecha (año, mes, día)
        let fechaComponentes = calendar.dateComponents([.year, .month, .day], from: self)
        
        // Extraer componentes de la hora (hora, minuto, segundo)
        let horaComponentes = calendar.dateComponents([.hour, .minute, .second], from: hours)
        
        // Combinar en un solo conjunto de componentes
        var combinados = DateComponents()
        combinados.year = fechaComponentes.year
        combinados.month = fechaComponentes.month
        combinados.day = fechaComponentes.day
        combinados.hour = horaComponentes.hour
        combinados.minute = horaComponentes.minute
        combinados.second = horaComponentes.second
        
        // Crear nueva fecha
        return calendar.date(from: combinados)
    }
}
