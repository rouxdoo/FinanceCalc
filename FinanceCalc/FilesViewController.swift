//
//  FilesViewController.swift
//  FinanceCalc
//
//  Created by Ian Jones on 11/7/18.
//  Copyright © 2018 Ian Jones. All rights reserved.
//
protocol FilesViewDelegate {
    var pdfFormUrl : URL? {get set}
}

import UIKit
import MobileCoreServices

class FilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {

    let sections = ["Default Forms", "Imported Forms"]
    var defForms = ["notareal.pdf", "another.pdf"]
    var mydocs = ["doc.pdf", "doc2.pdf"]
    var defaultTableSelection = IndexPath(row: 0, section: 0)
    var delegate: FilesViewDelegate?
    var pdfFormUrl: URL?
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return defForms.count
        case 1:
            return mydocs.count
        default:
            return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath)
        // Depending on the section, fill the textLabel with the relevant text
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = defForms[indexPath.row]
            break
        case 1:
            cell.textLabel?.text = mydocs[indexPath.row]
            break
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            tableView.beginUpdates()
            var docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            docURL.appendPathComponent(mydocs[indexPath.row])
            do {
                try FileManager.default.removeItem(at: docURL)
            } catch {
                print("--Failed to remove file--")
                print(error.localizedDescription)
            }
            mydocs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: defaultTableSelection)?.accessoryType = .none
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        defaultTableSelection = indexPath
        
        // save selection state
        if UserDefaults.standard.object(forKey: "tabsect") != nil && UserDefaults.standard.object(forKey: "tabrow") != nil {
            UserDefaults.standard.set(defaultTableSelection.section, forKey: "tabsect")
            UserDefaults.standard.set(defaultTableSelection.row, forKey: "tabrow")
        }
        // save file URL
        let fileName: String = (cell?.textLabel?.text)!
        if defaultTableSelection.section == 0 {
            let path = Bundle.main.path(forResource: fileName, ofType: "")
            let url = URL(fileURLWithPath: path!)
            UserDefaults.standard.set(url, forKey: "formurl")
            delegate?.pdfFormUrl = url
        } else {
            let path = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let url = path.appendingPathComponent(fileName)
            UserDefaults.standard.set(url, forKey: "formurl")
            delegate?.pdfFormUrl = url
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }

    @IBOutlet weak var fileTableView: UITableView!
    @IBAction func dissmissPopover(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFiles(_ sender: Any) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: UIDocumentPickerMode.import)
        importMenu.delegate = self
        self.present(importMenu, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentsURL.appendPathComponent(urls[0].lastPathComponent)
        do {
            try FileManager.default.moveItem(at: urls[0], to: documentsURL)
        } catch {
            print("--Failed to move--")
            print(error.localizedDescription)
        }
        mydocs.append(urls[0].lastPathComponent)
        fileTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // set default selection
        fileTableView.selectRow(at: defaultTableSelection, animated: true, scrollPosition: .bottom)
        let cell = fileTableView.cellForRow(at: defaultTableSelection)
        cell?.accessoryType = .checkmark
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        defForms[0] = URL(fileURLWithPath: Bundle.main.path(forResource: "Example Finance Form", ofType: "pdf")!).lastPathComponent
        defForms[1] = URL(fileURLWithPath: Bundle.main.path(forResource: "SMAC Scanned Fillable", ofType: "pdf")!).lastPathComponent

        // get all docs in document directory
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // Filter for PDF only
        do {
            let directoryUrls = try  FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            let PDFFiles = directoryUrls.filter(){ $0.pathExtension == "pdf" }.map{ $0.lastPathComponent }
            // Set TableView array for saved files to DocumentDirectory PDFs
            mydocs = PDFFiles
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.fileTableView.allowsSelectionDuringEditing = true
        self.fileTableView.allowsMultipleSelection = false
        
        // register UserDefaults if unset
        if UserDefaults.standard.object(forKey: "formurl") == nil {
            let blank = URL(fileURLWithPath: Bundle.main.path(forResource: "Example Finance Form", ofType: "pdf")!)
            UserDefaults.standard.register(defaults: ["formurl" : blank])
        } else {
            pdfFormUrl = UserDefaults.standard.url(forKey: "formurl")
        }
        if UserDefaults.standard.object(forKey: "tabsect") == nil || UserDefaults.standard.object(forKey: "tabrow") == nil {
            UserDefaults.standard.register(defaults: ["tabsect" : 0])
            UserDefaults.standard.register(defaults: ["tabrow" : 0])
        } else {
            defaultTableSelection = IndexPath(row: UserDefaults.standard.integer(forKey: "tabrow"), section: UserDefaults.standard.integer(forKey: "tabsect"))
            // check to see if default was deleted while selected
            if defaultTableSelection.section == 1 && mydocs.count == 0 {
                defaultTableSelection.section = 0
                defaultTableSelection.row = 0
            }
            if defaultTableSelection.section == 1 && defaultTableSelection.row >= mydocs.count {
                defaultTableSelection.row = defaultTableSelection.row - 1
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
