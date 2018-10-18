//
//  ViewController.swift
//  FinanceCalc
//
//  Created by Ian Jones on 10/17/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var renewalsTextField: UITextField!
    @IBOutlet weak var renewalCountTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var taxRateButton: UIButton!
    @IBOutlet weak var financeRateButton: UIButton!
    @IBOutlet weak var downPercentButton: UIButton!
    @IBOutlet weak var loanMonthsButton: UIButton!
    @IBOutlet weak var summaryTextBox: UITextView!
    
    @IBAction func percentButton(_ sender: UIButton) {
        var percent = sender.currentTitle
        let alertController = UIAlertController(title: "Enter Percentage", message: "Enter the percentage amount", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            percent = alertController.textFields?[0].text
            sender.setTitle(percent, for: [])
            self.updateView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = percent
            textField.keyboardType = .decimalPad
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func monthsButton(_ sender: UIButton) {
        var percent = sender.currentTitle
        let alertController = UIAlertController(title: "Enter Months", message: "Enter the term in months", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            percent = alertController.textFields?[0].text
            sender.setTitle(percent, for: [])
            self.updateView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = percent
            textField.keyboardType = .decimalPad
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var job = 0.00
    var totalJob = 0.00
    var tax = 0.00
    var taxRate = 0.00
    var totalCash = 0.00
    var apr = 0.00
    var loanTerm = 0.00
    var downPayment = 0.00
    var amountFinanced = 0.00
    var financeCharge = 0.00
    var monthlyPayment = 0.00
    var totalPayments = 0.00
    var totalFinancedJob = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobTextField.delegate = self
        renewalsTextField.delegate = self
        renewalCountTextField.delegate = self
        summaryTextBox.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        updateView()
    }
    func updateView() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        job = Double(jobTextField.text ?? "0") ?? 0.00
        let rencount = Double(renewalCountTextField.text ?? "0") ?? 0.00
        let renamt = Double(renewalsTextField.text ?? "0") ?? 0.00
        totalJob = job + (renamt * rencount)
        let taxString = taxRateButton.currentTitle
        taxRate = Double(taxString ?? "8.25")! / 100
        tax = totalJob * taxRate
        totalCash = totalJob + tax
        let dppercentStr = downPercentButton.currentTitle
        var dppercent = Double(dppercentStr ?? "0")!
        dppercent = dppercent/100
        let rawdp = totalCash * dppercent
        let dpModulo = (totalCash - rawdp).truncatingRemainder(dividingBy: 10)
        downPayment = rawdp + dpModulo
        amountFinanced = totalCash - downPayment
        let aprString = financeRateButton.currentTitle
        apr = Double(aprString ?? "18")! / 100
        let ratePerPeriod = apr / 12
        let loanTermSt = loanMonthsButton.currentTitle
        loanTerm = Double(loanTermSt ?? "12")!
        monthlyPayment = (ratePerPeriod / (1 - (pow(1 + ratePerPeriod, loanTerm * -1)))) * amountFinanced
        let monthlyPaymtStr = NumberFormatter.localizedString(from: NSNumber(value: monthlyPayment), number: .currency)
        monthlyPayment = formatter.number(from: monthlyPaymtStr) as! Double
        totalPayments = loanTerm * monthlyPayment
        financeCharge = totalPayments - amountFinanced
        totalFinancedJob = totalPayments + downPayment
        // put it all in a string
        summaryTextBox.text = "Job Amount: \t\t" + NumberFormatter.localizedString(from: NSNumber(value: job), number: .currency) + "\n"
            + "With Renewals: \t\t" + NumberFormatter.localizedString(from: NSNumber(value: totalJob), number: .currency) + "\n"
            + "Tax: \t\t\t\t" + NumberFormatter.localizedString(from: NSNumber(value: tax), number: .currency) + "\n"
            + "Total Cash Price: \t" + NumberFormatter.localizedString(from: NSNumber(value: totalCash), number: .currency) + "\n"
            + "Down Payment: \t\t" + NumberFormatter.localizedString(from: NSNumber(value: downPayment), number: .currency) + "\n"
            + "Amount Financed: \t" + NumberFormatter.localizedString(from: NSNumber(value: amountFinanced), number: .currency) + "\n"
            + "Monthly Payment: \t" + monthlyPaymtStr + "\n"
            + "Number of Payments: " + String(format:"%.0f", loanTerm) + "\n"
            + "Total of Payments: \t" + NumberFormatter.localizedString(from: NSNumber(value: totalPayments), number: .currency) + "\n"
            + "Finance Charge: \t\t" + NumberFormatter.localizedString(from: NSNumber(value: financeCharge), number: .currency) + "\n"
            + "Total Financed Job: \t" + NumberFormatter.localizedString(from: NSNumber(value: totalFinancedJob), number: .currency)
    }


}

