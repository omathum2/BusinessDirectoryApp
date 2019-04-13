import UIKit
import MapKit
import CoreLocation

class BusinessViewController: UIViewController {
    
    //global vars
    //weak var businessInfo : Business?
    
    var businessManagedObject : BusinessDirectory!
    
    
    //outlets & actions
    
    @IBOutlet weak var businessImage: UIImageView!
    
    @IBOutlet weak var businessLabel: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var businessURL: UILabel!
    
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    @IBOutlet weak var businessTownLabel: UILabel!
    
    @IBOutlet weak var eircodeLabel: UILabel!
    
    @IBOutlet weak var mapViewer: MKMapView!
    
    
    @IBOutlet weak var webInfoAction: UIButton!
    
    @IBAction func callButton(_ sender: UIButton) {
        if let url = URL(string: "tel://\(businessManagedObject?.phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //moreInfoAction.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        self.title = "Business Info"
        
        // get the data
        //businessInfo = Business(name: "Mossy", address: "Watergrasshill", phone: "12345", image: "mossy.png", url: "http://www.mossy.com")
        
//        print("\n bManObject: ", "\(businessManagedObject)")
        
        // populate the outlets with data
        businessLabel?.text = businessManagedObject?.name
        businessImage?.image = UIImage(named: (businessManagedObject?.image)!)
        phoneNumber?.text = businessManagedObject?.phone
        
        
        
        
    
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // Get the new view controller using segue.destination.
        let destinationController = segue.destination as! BusinessDetailsViewController
        
        // Pass the selected object to the new view controller.
        destinationController.businessManagedObject = businessManagedObject
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        let destination = segue.destination as! WebViewController
        
        // Pass the selected object to the new view controller.
        destination.urlData = self.businessInfo.url
    }
    */
}
