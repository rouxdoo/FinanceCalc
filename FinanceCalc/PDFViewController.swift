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
    
    var fin = FinanceStruct(job: 0, renewalCount: 0, renewalAmount: 0, taxRate: 0, apr: 0, term: 0, percentDown: 0, lastName: "",  firstName: "", middleInitial: "", address: "", city: "", state: "", zip: "", phone1: "", phone2: "", email: "", ssn: "", serviceAddress: "", serviceCity: "", serviceState: "", serviceZip: "", description: "")
    var pdfFormUrl: URL?    // expecting this to contain user-chosen form
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

        // test using a default doc just in case selections failed
        if pdfFormUrl == nil {
            pdfFormUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "TXFinanceCalc Privacy Policy", ofType: "pdf")!)
        }
        print("In pdf VC")
        print(pdfFormUrl as Any)
        if  let pdfDocument = PDFDocument(url: pdfFormUrl!) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.document = pdfDocument
            pdfData = pdfDocument
            // repeat/while to go through all pages
            var pageCount = 0
            repeat {
                let annotations = pdfDocument.page(at: pageCount)?.annotations
                for annotation in annotations! {
                    if (annotation.widgetFieldType == .button) {
                        continue
                    }
                    //annotation.font = UIFont.boldSystemFont(ofSize: 8)
                    annotation.fontColor = UIColor.blue
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
                    case "Service City":
                        annotation.widgetStringValue = fin.serviceCity
                    case "Service State":
                        annotation.widgetStringValue = fin.serviceState
                    case "Service Zip":
                        annotation.widgetStringValue = fin.serviceZip
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
                pageCount += 1
            } while pageCount < pdfDocument.pageCount
        }
    }
}
