//
//  CalorieCalculatorController.swift
//  DietBalanceApp
//
//  Created by Devika Krishnan on 2022-11-02.
//

import UIKit

class CalorieCalculatorController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    //MARK: - pickerView delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Displays number of rows in picker component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100{
        return genderData.count
        }else{
            return excerciseData.count
        }
    }
    
    //Set the data for each component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 100{
        return genderData[row]
        }else{
            return excerciseData[row]
        }
    }
    
    //Setting the textfiled with the value picker from picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 100{
            genderTextField.text = genderData[row]
          
        }else{
            excerciseTextField.text = excerciseData[row]
       
        }
    }

    //MARK: - Actions

    @IBAction func submitButton(_ sender: UIButton) {
        
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        excerciseTextField.resignFirstResponder()
        resultArea.isHidden = false

        // Calculation for BMI calculator
        if segmentSelector.tag == 0{

            guard let height = heightTextField.text else { return }
            guard let weight = weightTextField.text else { return }
            var feedback = ""
            
            if let height = Double(height){
                let heightInMeters = height / 100
                if let weight = Double(weight){
                    let bmi : Double = weight / (heightInMeters * heightInMeters)
                    
                    if (bmi < 18.5) {
                        feedback = "UnderWeight";
                    } else if (bmi >= 18.5 && bmi < 25) {
                        feedback = "Healthy Weight";
                    } else if (bmi >= 25 && bmi < 30) {
                        feedback = "OverWeight";
                    } else {
                        feedback = "Obesity";
                    }
              
                    resultAnim()
                    resultArea.text = " BMI is \(String(format: "%.2f", bmi)). You are \(feedback)"
                }else{
                    resultArea.text = "Please fill out weight"
                }
            }else{
                buttonAnim()
                resultArea.text = "Please fill all fields"
            }
        }
        
        //Calculation for calorie calculator screen
        if segmentSelector.tag == 1{
            guard let height = heightTextField.text else { return }
            guard let weight = weightTextField.text else { return }
            guard let age = ageTextField.text else { return }
            guard let gender = genderTextField.text else { return }
            guard let excerciseLevel = excerciseTextField.text else { return }
            var bmr = 0.0
            var caloriesNeeded = 0.0
            var heightValue = 0.0
            var weightValue = 0.0
            var ageValue = 0.0
            
            if let height = Double(height){
                heightValue = height
                
                if let weight = Double(weight){
                    weightValue = weight
                
                    if let age = Double(age){
                        ageValue = age
                    
                        if gender != ""{
                            switch (gender){
                                case "Male":
                                 bmr = (10 * weightValue) + (6.25 * heightValue) - (5 * ageValue) + 5
                                   
                                case "Female":
                                   bmr = (10 * weightValue) + (6.25 * heightValue) - (5 * ageValue) - 161
                                default:
                                    break
                            }
                            
                            if excerciseLevel != ""{
                                switch (excerciseLevel){
                                   case "Little or No excercise":
                                       caloriesNeeded = bmr * 1.2
                                       break;
                                   case "Light Excrecise or Sports (1 - 3) days/week":
                                       caloriesNeeded = bmr * 1.375
                                       break;
                                   case "Moderate Excercise or sports (3 - 5) days/week":
                                       caloriesNeeded = bmr * 1.55
                                       break;
                                   case "Hard Excercise or sports (6 - 7) days/week":
                                       caloriesNeeded = bmr * 1.725
                                       break;
                                   case "Very hard excercise or sports/physical job":
                                       caloriesNeeded = bmr * 1.9
                                       break;
                                   default:
                                    resultArea.text = "Please select excercise Level"
                                }
                                
                                    resultAnim()
                                    resultArea.text = " The total number of calories you need in order to maintain your current weight is : \(String(format: "%.2f", caloriesNeeded))cal"
                                }else{
                                    resultArea.text = "Please select Excercise Level"
                                }
                            }else{
                                resultArea.text = "Please select Gender"
                            }
                        }else{
                            resultArea.text = "Please fill out age"
                        }
                    }else{
                        resultArea.text = "Please fill out weight"
                    }
                }else{
                    buttonAnim()
                resultArea.text = "Please fill all fields"
            }
            
        }
        
        //Calculation for Ideal weight calculator
        if segmentSelector.tag == 2{
            guard let height = heightTextField.text else { return }
            
            if let height = Double(height){
                let heightInMeters = height / 100
                let weightFrom = 18.5 * (heightInMeters * heightInMeters)
                let weightTo = 25 * (heightInMeters * heightInMeters)
                
                resultAnim()
                resultArea.text = "Your Ideal Weight should be between           \(String(format: "%.2f", weightFrom))Kg - \(String(format: "%.2f", weightTo))Kg"
            }else{
                buttonAnim()
                resultArea.text = "Please fill all fields"
            }
            
        }
            
    }
    
    //MARK: - Switching segment
    @IBAction func selectSegment(_ sender: Any) {
        switch segmentSelector.selectedSegmentIndex{
            //Setting layout for BMI Calculator
        case 0:
            segmentSelector.tag = 0
            heightView.isHidden = false
            weightview.isHidden = false
            ageView.isHidden = true
            genderView.isHidden = true
            excerciseView.isHidden = true
            resultArea.isHidden = true
            heightTextField.text = nil
            weightTextField.text = nil

            //Setting layout for Calorie Calculator
        case 1:
            segmentSelector.tag = 1
            heightView.isHidden = false
            weightview.isHidden = false
            ageView.isHidden = false
            genderView.isHidden = false
            excerciseView.isHidden = false
            resultArea.isHidden = true
            heightTextField.text = nil
            weightTextField.text = nil
            ageTextField.text = nil
            genderTextField.text = nil
            excerciseTextField.text = nil
            
     //Setting layout for Ideal calculator
        case 2:
            segmentSelector.tag = 2
            heightView.isHidden = false
            weightview.isHidden = true
            ageView.isHidden = true
            genderView.isHidden = true
            excerciseView.isHidden = true
            resultArea.isHidden = true
            heightTextField.text = nil
     
        default:
            break
        }
    }
    //MARK: - Outlets
    @IBOutlet weak var segmentSelector: UISegmentedControl!
    @IBOutlet weak var heightView: UIStackView!
    @IBOutlet weak var weightview: UIStackView!
    @IBOutlet weak var ageView: UIStackView!
    @IBOutlet weak var genderView: UIStackView!
    @IBOutlet weak var excerciseView: UIStackView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var resultArea: UITextView!
    @IBOutlet weak var excerciseTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!

    
    //MARK: - Properties
    
    let genderData = ["Male", "Female"]
    var excerciseData = ["Little or No excercise", "Light Excrecise or Sports (1 - 3) days/week",
                        "Moderate Excercise or sports (3 - 5) days/week", "Hard Excercise or sports (6 - 7) days/week",
                        "Very hard excercise or sports/physical job"]
    let picker = UIPickerView()
    let excercisePicker = UIPickerView()
    
    
    
    //MARK: - Animation Methods
    func resultAnim(){
      UIView.animate(withDuration: 2) {
          self.resultArea.frame = CGRect(x: 50, y: 100, width: 40, height: 20)
      }
       
    }
    //Animate Submit button
    func buttonAnim(){
        
        let bounds = self.submitButton.bounds
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10,  animations:{
             self.submitButton.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
         }, completion: nil)
    }

    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        //Requesting permission from user to receive notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
            granted, error in
            
            if granted{
                self.showNotification()
            } else {
                print("Access was denied")
            }
        })
        
        heightTextField.delegate = self
        weightTextField.delegate = self
        ageTextField.delegate = self
        genderTextField.delegate = self
        excerciseTextField.delegate = self
 
        ageView.isHidden = true
        genderView.isHidden = true
        excerciseView.isHidden = true
        //Gender picker
        picker.tag = 100
        picker.delegate = self
        picker.backgroundColor = UIColor(named: "customGreen")
        genderTextField.inputView = picker
        genderTextField.delegate = self
        
       //Excercise level picker
        excercisePicker.tag = 1000
        excercisePicker.delegate = self
        excercisePicker.backgroundColor = UIColor(named: "customGreen")
        excerciseTextField.inputView = excercisePicker
        excerciseTextField.delegate = self

        resultArea.layer.cornerRadius = 15
        resultArea.isHidden = true
        resultArea.contentInset = UIEdgeInsets(top: 32, left: 16, bottom: 16, right: 16)
        
        //GUESTURE : 1 tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    
        
    }
    
   //MARK: - Gesture Method
    @objc func viewTapped(_ gesture: UITapGestureRecognizer){
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        excerciseTextField.resignFirstResponder()
    }
    
    
    //Hiding keyboard on return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        excerciseTextField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - Notification Method
    func showNotification(){
         
            //Creating Notification content and setting all its properties
            let content = UNMutableNotificationContent()
            content.title = "This is a remainder"
            content.body = "This is time to get hydrated yourself drink Water"
            content.badge = 1
            
            let sound = UNNotificationSoundName("alert.wav")
            content.sound = UNNotificationSound(named: sound)
            
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3 * 3600, repeats: true)
        
         // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
    

            //Creating request with the above properties
            let request = UNNotificationRequest(identifier: "notification.timer.\(UUID().uuidString)", content: content, trigger: trigger)
            //Adding the notification request
            UNUserNotificationCenter.current().add(request){
                error in
                if let error = error {
                    print("Error adding a notification - \(error.localizedDescription)")
                }
            }
    }
    
}
