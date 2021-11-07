//
//  ViewController.swift
//  HW_2.2
//
//  Created by Ilya Pokhodin on 24.10.2021.
//

import UIKit

class ChooseColorViewController: UIViewController {

    @IBOutlet var colorWindowOutlet: UIView!
    
    @IBOutlet var redColorLabalOutlet: UILabel!
    @IBOutlet var greenColorLabalOutlet: UILabel!
    @IBOutlet var blueColorLabalOutlet: UILabel!
    
    @IBOutlet var redColorSliderOutlet: UISlider!
    @IBOutlet var greenColorSliderOutlet: UISlider!
    @IBOutlet var blueColorSliderOutlet: UISlider!
    
    @IBOutlet var redColorTextFieldOutlet: UITextField!
    @IBOutlet var greenColorTextFieldOutlet: UITextField!
    @IBOutlet var blueColorTextFieldOutlet: UITextField!
    
    var redTemporaryVariable = ""
    var greenTemporaryVariable = ""
    var blueTemporaryVariable = ""
    
    var colorFromColorVC: UIColor!
    var delegate: ChoosenColorViewControlletDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        colorWindowOutlet.layer.cornerRadius = 20
        
        redColorSliderOutlet.minimumTrackTintColor = .red
        greenColorSliderOutlet.minimumTrackTintColor = .green
        blueColorSliderOutlet.minimumTrackTintColor = .blue
        
        redColorTextFieldOutlet.delegate = self
        greenColorTextFieldOutlet.delegate = self
        blueColorTextFieldOutlet.delegate = self
        
        updateBackGroudFromColorVC()
        changedColor()
        
        addToolBar(textField: redColorTextFieldOutlet)
        addToolBar(textField: greenColorTextFieldOutlet)
        addToolBar(textField: blueColorTextFieldOutlet)
    }
    
    // MARK: - Переназначение класса скрытие клавиатуры по касанию по экрану
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkingEmptyValue()
        checkingOverValue()
        self.view.endEditing(true)
    }
    
    // MARK: - Активация слайдера цвета
    @IBAction func ColorSliderAction() {
        changedColor()
    }
    
    // MARK: - Кнопка закрытия экрана настроек
    @IBAction func doneButtonPressed() {
        let colorValue = colorWindowOutlet.backgroundColor!
        delegate.setNewViewBackgroundColor(for: colorValue)
        dismiss(animated: true)
    }
    
}
    // MARK: - Расширеширение класса
extension ChooseColorViewController: UITextFieldDelegate {
    // MARK: - Конец изменения текстфилдов
    func textFieldDidEndEditing(_ textField: UITextField) {
        if redColorTextFieldOutlet == textField {
            checkingOverValue()
            checkingEmptyValue()
            redColorLabalOutlet.text = textField.text
            guard let textFieldValue = Float(textField.text!) else { return }
            redColorSliderOutlet.setValue(textFieldValue, animated: true)
            changedColor()
        } else if greenColorTextFieldOutlet == textField {
            checkingOverValue()
            checkingEmptyValue()
            greenColorLabalOutlet.text = textField.text
            guard let textFieldValue = Float(textField.text!) else { return }
            greenColorSliderOutlet.setValue(textFieldValue, animated: true)
            changedColor()
        } else {
            checkingOverValue()
            checkingEmptyValue()
            blueColorLabalOutlet.text = textField.text
            guard let textFieldValue = Float(textField.text!) else { return }
            blueColorSliderOutlet.setValue(textFieldValue, animated: true)
            changedColor()
        }
    }
    
    // MARK: - Описание уведомления
    private func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Тулбар и кнопки для него
    private func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItem.Style.done,
            target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: UIBarButtonItem.Style.plain,
            target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        checkingEmptyValue()
        checkingOverValue()
        view.endEditing(true)
    }
    
    @objc func cancelPressed(){
        savePreviousValue()
        view.endEditing(true)
    }
    
    // MARK: - Сохранение предыдущих значений
    private func savePreviousValue() {
        redColorTextFieldOutlet.text = redTemporaryVariable
        greenColorTextFieldOutlet.text = greenTemporaryVariable
        blueColorTextFieldOutlet.text = blueTemporaryVariable
    }
    
    // MARK: - Проверка на пустой Тексфилд
    private func checkingEmptyValue() {
        guard let redTF = redColorTextFieldOutlet.text else { return }
        guard let greenTF = greenColorTextFieldOutlet.text else { return }
        guard let blueTF = blueColorTextFieldOutlet.text else { return }
        
        if redTF == "" || greenTF == "" || blueTF == "" {
            savePreviousValue()
            showAlert(
                title: "Ошибка",
                message: "Значение не может быть пустым, пожалуйста введите значение от 0.00 до 1.00")
        }
    }
    
    // MARK: - Проверка на значения больше разрешённого
    private func checkingOverValue() {
        guard let redTF = Float(redColorTextFieldOutlet.text!) else { return }
        guard let greenTF = Float(greenColorTextFieldOutlet.text!) else { return }
        guard let blueTF = Float(blueColorTextFieldOutlet.text!) else { return }
        
        if redTF > 1.00 || greenTF > 1.00 || blueTF > 1.00 {
            savePreviousValue()
            showAlert(
                title: "Ошибка",
                message: "Значение не может быть больше 1")
        }
    }
    
    // MARK: - Изменения фонового цвета маленького и большого окна и присвоения значения каждого цвета всем элементам
    private func changedColor() {
        redColorLabalOutlet.text = String(format: "%.2f", redColorSliderOutlet.value)
        greenColorLabalOutlet.text = String(format: "%.2f", greenColorSliderOutlet.value)
        blueColorLabalOutlet.text = String(format: "%.2f", blueColorSliderOutlet.value)
        
        redColorTextFieldOutlet.text = String(format: "%.2f", redColorSliderOutlet.value)
        greenColorTextFieldOutlet.text = String(format: "%.2f", greenColorSliderOutlet.value)
        blueColorTextFieldOutlet.text = String(format: "%.2f", blueColorSliderOutlet.value)
        
        colorWindowOutlet.backgroundColor = UIColor(cgColor: CGColor.init(srgbRed: CGFloat(redColorSliderOutlet.value),
                                                                          green: CGFloat(greenColorSliderOutlet.value),
                                                                          blue: CGFloat(blueColorSliderOutlet.value),
                                                                          alpha: 1))
        
        guard let temporaryVariable = redColorTextFieldOutlet.text else { return }
        redTemporaryVariable = temporaryVariable
        
        guard let temporaryVariable = greenColorTextFieldOutlet.text else { return }
        greenTemporaryVariable = temporaryVariable
        
        guard let temporaryVariable = blueColorTextFieldOutlet.text else { return }
        blueTemporaryVariable = temporaryVariable
    }
    
    private func updateBackGroudFromColorVC() {
        let ciColor = CIColor(color: colorFromColorVC)
        let red = Float(ciColor.red)
        let green = Float(ciColor.green)
        let blue = Float(ciColor.blue)
        
        redColorSliderOutlet.value = red
        greenColorSliderOutlet.value = green
        blueColorSliderOutlet.value = blue
    }
}
