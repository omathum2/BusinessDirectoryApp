/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Base or common view controller to share a common UITableViewCell prototype between subclasses.
 */

import UIKit
import CoreData

class BaseTableViewController: UITableViewController {
    
    // Core data objects context entity managedObject and frc
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity : NSEntityDescription! = nil
    var businessManagedObject : BusinessDirectory! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    // MARK: - Properties
    
    var filteredBiz = [BusinessDirectory]()
    private var numberFormatter = NumberFormatter()
    
    // MARK: - Constants
    
    static let tableViewCellIdentifier = "cellID"
    private static let nibName = "TableCell"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        tableView.register(nib, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
    }
    
    // MARK: - Configuration
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        businessManagedObject = frc.object(at: indexPath) as? BusinessDirectory
        
        cell.businessNameView?.text = businessManagedObject.name
        //        print("\n bManObject: ", "\(businessManagedObject)")
        
        cell.businessTypeView?.text = businessManagedObject?.bizType
        //
        cell.businessImageView!.image = UIImage(named: (businessManagedObject?.image)!)
        
        return cell
    }
        
}
