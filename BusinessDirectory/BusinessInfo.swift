//
//  BusinessData.swift
//  BusinessDirectory
//
//  Created by Mossy O Mahony on 18/02/2019.
//  Copyright © 2019 Mossy O Mahony. All rights reserved.
//

import Foundation

class BusinessInfo{
    
    var businessInfo : [Business]
    
    init(){
        
        // Business Info Data Array
        businessInfo = []

    }
    
    init(fromContentOfXML : String){
        
        //make an XMLPeopleParser
        let parser = XMLBusinessParser(name: fromContentOfXML)
        
        
        //parsing
        parser.parsing()
        
        //set peopleData with what comes from Parsing
        businessInfo = parser.businesses
    }
    
    func count() -> Int { return businessInfo.count}
    func businessInfo(index:Int)->Business {return businessInfo[index]}
}
