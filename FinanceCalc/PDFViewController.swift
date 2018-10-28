//
//  PDFViewController.swift
//  FinanceCalc
//
//  Created by Ian Jones on 10/25/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

    let documentInteractionController = UIDocumentInteractionController()
    
    var fin = FinanceStruct(job: 0, renewalCount: 0, renewalAmount: 0, taxRate: 0, apr: 0, term: 0, percentDown: 0, lastName: "",  firstName: "", middleInitial: "", address: "", city: "", state: "", zip: "", phone1: "", phone2: "", email: "", ssn: "", serviceAddress: "", description: "")
    
    var pdfData: PDFDocument?

    @IBOutlet weak var pdfView: PDFView!
    
    @IBAction func sharePdf(_ sender: UIBarButtonItem) {
        let tmpURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("SMAC.pdf")
        pdfView.document?.write(to: tmpURL)
        documentInteractionController.url = tmpURL
        documentInteractionController.uti = "com.adobe.pdf"
        documentInteractionController.presentOptionsMenu(from: sender, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "SMAC Scanned Fillable", ofType: "pdf")
        let url = URL(fileURLWithPath: path!)
        if  let pdfDocument = PDFDocument(url: url) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.document = pdfDocument
            pdfData = pdfDocument
            let annotations = pdfDocument.page(at: 0)?.annotations
            for annotation in annotations! {
                if (annotation.widgetFieldType == .button) {
                    continue
                }
                switch annotation.fieldName {
                // this data fills mobility smac fillable -pdfescape.com
                case "Services":
                    annotation.widgetStringValue = fin.description
                case "Last Name":
                    annotation.widgetStringValue = fin.lastName
                case "First Name":
                    annotation.widgetStringValue = fin.firstName
                case "MI":
                    annotation.widgetStringValue = fin.middleInitial
                case "Address":
                    annotation.widgetStringValue = fin.address
                case "City":
                    annotation.widgetStringValue = fin.city
                case "State":
                    annotation.widgetStringValue = fin.state
                case "Zip":
                    annotation.widgetStringValue = fin.zip
                case "Phones":
                    annotation.widgetStringValue = fin.phone1 + "\n" + fin.phone2
                case "Email":
                    annotation.widgetStringValue = fin.email
                case "SSN":
                    annotation.widgetStringValue = fin.ssn
                case "Service Address":
                    annotation.widgetStringValue = fin.serviceAddress
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
                case "Cash Price":
                    annotation.widgetStringValue = fin.job.asCurrency
                case "Renewal Years":
                    annotation.widgetStringValue = String(fin.renewalCount)
                case "Renewals per Year":
                    annotation.widgetStringValue = fin.renewalAmount.asCurrency
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
                case .none:
                    annotation.widgetStringValue =  ""
                case .some(_):
                    annotation.widgetStringValue = ""
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
