//
//  InfoViewController.swift
//  Pricing
//
//  Created by Ian Jones on 10/23/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//

import UIKit
import PDFKit

class InfoViewController: UIViewController {

    var pdfData: PDFDocument?
    
    @IBOutlet var pdfView: PDFView!

    @IBAction func goWebsite(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://www.freeprivacypolicy.com/privacy/view/44a31abd0208a57ece4dfc61f4d5472f")! as URL)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "TXFinanceCalc Privacy Policy", ofType: "pdf")
        let url = URL(fileURLWithPath: path!)
        if  let pdfDocument = PDFDocument(url: url) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.document = pdfDocument
            pdfData = pdfDocument
            
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
