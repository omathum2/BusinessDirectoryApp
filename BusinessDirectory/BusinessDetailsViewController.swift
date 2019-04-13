import UIKit
import MapKit
import CoreLocation

class BusinessDetailsViewController: UIViewController {
    
    //global vars
    var businessManagedObject : BusinessDirectory! = nil
    
    //outlets & actions
    
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var businessPhoneLabel: UILabel!
    
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    @IBOutlet weak var businessTownLabel: UILabel!
    
    @IBOutlet weak var eircodeLabel: UILabel!
    
    @IBOutlet weak var businessUrlLabel: UILabel!
    
    @IBAction func webInfoAction(_ sender: Any) {
    }
    
    //outlet for mapViewer
    @IBOutlet weak var mapViewer: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Business Details"
        
        // Do any additional setup after loading the view.
        
        // personData coming from screen one, so no need to initialise
        
        //populate outlets with data
        businessNameLabel.text = businessManagedObject.name
        businessPhoneLabel.text = businessManagedObject.phone
        businessAddressLabel.text = businessManagedObject.address
        businessUrlLabel.text = businessManagedObject.url
        businessTownLabel.text = businessManagedObject.town
        eircodeLabel.text = businessManagedObject.eircode
                
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
    
    /*
    // Func in your UIViewController
    @objc func imageTap() {
        var instagramHooks = "instagram://user?username=johndoe"
        var instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL)
        {
            UIApplication.shared.openURL(instagramUrl! as URL)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    */
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        let destination = segue.destination as! WebViewController
        
        // Pass the selected object to the new view controller.
        destination.urlData = self.businessManagedObject.url
    }
    

}
