import Foundation

class XMLBusinessParser : NSObject, XMLParserDelegate {
    var name:String
    
    init(name:String){self.name = name}
    
    // variables to hold tag data
    var bName, bAddress, bTown, bPhone, bImage, bURL, bEircode, bBizType : String!
    
    // vars to spy during parsing
    var elementID = -1
    var passData = false
    
    // vars to manage whole data
    var business = Business()
    var businesses = [Business]()
    
    
    var parser = XMLParser()
    
    var tags = ["name", "street_address", "town", "telephone", "image", "website", "eircode", "business_type"]
    
    // parser delegate methods
    
    // overwrite parser
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //print("\n XML Parser", businesses)
        
        //based on the spies, grab some data into pVars
        if passData{
            switch elementID{
                case 0 : bName = string
                case 1 : bAddress = string
                case 2 : bTown = string
                case 3 : bPhone = string
                case 4 : bImage = string
                case 5 : bURL = string
                case 6 : bEircode = string
                case 7 : bBizType = string
                default: break
                
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        //if elementName is in tags then spy
        if tags.contains(elementName) {
        
            passData = true
        
            switch elementName {
                case "name" : elementID = 0
                case "street_address" : elementID = 1
                case "town" : elementID = 2
                case "telephone" : elementID = 3
                case "image" : elementID = 4
                case "website" : elementID = 5
                case "eircode" : elementID = 6
                case "business_type" : elementID = 7
                default : break
            }
        }
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
            //reset the spies
            if tags.contains(elementName){
                passData  = false
                elementID = -1
            }
        
            //if elementName is business, make a Business object and append it to Businesses
            if elementName == "row" {
                business = Business(name: bName, address: bAddress, town: bTown, phone: bPhone, image: bImage, url: bURL, eircode: bEircode, bizType: bBizType)
                businesses.append(business)
            }

        }
    
    func parsing(){
        
        //get the path of the xml file
        let bundleURL = Bundle.main.bundleURL
        let fileURL = URL(fileURLWithPath: self.name, relativeTo: bundleURL)
        
        //make a parser for this file
        parser = XMLParser(contentsOf: fileURL)!
        
        //give the delegate and parse
        parser.delegate = self
        parser.parse()
    }
        
    
    
}
