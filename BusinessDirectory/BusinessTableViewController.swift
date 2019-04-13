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
class BusinessTableViewController: UITableViewController, NSFetchedResultsControllerDelegate  {

    
    // var of type BusinessInfo
//    var xmlBusiness : BusinessInfo!
    
    // Core data objects context entity managedObject and frc
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity : NSEntityDescription! = nil
    var businessManagedObject : BusinessDirectory! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red:0.85, green:0.92, blue:0.96, alpha:1.0)
        
        self.title = "Local Businesses"
        
        //get the data from XML and store in var
//        xmlBusiness = BusinessInfo(fromContentOfXML: "watergrasshill_business_directory.xml")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessDirectory")
        
        var count = -1
        
        //calls function that clears out Core Data
        deleteAllData(entity: "BusinessDirectory")
        
        do { try
        count = context.count(for: makeRequest())
        print("\n", count)
        } catch {
        //catch nothing
        }
        
        
        if count == 0 {
            fromXMLtoCoreData()
            print("\n xml core")
           
        }
        
        //make a frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{
            try frc.performFetch()
            print("\n Perform fetch worked")
        }
        catch{print(" Fetch does not work")}
        
        //print("\(NSHomeDirectory())")
        

    }
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessDirectory")
        print("\n Fetch Request Done")
        
        //describe how to sort and how to filter it
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        print("\n Sort Done")
        
        
        // let predicate = NSPredicate(format: "%K == %@", "name", "sabin")
        //request.predicate = predicate
        
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
        // #warning Incomplete implementation, return the number of rows
        //return manyBusinessesInfo.count()
        return frc.sections![section].numberOfObjects
    }


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
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("segue activated")

        // Get the new view controller using segue.destination.
        let destination = segue.destination as! BusinessViewController

        // Pass the selected object to the new view controller
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)

        businessManagedObject = (frc.object(at: indexPath!) as! BusinessDirectory)
            
            print("\n table view bManObject: ", "(businessManagedObject)")

        destination.businessManagedObject = businessManagedObject
            
            print("\n dest bManObject: ", "\(String(describing: destination.businessManagedObject))")
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
            
            //entity = NSEntityDescription.entity(forEntityName: "LocalBusiness", in: context)
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
}
