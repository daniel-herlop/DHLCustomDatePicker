//
//  DHLCustomDatePicker.swift
//  DHLCustomDatePicker
//
//  Created by Daniel Hernandez on 1/6/26.
//

import Foundation
import UIKit

class DHLCustomDatePicker: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var showDateButton: UIButton!
    
    private var datePickedAction: ((Date) -> Void)?
    private var type: UIDatePicker.Mode?
    private var parent: UIViewController?
    private var minimumDate: Date?
    private var maximumDate: Date?
    private var accessibilityTextLabel: String?
    
    var selectedDate: Date?

    override init(frame: CGRect) {

        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {

        if let xibView = Bundle.main.loadNibNamed("CustomDatePicker", owner: self, options: nil)?.first as? UIView {

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
        textLabel.isAccessibilityElement = false
        // textLabel.font = FontsHelper.normal()
        textLabel.text = ""
    }

    func setUp(parent: UIViewController?, type: UIDatePicker.Mode, accessibilityTextLabel: String? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, datePickedAction: @escaping ((Date) -> Void)) {
        self.parent = parent
        self.type = type
        self.datePickedAction = datePickedAction
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.accessibilityTextLabel = accessibilityTextLabel
        
        switch type {
            
        case .date:
            iconImageView.image = UIImage(named: "ic_calendar", in: Bundle(for: DHLCustomDatePicker.self), compatibleWith: nil)?.withTintColor(.black)
            
        case .time:
            iconImageView.image = UIImage(named: "ic_time_clock", in: Bundle(for: DHLCustomDatePicker.self), compatibleWith: nil)?.withTintColor(.black)
            
        default:
            break
        }
        
        showDateButton.accessibilityLabel = accessibilityTextLabel
    }
    
    
    func setDate(_ date: Date?) {
        guard let date = date else {
            self.selectedDate = nil
            textLabel.text = ""
            showDateButton.accessibilityLabel = accessibilityTextLabel
            return
        }
        
        self.selectedDate = date
        
        switch type {
            
        case .date:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            textLabel.text = dateFormatter.string(from: date)
            
        case .time:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            textLabel.text = dateFormatter.string(from: date)
            
        case .dateAndTime:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            textLabel.text = dateFormatter.string(from: date)
            
            
        default:
            break
        }
        
        showDateButton.accessibilityLabel = accessibilityTextLabel?.appending(NSLocalizedString("selected_string",bundle: Bundle(for: DHLCustomDatePicker.self), comment: textLabel.text ?? ""))
    }
    
    func showPicker() {
        let customDatePickerModal = DHLCustomDatePickerModal(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        parent?.view.window?.addSubview(customDatePickerModal)

        customDatePickerModal.setUp(
            type: self.type,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            selectedDate: selectedDate,
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
        let customDatePickerModal = DHLCustomDatePickerModal(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        parent?.view.window?.addSubview(customDatePickerModal)

        customDatePickerModal.setUp(
            type: .time,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            selectedDate: selectedDate,
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
