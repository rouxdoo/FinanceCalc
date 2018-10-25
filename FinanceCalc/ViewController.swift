//
//  ViewController.swift
//  FinanceCalc
//
//  Created by Ian Jones on 10/17/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var renewalsTextField: UITextField!
    @IBOutlet weak var renewalCountTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var taxRateButton: UIButton!
    @IBOutlet weak var financeRateButton: UIButton!
    @IBOutlet weak var downPercentButton: UIButton!
    @IBOutlet weak var loanMonthsButton: UIButton!
    @IBOutlet weak var summaryTextBox: UITextView!
    @IBOutlet weak var renewalCountLabel: UILabel!
    @IBOutlet weak var loanMonthsLabel: UILabel!
    
    var fin = FinanceStruct(job: 0, renewalCount: 0, renewalAmount: 0, taxRate: 0, apr: 0, term: 0, percentDown: 0)

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
    
    @IBAction func clearForm(_ sender: Any) {
        jobTextField.text = ""
        renewalsTextField.text = ""
        renewalCountTextField.text = ""
        summaryTextBox.text = ""
        financeRateButton.setTitle("18", for: [])
        taxRateButton.setTitle("8.25", for: [])
        loanMonthsButton.setTitle("12", for: [])
        updateView()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        jobTextField.delegate = self
        renewalsTextField.delegate = self
        renewalCountTextField.delegate = self
        summaryTextBox.delegate = self
        clearForm(self)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPDF" {
            let pdfViewController = segue.destination as? PDFViewController
            if let pdf = pdfViewController {
                pdf.fin = fin
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        updateView()
    }
    func updateView() {
        let taxString = taxRateButton.currentTitle
        let dppercentStr = downPercentButton.currentTitle
        let aprString = financeRateButton.currentTitle
        let loanTermSt = loanMonthsButton.currentTitle
        
        fin.job = Double(jobTextField.text ?? "0") ?? 0.00
        fin.renewalCount = Int(renewalCountTextField.text ?? "0") ?? 0
        fin.renewalAmount = Double(renewalsTextField.text ?? "0") ?? 0.00
        fin.taxRate = Double(taxString ?? "8.25")!
        fin.percentDown = Double(dppercentStr ?? "0")!
        fin.apr = Double(aprString ?? "18")!
        fin.term = Int(loanTermSt ?? "12")!
        
        var maxterm = 0
        switch fin.amountFinanced() {
        case 0..<300:
            maxterm = 0
        case 300..<1000:
            maxterm = 12
        case 1000..<2000:
            maxterm = 18
        case 2000..<3000:
            maxterm = 24
        case 3000..<4000:
            maxterm = 36
        case 4000..<6000:
            maxterm = 48
        case let x where x > 6000:
            maxterm = 60
        default:
            maxterm = 0
        }
        if (fin.job > 0) {
            if (maxterm < fin.term) {
                fin.term = maxterm
                renewalCountTextField.textColor = UIColor.red
                renewalCountLabel.textColor = UIColor.red
                loanMonthsLabel.textColor = UIColor.red
                loanMonthsLabel.text = "Max Term " + String(fin.term)
                loanMonthsButton.setTitleColor(UIColor.red, for: .normal)
            } else {
                renewalCountTextField.textColor = UIColor.black
                renewalCountLabel.textColor = UIColor.black
                loanMonthsLabel.textColor = UIColor.black
                loanMonthsLabel.text = "Loan Months"
                loanMonthsButton.setTitleColor(.black, for: .normal)
            }
        }
        summaryTextBox.text = "Job Amount: \t\t" + fin.job.asCurrency + "\n"
            + "With Renewals: \t\t" + fin.totalJobPretax().asCurrency + "\n"
            + "Tax: \t\t\t\t" + fin.taxes().asCurrency + "\n"
            + "Total Cash Price: \t" + fin.totalCashPrice().asCurrency + "\n"
            + "Down Payment: \t\t" + fin.downPayment().asCurrency + "\n"
            + "Amount Financed: \t" + fin.amountFinanced().asCurrency + "\n"
            + "Monthly Payment: \t" + fin.monthlyPayment().asCurrency + "\n"
            + "Number of Payments:  " + String(fin.term) + "\n"
            + "Total of Payments: \t" + fin.totalOfPayments().asCurrency + "\n"
            + "Finance Charge: \t\t" + fin.financeCharge().asCurrency + "\n"
            + "Total Financed Job: \t" + fin.totalFinancedJob().asCurrency
    }
}

