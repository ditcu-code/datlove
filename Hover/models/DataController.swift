//
//  DataController.swift
//  Hover
//
//  Created by Muhammad Aleandro on 26/06/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    static let shared = DataController()
    
    //    let container: NSPersistentContainer = {
    //        // call the XCDataModel name
    //        let container = NSPersistentContainer(name: "datLoveModel")
    //
    //        // load persistent stores
    //        container.loadPersistentStores{ description, error in
    //            if let error = error{
    //                print("Core datanya gagal di load :( : \(error.localizedDescription)")
    //            }
    //        }
    //        return container
    //    }()
    
    let container : NSPersistentContainer
    
    init(inMemory : Bool = false){
        container = NSPersistentContainer(name: "datLoveModel")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores{ description, error in
            if let error = error{
                print("Core datanya gagal di load :( : \(error.localizedDescription)")
            }
        }
    }
}
