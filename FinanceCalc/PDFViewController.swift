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
    var fin = FinanceStruct(job: 0, renewalCount: 0, renewalAmount: 0, taxRate: 0, apr: 0, term: 0, percentDown: 0)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
