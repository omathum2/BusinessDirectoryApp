import UIKit
import CoreData

//custom table view cell
class BusinessCell: UITableViewCell {
    
    // outlets & actions
    @IBOutlet weak var businessImageView: UIImageView!
    
    @IBOutlet weak var businessNameView: UILabel!
    
    @IBOutlet weak var businessTypeView: UILabel!

}

//main class for populating tableview
class BusinessTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate  {
//UISearchResultsUpdating,

    
    // Core data objects context entity managedObject and frc
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity : NSEntityDescription! = nil
    var businessManagedObject : BusinessDirectory! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    var tableData = [BusinessDirectory]()
    
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red:0.85, green:0.92, blue:0.96, alpha:1.0)
        
        self.title = "Local Businesses"
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessDirectory")
        
        var count = -1
        
        //calls function that clears out Core Data
        deleteAllData(entity: "BusinessDirectory")
        
        //what does this do?
        do { try
        count = context.count(for: makeRequest())
            print("\n count:", count)
        } catch {
        //catch nothing
        }
        
        if count == 0 {
            fromXMLtoCoreData()
        }
        
        //make a frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        print("\n frc: ", (frc))
        
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }
        catch{print(" Fetch does not work")}
        
        setUpSearchBar()
        
        tableView.reloadData()
        

    }
    
    //search queries
    override func viewWillAppear(_ animated: Bool) {
        
        self.viewDidLoad()
//        self.tableView.reloadData()
        
    }
    
    func makeRequest(selectedScopeIdx:Int?=nil,targetText:String?=nil)->NSFetchRequest<NSFetchRequestResult>{
        
        print("targetText", (targetText))
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessDirectory")
        
        if selectedScopeIdx != nil && targetText != nil{

            var filterKeyword = ""
            switch selectedScopeIdx! {
            case 0:
                filterKeyword = "name"
            case 1:
                filterKeyword = "bizType"
            default:
                filterKeyword = "name"
            }
        
            var predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", targetText!)
            request.predicate = predicate
        }
        
        //describe how to sort and how to filter it
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        //        print("\n Sort Done")
        
        return request
        
    }
    
    //delete all data in core data
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

    
    // Change bg color of tableview
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //reload data after fetching new results
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
    
    //number of sections in tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return frc.sections![section].numberOfObjects
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
//        if (resultSearchController.isActive) {
//
//            cell.textLabel?.text = filteredTableData[indexPath.row]
//
//            return cell
//        }
//        else {
        
            businessManagedObject = frc.object(at: indexPath) as? BusinessDirectory
            
            cell.businessNameView?.text = businessManagedObject.name
    //        print("\n bManObject: ", "\(businessManagedObject)")
            
            cell.businessTypeView?.text = businessManagedObject?.bizType
    //
            cell.businessImageView!.image = UIImage(named: (businessManagedObject?.image)!)
            
            return cell
//        }
        
    }
    
    //functions to delete entries in table
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            //get the object to remove and delete it
            businessManagedObject = (frc.object(at: indexPath) as! BusinessDirectory)
            context.delete(businessManagedObject)
            
            //save the conext
            do {try context.save()}
            catch{}
            
            //preform  fetch the reload
            do{try frc.performFetch()}
            catch{}
            
            tableView.reloadData()
        }
    }
    
    //function to populate core data from XML
    func fromXMLtoCoreData() {
        
        print("xml2core called")
        
        let parser = XMLBusinessParser(name: "watergrasshill_business_directory.xml")
        
        parser.parsing()
//        print("\n parser: ", parser)
        
        //businessManagedObject = BusinessDirectory(context: context)
        
        let businesses = parser.businesses
//        print("\n businesses:", businesses)
        
        for business in businesses {
            
            businessManagedObject = BusinessDirectory(context: context)
            
            //fill with data from textfields
            businessManagedObject.name = business.name
//            print("\n XMLcore bname ", businessManagedObject.name)
            businessManagedObject.address = business.address
            businessManagedObject.town = business.town
            businessManagedObject.phone = business.phone
            businessManagedObject.eircode = business.eircode
            businessManagedObject.bizType = business.bizType
            businessManagedObject.image = business.image
            businessManagedObject.url = business.url
//            print("\n XMLcore bname ", "\(businessManagedObject)")
            
            //save
            do{
                try context.save()
                //print(business.name)
            }catch{
                print("Core Data error")
            }
            //copyImage(name: business.image!)
        
        }
        
    }
    
    // MARK: - Private instance methods
    
    //new search functions
    fileprivate func setUpSearchBar() {
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 65))
        
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name","Business Type"]
        searchBar.selectedScopeButtonIndex = 0
        
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            
            tableView.reloadData()
            return
        }
        
        frc = NSFetchedResultsController(fetchRequest: makeRequest(selectedScopeIdx: searchBar.selectedScopeButtonIndex, targetText:searchText), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }
        catch{print(" Fetch does not work")}
        
        
//        print("\n frc from searchbar: ", (frc))
//
//        frc = makeRequest(selectedScopeIdx: searchBar.selectedScopeButtonIndex, targetText:searchText)
        tableView.reloadData()
        print(searchText)
        
    
    }
    
    //search funcs
//    func updateSearchResults(for searchController: UISearchController) {
//
//        filteredTableData.removeAll(keepingCapacity: false)
//
//        //var error:NSError?
//
//        let searchString = searchController.searchBar.text!
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessDirectory")
//
//        do {
//            tableData = try context.fetch(fetchRequest) as! [BusinessDirectory]
//        } catch {
//            print("fetch for array failed")
//        }
//
//        print("\n tableDataArray Contents: ", (tableData))
//
//        let predicate = NSPredicate(format: "%K CONTAINS[c] %@", searchString)
//        //"SELF CONTAINS[c] %@"
//
//        let array = NSArray(array: tableData).filtered(using: predicate)
//
////        let array = (tableData as NSArray).filtered(using: predicate)
//
//        filteredTableData = array as! [String]
//
//
//
//        self.tableView.reloadData()
//    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsSegue" {
            print("details segue activated")
            
            // Get the new view controller using segue.destination.
            let destination = segue.destination as! BusinessViewController
            
            // Pass the selected object to the new view controller
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            businessManagedObject = (frc.object(at: indexPath!) as! BusinessDirectory)
            
            //                print("\n table view bManObject: ", "(businessManagedObject)")
            
            destination.businessManagedObject = businessManagedObject
            
            print("\n dest bManObject: ", "\(String(describing: destination.businessManagedObject))")
        } else if segue.identifier == "addSegue" {
            
            // Get the new view controller using segue.destination.
            let destination = segue.destination as! AddViewController
            
            // Pass the selected object to the new view controller
            print("\n table view bManObject: ", "(businessManagedObject)")
            
        }
    }
    
//end class
}


