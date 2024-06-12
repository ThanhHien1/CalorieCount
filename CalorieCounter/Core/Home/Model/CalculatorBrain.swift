//
//  CalculatorBrain.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import Foundation
import UIKit

class CalculatorBrain {
    var bmi: BMI?
    var calorie: Float?
    
    func calculateBMI(_ height: Float,_ weight: Float) {
        let bmiValue = weight / pow(height,2)
        
        if bmiValue < 18.5 {
            bmi = BMI (value: bmiValue, advice:"You are underweight. Your body mass index is below normal limits.", color: UIColor.init(red: 0.1137, green: 0.6745, blue: 0.898, alpha: 1))
        } else if bmiValue <= 24.9 {
            bmi = BMI (value: bmiValue, advice: "You are healthy. Track your daily calorie needs.", color: UIColor.init(red: 0.3882, green: 0.9, blue: 0.1176, alpha: 1))
        } else {
            bmi = BMI (value: bmiValue, advice: "You are overweight. You need to keep an eye on your health.", color: UIColor.systemPink)
        }
    }
    
    func calculateCalorie(_ sex: String, _ weight: Float, _ height: Float, _ age: Int, _ bmh: Float, _ changeCalorieAmount: Int) {
        var bmr: Float = 0.0
        print("## \(sex)")
        print("## \(weight)")
        print("## \(height)")
        print("## \(age)")
        print("## \(bmh)")
        print("## \(changeCalorieAmount)")
        if sex == "Nam" || sex == "nam" {
            let weightComponent = 13.7 * weight
            let heightComponent = 5 * height * 100
            let ageComponent = 6.8 * Float(age)
            bmr = 66 + weightComponent + heightComponent - ageComponent
        }
        else {
            let weightComponent = 9.6 * weight
            let heightComponent = 1.8 * height * 100
            let ageComponent = 4.7 * Float(age)
            bmr = 655 + weightComponent + heightComponent - ageComponent
        }
        let calorieFromBMR = bmr * bmh
        calorie = calorieFromBMR + Float(changeCalorieAmount)
    }

    
    
    func getBMIValue() -> String {
        let bmiTo1DecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiTo1DecimalPlace
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? "Error:Advice Not Found"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? UIColor.white
    }
    
    func getCalorie() -> String {
        let calorieTo1DecimalPlace = String(format: "%.0f", calorie ?? 0.0)
        return calorieTo1DecimalPlace
    }
}
