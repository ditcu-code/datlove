//
//  CoreDataPreviewHelper.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 02/07/22.
//

import Foundation
import CoreData

class CoreDataPreviewHelper {
//    static var preview: DataController = {
//        let result = DataController.init(inMemory: true)
//        let viewContext = result.container.viewContext
//        var llActivityRec = ListActivityRecommendation()
//        var lls : [LoveLanguages] = []
//        
//        let user = User(context: viewContext)
//        user.id = UUID()
//        user.woa = 22
//        user.aos = 23
//        user.pt = 21
//        user.qt = 20
//        user.rg = 14
//        user.isUser = true
//        GlobalObject.shared.user = user
//        
//        let partner = User(context: viewContext)
//        partner.id = UUID()
//        partner.woa = 23
//        partner.aos = 22
//        partner.pt = 20
//        partner.qt = 21
//        partner.rg = 14
//        partner.isUser = false
//        GlobalObject.shared.partner = partner
//        
//        let specialDay = SpecialDay(context: viewContext)
//        specialDay.id = UUID()
//        specialDay.name = "Special Day Name"
//        specialDay.date = Date.now
//        GlobalObject.shared.specialDayNoAct = specialDay
//        
//        let llName = [LoveLanguageEnum.physicalTouch.rawValue, LoveLanguageEnum.wordsOfAffirmation.rawValue, LoveLanguageEnum.qualityTime.rawValue, LoveLanguageEnum.receivingGift.rawValue, LoveLanguageEnum.actOfService.rawValue]
//        let detail = ["To this person, nothing speaks more deeply than appropriate physical touch.","This language uses words to affirm other people.", "This language is all about giving the other person your undivided attention.", "For some people, receiving a heartfelt gift is what makes them feel most loved.", "For these people, actions speak louder than words."]
//        
//        for i in 0...llName.count - 1 {
//            let loveLanguage = LoveLanguages(context: viewContext)
//            loveLanguage.id = UUID()
//            loveLanguage.llName = llName[i]
//            loveLanguage.detail = detail[i]
//            
//            lls.append(loveLanguage)
//        }
//        
//        let specialDayWithAct = SpecialDay(context: viewContext)
//        let dummyActivity = ActivityList(context: viewContext)
//        dummyActivity.activity = "Isi Activity"
//        let dummyLL = lls.first!
//        dummyActivity.addToActivityToLL(dummyLL)
//        specialDayWithAct.id = UUID()
//        specialDayWithAct.name = "Special Day Name"
//        specialDayWithAct.date = Date.now
//        specialDayWithAct.addToSpecialToActivity(dummyActivity)
//        GlobalObject.shared.specialDayWithAct = specialDayWithAct
//        
//        for a in llActivityRec.activityListLL {
//            saveActivityWithLL(activity: a)
//        }
//        
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        
//        func saveActivityWithLL(activity: ListActivityRecommendationStructure) {
//            let a = ActivityList(context: viewContext)
//            var ll : [LoveLanguages] = []
//            for lovelanguage in lls {
//                if lovelanguage.llName == activity.firstLL{
//                    ll.append(lovelanguage)
//                }
//                if lovelanguage.llName == activity.secondLL{
//                    ll.append(lovelanguage)
//                }
//            }
//            a.id = UUID()
//            a.activity = activity.activity
//            let llActivity = Set(ll)
//            for i in llActivity{
//                a.addToActivityToLL(i)
//            }
//        }
//        
//        return result
//    }()
    
//    static var dummyUser: User = User()
//
//    static var dummyUser: User = {
//        let controller = DataController.shared
//        let user = User(context: controller.container.viewContext)
//        user.id = UUID()
//        user.woa = 23
//        user.aos = 22
//        user.pt = 21
//        user.qt = 20
//        user.rg = 14
//
//        return user
//    }()
//
//    static var initialUser: User = {
//        let controller = DataController.shared
//        let user = User(context: controller.container.viewContext)
//        user.id = UUID()
//        user.woa = 0
//        user.aos = 0
//        user.pt = 0
//        user.qt = 0
//        user.rg = 0
//
//        return user
//    }()
//
//    static var dummySpecialDayEmptyActivity: SpecialDay = {
//        let controller = DataController.shared
//        let specialDay = SpecialDay(context: controller.container.viewContext)
//        specialDay.id = UUID()
//        specialDay.name = "Special Day Name"
//        specialDay.date = Date.now
//
//        return specialDay
//    }()
//
//    static var dummySpecialDayWithActivity: SpecialDay = {
//        let controller = DataController.shared
//        let specialDay = SpecialDay(context: controller.container.viewContext)
//        let dummyActivity = ActivityList(context: controller.container.viewContext)
//        dummyActivity.activity = "Isi Activity"
//        let dummyLL = LoveLanguages(context: controller.container.viewContext)
//        dummyLL.llName = LoveLanguageEnum.qualityTime.rawValue
//        dummyActivity.activityToLL = [dummyLL]
//        specialDay.id = UUID()
//        specialDay.name = "Special Day Name"
//        specialDay.date = Date.now
//        specialDay.specialToActivity = [dummyActivity]
//
//        return specialDay
//    }()
    
//    static func rollbackForApp() {
//        let context = DataController.shared.container.viewContext
//        context.rollback()
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LoveLanguages")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            // TODO: handle the error
//            print(error)
//        }
//    }
}
