//
//  ViewController.swift
//  Do Plan
//
//  Created by Hossein Akbari on 9/21/1399 AP.
//

import UIKit
import RealmSwift

class HomeController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var scheduledLabel: UILabel!
    
    private let realm = try! Realm()
    private var itemBoxTapped: Constant.TypeOfItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        let allDoItems = realm.objects(Item.self).filter(NSPredicate(format: "done == false"))
        let allReminderItems = allDoItems.filter(NSPredicate(format: "reminder != null"))
        var countTodayTask = 0
        
        allLabel.text = String(allDoItems.count)
        scheduledLabel.text = String(allReminderItems.count)
        
        for item in allReminderItems {
            if let itemRemider = item.reminder {
                if Calendar.current.isDateInToday(itemRemider) {
                    countTodayTask += 1
                }
            }
        }
        todayLabel.text = String(countTodayTask)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ItemsController.identifier {
            let vc = segue.destination as! ItemsController
            vc.loadItems(itemType: itemBoxTapped!)
        }
    }
    
    @IBAction func allTapped(_ sender: UITapGestureRecognizer) {
        itemBoxTapped = .all
        performItemsSegue()
    }
    @IBAction func todayTapped(_ sender: UITapGestureRecognizer) {
        itemBoxTapped = .today
        performItemsSegue()
    }
    @IBAction func scheduledTapped(_ sender: UITapGestureRecognizer) {
        itemBoxTapped = .scheduled
        performItemsSegue()
    }
    
    private func performItemsSegue() {
        performSegue(withIdentifier: ItemsController.identifier, sender: self)
    }
}
