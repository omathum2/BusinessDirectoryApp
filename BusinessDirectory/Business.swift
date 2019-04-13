import Foundation
import UIKit

class Business
{
    // properties
    var name        : String
    var address     : String
    var town        : String
    var phone       : String
    var image       : String
    var url         : String
    var eircode     : String
    var bizType     : String
    
    
    // initalisers
    init() {
        
        self.name       = "John Doe"
        self.address    = "No Known Address"
        self.town       = "Town"
        self.phone      = "None"
        self.image      = "None"
        self.url        = "None"
        self.eircode    = "None"
        self.bizType     = "None"
        
    }
    
    init(name:String, address:String, town: String, phone:String, image:String, url:String, eircode: String, bizType: String) {
        
        self.name    = name
        self.address = address
        self.town    = town
        self.phone   = phone
        self.image   = image
        self.url     = url
        self.eircode = eircode
        self.bizType = bizType
        
    }
    
    // methods
    func setName(name:String){self.name = name}
    func getName()->String{return self.name}
    
    func setAddress(address:String){self.address = address}
    func getAddress()->String{return self.address}
    
    func setTown(town:String){self.town = town}
    func getTown()->String{return self.town}
    
    func setPhone(phone:String){self.phone = phone}
    func getPhone()->String{return self.phone}
    
    func setImage(image:String){self.image = image}
    func getImage()->String{return self.image}
    
    func setUrl(url:String){self.url = url}
    func getUrl()->String{return self.url}
    
    func setEircode(eircode:String){self.eircode = eircode}
    func getEircode()->String{return self.eircode}

    func setBizType(bizType:String){self.bizType = bizType}
    func getBizType()->String{return self.bizType}
}

