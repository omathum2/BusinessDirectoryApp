import UIKit
import CoreData
import MapKit
import CoreLocation

class BusinessViewController: UIViewController {
    
    //global vars
    //weak var businessInfo : Business?
    
    var businessManagedObject : BusinessDirectory!
    
    
    //outlets & actions
    
    @IBOutlet weak var businessImage: UIImageView!
    
    @IBOutlet weak var businessLabel: UILabel!
    
    @IBOutlet weak var bizTypeLabel: UILabel!
    
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
        
        // Do any additional setup after loading the view.
        
        self.title = "Business Info"
        
//        print("\n bManObject: ", "\(businessManagedObject)")
        
        // populate the outlets with data
        businessLabel?.text = businessManagedObject?.name
        bizTypeLabel?.text = businessManagedObject?.bizType
        businessImage?.image = UIImage(named: (businessManagedObject?.image)!)
        businessURL?.text = businessManagedObject?.url
        phoneNumber?.text = businessManagedObject?.phone
        businessAddressLabel?.text = businessManagedObject?.address
        businessTownLabel?.text = businessManagedObject?.town
        eircodeLabel?.text = businessManagedObject?.eircode
        
        //map info
        var location = CLLocationCoordinate2DMake(52.0113806, -8.3527962)
        
        var span = MKCoordinateSpan.init(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        var region = MKCoordinateRegion(center: location, span: span)
        mapViewer.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Watergrasshill"
        
        mapViewer.addAnnotation(annotation)
        
        /*
         //make map clickable
         mapViewer.isUserInteractionEnabled = true
         mapViewer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap))
         */
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "webviewSegue" {
        
        // Get the new view controller using segue.destination.
        let destination = segue.destination as! WebViewController
        
        // Pass the selected object to the new view controller.
        destination.urlData = self.businessManagedObject.url
            
        } else if segue.identifier == "editSegue" {
            let destination = segue.destination as! AddViewController
            
            // Pass the selected object to the new view controller.
            destination.businessManagedObject = businessManagedObject
            
        }
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
