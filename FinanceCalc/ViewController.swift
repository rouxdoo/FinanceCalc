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
                annotation.widgetStringValue = String(fin.apr)
            case "TIL Finance Charge":
                annotation.widgetStringValue = fin.financeCharge().asCurrency
            case "TIL Amount Financed":
                annotation.widgetStringValue = fin.amountFinanced().asCurrency
            case "TIL Total of Payments":
                annotation.widgetStringValue = fin.totalOfPayments().asCurrency
            case "TIL Down Payment":
                annotation.widgetStringValue = fin.downPayment().asCurrency
            case "TIL Total Sale Price":
                annotation.widgetStringValue = fin.totalFinancedJob().asCurrency
            case "Number of Payments":
                annotation.widgetStringValue = String(fin.term)
            case "Monthly Payment":
                annotation.widgetStringValue = fin.monthlyPayment().asCurrency
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
                annotation.widgetStringValue = fin.job.asCurrency
            case "Renewal Years":
                annotation.widgetStringValue = String(fin.renewalCount)
            case "Renewals per Year":
                annotation.widgetStringValue = String(fin.renewalAmount)
            case "Renewals Total":
                annotation.widgetStringValue = fin.renewalsTotal().asCurrency
            case "Sales Tax":
                annotation.widgetStringValue = fin.taxes().asCurrency
            case "Total Cash Price":
                annotation.widgetStringValue = fin.totalCashPrice().asCurrency
            case "Down Payment":
                annotation.widgetStringValue = fin.downPayment().asCurrency
            case "Amount Financed":
                annotation.widgetStringValue = fin.amountFinanced().asCurrency
            case "Finance Charge":
                annotation.widgetStringValue = fin.financeCharge().asCurrency
            case "Total of Payments":
                annotation.widgetStringValue = fin.totalOfPayments().asCurrency
            case "Total Sale Price":
                annotation.widgetStringValue = fin.totalFinancedJob().asCurrency
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
