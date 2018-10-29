//
//  ViewController.swift
//  FinanceCalc
//
//  Created by Ian Jones on 10/17/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import UIKit
import PDFKit

class ManualFinanceViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
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
    @IBOutlet weak var renewalAmountLabel: UILabel!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var miTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var ssnTextField: UITextField!
    @IBOutlet weak var phone1TextField: UITextField!
    @IBOutlet weak var phone2TextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var serviceAddressTextBox: UITextView!
    @IBOutlet weak var descriptionTextBox: UITextView!
    @IBOutlet weak var serviceCityTextField: UITextField!
    @IBOutlet weak var serviceStateTextField: UITextField!
    @IBOutlet weak var serviceZipTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var fin = FinanceStruct(job: 0, renewalCount: 0, renewalAmount: 0, taxRate: 0, apr: 0, term: 0, percentDown: 0, lastName: "",  firstName: "", middleInitial: "", address: "", city: "", state: "", zip: "", phone1: "", phone2: "", email: "", ssn: "", serviceAddress: "", serviceCity: "", serviceState: "", serviceZip: "", description: "")
    
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
        lastNameTextField.text = ""
        firstNameTextField.text = ""
        miTextField.text = ""
        addressTextField.text = ""
        cityTextField.text = ""
        stateTextField.text = ""
        zipTextField.text = ""
        phone1TextField.text = ""
        phone2TextField.text = ""
        emailTextField.text = ""
        ssnTextField.text = ""
        serviceAddressTextBox.text = "Service Address - same as above"
        serviceCityTextField.text = ""
        serviceStateTextField.text = ""
        serviceZipTextField.text = ""
        descriptionTextBox.text = "Services..."
        serviceAddressTextBox.textColor = UIColor.lightGray
        descriptionTextBox.textColor = UIColor.lightGray
        renewalAmountLabel.textColor = UIColor.black
        renewalCountLabel.textColor = UIColor.black
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobTextField.delegate = self
        renewalsTextField.delegate = self
        renewalCountTextField.delegate = self
        summaryTextBox.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        miTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        phone1TextField.delegate = self
        phone2TextField.delegate = self
        emailTextField.delegate = self
        ssnTextField.delegate = self
        serviceAddressTextBox.delegate = self
        serviceCityTextField.delegate = self
        serviceStateTextField.delegate = self
        serviceZipTextField.delegate = self
        descriptionTextBox.delegate = self
        
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == self.lastNameTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 160), animated: true)
        }
        else if (textField == self.firstNameTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 160), animated: true)
        }
        else if (textField == self.miTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 160
            ), animated: true)
        }
        else if (textField == self.addressTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 190), animated: true)
        }
        else if (textField == self.cityTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 230), animated: true)
        }
        else if (textField == self.stateTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 230), animated: true)
        }
        else if (textField == self.zipTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 230), animated: true)
        }
        else if (textField == self.phone1TextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 260), animated: true)
        }
        else if (textField == self.phone2TextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 260), animated: true)
        }
        else if (textField == self.emailTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 260), animated: true)
        }
        else if (textField == self.ssnTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 310), animated: true)
        }
        else if (textField == self.serviceCityTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 410), animated: true)
        }
        else if (textField == self.serviceStateTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 410), animated: true)
        }
        else if (textField == self.serviceZipTextField) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 410), animated: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        updateView()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if (textView == self.serviceAddressTextBox) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 410), animated: true)
        }
        else if (textView == self.descriptionTextBox) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 410), animated: true)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == self.serviceAddressTextBox) {
            if textView.text.isEmpty {
                textView.text = "Service Address - same as above"
                textView.textColor = UIColor.lightGray
            } else {
                textView.textColor = UIColor.black
            }
        }
        if (textView == self.descriptionTextBox) {
            if textView.text.isEmpty {
                textView.text = "Services..."
                textView.textColor = UIColor.lightGray
            } else {
                textView.textColor = UIColor.black
            }
        }
        textView.resignFirstResponder()
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        self.updateView()
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
        
        fin.lastName = lastNameTextField.text ?? ""
        fin.firstName = firstNameTextField.text ?? ""
        fin.middleInitial = miTextField.text ?? ""
        fin.address = addressTextField.text ?? ""
        fin.city = cityTextField.text ?? ""
        fin.state = stateTextField.text ?? ""
        fin.zip = zipTextField.text ?? ""
        fin.phone1 = phone1TextField.text ?? ""
        fin.phone2 = phone2TextField.text ?? ""
        fin.email = emailTextField.text ?? ""
        fin.ssn = ssnTextField.text ?? ""
        fin.serviceAddress = serviceAddressTextBox.text ?? ""
        fin.serviceCity = serviceCityTextField.text ?? ""
        fin.serviceState = serviceStateTextField.text ?? ""
        fin.serviceZip = serviceZipTextField.text ?? ""
        fin.description = descriptionTextBox.text ?? ""
        
        var minren = 0 // minimum renewals if job is renewable
        switch fin.term {
        case 12:
            minren = 1
        case 18:
            minren = 1
        case 24:
            minren = 2
        case 36:
            minren = 3
        case 48:
            minren = 4
        case 60:
            minren = 5
        default:
            minren = 0
        }

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
            if (minren > fin.renewalCount) {
                if (fin.renewalAmount > 0) {
                    renewalCountLabel.textColor = UIColor.red
                    renewalAmountLabel.textColor = UIColor.red
                }
            } else {
                renewalCountLabel.textColor = UIColor.black
                renewalAmountLabel.textColor = UIColor.black
            }
        } else {
            renewalCountTextField.textColor = UIColor.black
            renewalCountLabel.textColor = UIColor.black
            loanMonthsLabel.textColor = UIColor.black
            loanMonthsLabel.text = "Loan Months"
            loanMonthsButton.setTitleColor(.black, for: .normal)
        }
        summaryTextBox.text = "Finance Job Details:\n\n"
            + "Number of Payments:  " + String(fin.term) + "\n"
            + "Monthly Payment: \t" + fin.monthlyPayment().asCurrency + "\n"
            + "Down Payment: \t\t" + fin.downPayment().asCurrency + "\n\n"
            + "Job Amount: \t\t" + fin.job.asCurrency + "\n"
            + "With Renewals: \t\t" + fin.totalJobPretax().asCurrency + "\n"
            + "Tax: \t\t\t\t" + fin.taxes().asCurrency + "\n"
            + "Total Cash Price: \t" + fin.totalCashPrice().asCurrency + "\n\n"
            + "Amount Financed: \t" + fin.amountFinanced().asCurrency + "\n"
            + "Finance Charge: \t\t" + fin.financeCharge().asCurrency + "\n"
            + "Total of Payments: \t" + fin.totalOfPayments().asCurrency + "\n"
            + "Total Financed Job: \t" + fin.totalFinancedJob().asCurrency
    }
}

