//
//  DetailViewController.swift
//  SiriNotes
//
//  Created by Steven Beyers on 6/14/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var managedObjectContext: NSManagedObjectContext?
    
    var isShowingNewItem: Bool = false {
        didSet {
            if let context = managedObjectContext, isShowingNewItem {
                let newNote = Note(context: context)
                
                // Save the context.
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
                self.detailItem = newNote
            }
        }
    }

    func configureView() {
        if let detailItem = detailItem {
            titleTextField?.isHidden = false
            detailsTextView?.isHidden = false
            titleTextField?.text = detailItem.title
            detailsTextView?.text = detailItem.details
        } else {
            titleTextField?.isHidden = true
            detailsTextView?.isHidden = true
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        configureView()
    }

    @objc
    func save(_ sender: Any) {
        detailItem?.title = titleTextField?.text
        detailItem?.details = detailsTextView?.text
        
        do {
            try managedObjectContext?.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    var detailItem: Note? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

