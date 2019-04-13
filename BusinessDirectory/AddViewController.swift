

import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //core data objects context, entity and manageObjects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var entity : NSEntityDescription! = nil
    var businessManagedObject : BusinessDirectory! = nil
    
    
    func save(){ //save a new managed object
        
        //make a new managed object
        //entity = NSEntityDescription.entity(forEntityName: "business", in: context)
        businessManagedObject = BusinessDirectory(context: context)
        
        //fill with data from textfields
        businessManagedObject.name    = nameTextField.text
        businessManagedObject.phone   = phoneTextField.text
        businessManagedObject.address = addressTextField.text
        businessManagedObject.image = imageNameTextField.text
        
        //save
        do{
            try context.save()
        }catch{
            print("Core Data error")
        }
        saveImage(name: imageNameTextField.text!)
    }
    
    func update(){ //save businessManagedObject
        
        //fill with data from textfields
        businessManagedObject.name    = nameTextField.text
        businessManagedObject.phone   = phoneTextField.text
        businessManagedObject.address = addressTextField.text
        businessManagedObject.image = imageNameTextField.text
        
        //save
        do{
            try context.save()
        }catch{
            print("Core Data error")
        }
        saveImage(name: imageNameTextField.text!)
    }
    
    
    //outlets and action
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var imageNameTextField: UITextField!
    
    @IBOutlet weak var pickedImageView: UIImageView!
    
    @IBAction func pickImageAction(_ sender: Any) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            // set up the picker
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            // present the picker
            present(imagePicker, animated:true, completion: nil)
        }
    }
    func  imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // code to pickup image from gallery
    
    let imagePicker = UIImagePickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get the image from the picker
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // place the image to image view
        pickedImageView.image = image
        
        // dismiss the picker
        dismiss(animated: true, completion: nil)
        
    }
    
    func saveImage(name:String) {
        // get file mnager
        let fm = FileManager.default
        
        // get path to document
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        // append name to path
        let path = docPath.appendingPathComponent(name)
        
        // grab image
        let data = pickedImageView.image!.pngData()
        
        // file manager save data
        fm.createFile(atPath: path, contents: data, attributes: nil)
    }
    func getImage(name:String) {
        // get file mnager
        let fm = FileManager.default
        
        // get path to document
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        // append name to path
        let path = docPath.appendingPathComponent(name)
        
        // test is name exists and load it
        if fm.fileExists(atPath: path){
            pickedImageView.image = UIImage(contentsOfFile: path)
        }else{
            print("file does not exist")
        }
    }
    
    
    @IBAction func addUpdatedAction(_ sender: Any) {
        
        
        
        if businessManagedObject != nil{
            update()
        }else{
            save()
        }
        
        //force navigation back to TVC
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Add or Update"
        
        // present the data of businessManageObject
        if businessManagedObject != nil{
            nameTextField.text    = businessManagedObject.name
            phoneTextField.text   = businessManagedObject.phone
            addressTextField.text = businessManagedObject.address
            imageNameTextField.text = businessManagedObject.image
            
            if imageNameTextField.text != nil{
                getImage(name: imageNameTextField.text!)
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
