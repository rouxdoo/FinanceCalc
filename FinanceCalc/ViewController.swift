//
//  ViewController.swift
//  FinanceCalc
//
//  Created by Ian Jones on 10/17/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, PDFViewDelegate {
    
    @IBOutlet weak var renewalsTextField: UITextField!
    @IBOutlet weak var renewalCountTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var taxRateButton: UIButton!
    @IBOutlet weak var financeRateButton: UIButton!
    @IBOutlet weak var downPercentButton: UIButton!
    @IBOutlet weak var loanMonthsButton: UIButton!
    @IBOutlet weak var summaryTextBox: UITextView!
    @IBOutlet weak var pdfViewPane: PDFView!
    
    let documentInteractionController = UIDocumentInteractionController()
    
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
    
    @IBAction func shareForm(_ sender: UIBarButtonItem) {
        let tmpURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("SMAC.pdf")
        pdfViewPane.document?.write(to: tmpURL)
        documentInteractionController.url = tmpURL
        documentInteractionController.uti = "com.adobe.pdf"
        //documentInteractionController.presentPreview(animated: true)
        documentInteractionController.presentOptionsMenu(from: sender, animated: true)
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
    
    var job = 0.00
    var renewalsTotal = 0.00
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
        pdfViewPane.delegate = self
        documentInteractionController.delegate = self
        
        //        if let path = Bundle.main.path(forResource: "Mobility SMAC Fillable", ofType: "pdf") {
        if let path = Bundle.main.path(forResource: "SMAC Scanned Fillable", ofType: "pdf") {
            let url = URL(fileURLWithPath: path)
            if let pdfDocument = PDFDocument(url: url) {
                pdfViewPane.displayMode = .singlePageContinuous
                pdfViewPane.autoScales = true
                pdfViewPane.document = pdfDocument
            }
        }
        clearForm(self)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        updateView()
    }
    func updatePdf() {
        let document = pdfViewPane.document
        let annotations = document!.page(at: 0)?.annotations
        for annotation in annotations! {
            if (annotation.widgetFieldType == .button) {
                continue
            }
            switch annotation.fieldName {
            // this data fills SMAC Scanned Fillable -pdfescape.com
            case "TIL APR":
                annotation.widgetStringValue = String(Int(apr * 100))
            case "TIL Finance Charge":
                annotation.widgetStringValue = financeCharge.asCurrency
            case "TIL Amount Financed":
                annotation.widgetStringValue = amountFinanced.asCurrency
            case "TIL Total of Payments":
                annotation.widgetStringValue = totalPayments.asCurrency
            case "TIL Down Payment":
                annotation.widgetStringValue = downPayment.asCurrency
            case "TIL Total Sale Price":
                annotation.widgetStringValue = totalFinancedJob.asCurrency
            case "Number of Payments":
                annotation.widgetStringValue = String(Int(loanTerm))
            case "Monthly Payment":
                annotation.widgetStringValue = monthlyPayment.asCurrency
            case "First Payment Date":
                let pmtdate = Calendar.current.date(byAdding: .day, value: 45, to: Date())
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                annotation.widgetStringValue = formatter.string(from: pmtdate!)
            case "Date":
                let today = Calendar.current.date(byAdding: .second, value: 30, to: Date())
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                annotation.widgetStringValue = formatter.string(from: today!)
                // added for Scanned SMAC Fillable
            case "Cash Price":
                annotation.widgetStringValue = job.asCurrency
            case "Renewal Years":
                annotation.widgetStringValue = renewalCountTextField.text
            case "Renewals per Year":
                annotation.widgetStringValue = renewalsTextField.text
            case "Renewals Total":
                annotation.widgetStringValue = renewalsTotal.asCurrency
            case "Sales Tax":
                annotation.widgetStringValue = tax.asCurrency
            case "Total Cash Price":
                annotation.widgetStringValue = totalCash.asCurrency
            case "Down Payment":
                annotation.widgetStringValue = downPayment.asCurrency
            case "Amount Financed":
                annotation.widgetStringValue = amountFinanced.asCurrency
            case "Finance Charge":
                annotation.widgetStringValue = financeCharge.asCurrency
            case "Total of Payments":
                annotation.widgetStringValue = totalPayments.asCurrency
            case "Total Sale Price":
                annotation.widgetStringValue = totalFinancedJob.asCurrency
            case "Services":
                annotation.widgetStringValue = "Services...."
            case .none:
                annotation.widgetStringValue =  ""
            case .some(_):
                annotation.widgetStringValue = ""
            }
        }
    }
    func updateView() {
        job = Double(jobTextField.text ?? "0") ?? 0.00
        let rencount = Double(renewalCountTextField.text ?? "0") ?? 0.00
        let renamt = Double(renewalsTextField.text ?? "0") ?? 0.00
        renewalsTotal = renamt * rencount
        totalJob = job + renewalsTotal
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
        let monthlyPaymtStr = monthlyPayment.asCurrency
        monthlyPayment = monthlyPaymtStr.currencyToDouble()
        totalPayments = loanTerm * monthlyPayment
        financeCharge = totalPayments - amountFinanced
        totalFinancedJob = totalPayments + downPayment
        // put it all in a string
        summaryTextBox.text = "Job Amount: \t\t" + job.asCurrency + "\n"
            + "With Renewals: \t\t" + totalJob.asCurrency + "\n"
            + "Tax: \t\t\t\t" + tax.asCurrency + "\n"
            + "Total Cash Price: \t" + totalCash.asCurrency + "\n"
            + "Down Payment: \t\t" + downPayment.asCurrency + "\n"
            + "Amount Financed: \t" + amountFinanced.asCurrency + "\n"
            + "Monthly Payment: \t" + monthlyPaymtStr + "\n"
            + "Number of Payments:  " + String(Int(loanTerm)) + "\n"
            + "Total of Payments: \t" + totalPayments.asCurrency + "\n"
            + "Finance Charge: \t\t" + financeCharge.asCurrency + "\n"
            + "Total Financed Job: \t" + totalFinancedJob.asCurrency
        updatePdf()
    }


}

extension ViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
