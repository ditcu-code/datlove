//
//  ContentView.swift
//  Hover
//
//  Created by Aditya Cahyo on 19/06/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject var globalObject = GlobalObject.shared
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LoveLanguages.llName, ascending: true)]) var loveLanguages : FetchedResults <LoveLanguages>
    var llActivityRec = ListActivityRecommendation()
    @AppStorage("isDoneOnboarding") private var isDoneOnboarding: Bool = false
    @AppStorage("idUser") private var idUser: String = ""
    @AppStorage("idPartner") private var idPartner: String = ""
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            if isDoneOnboarding {
                if globalObject.showCongrats {
                    Congrats()
                        .environmentObject(globalObject)
                } else {
                    HomeScreen()
                        .environmentObject(globalObject)
                }
            } else {
                OnboardingPage()
                    .onAppear() {
//                        CoreDataPreviewHelper.rollbackForApp()
                        if loveLanguages.isEmpty {
                            let llName = [LoveLanguageEnum.physicalTouch.rawValue, LoveLanguageEnum.wordsOfAffirmation.rawValue, LoveLanguageEnum.qualityTime.rawValue, LoveLanguageEnum.receivingGift.rawValue, LoveLanguageEnum.actOfService.rawValue]
                            let detail = ["To this person, nothing speaks more deeply than appropriate physical touch.","This language uses words to affirm other people.", "This language is all about giving the other person your undivided attention.", "For some people, receiving a heartfelt gift is what makes them feel most loved.", "For these people, actions speak louder than words."]
                            
                            for i in 0...llName.count - 1 {
                                saveLL(llname: llName[i], detail: detail[i])
                            }
                            
                            for a in llActivityRec.activityListLL {
                                saveActivityWithLL(activity: a)
                            }
                        }
                    }
                    .environmentObject(globalObject)
            }
        }
    }
    
    func saveLL(llname: String, detail: String){
        let loveLanguage = LoveLanguages(context: moc)
        loveLanguage.id = UUID()
        loveLanguage.llName = llname
        loveLanguage.detail = detail
        try? moc.save()
    }
    
    func saveActivityWithLL(activity: ListActivityRecommendationStructure) {
        let a = ActivityList(context: moc)
        var ll : [LoveLanguages] = []
        for lovelanguage in loveLanguages {
            if lovelanguage.llName == activity.firstLL{
                ll.append(lovelanguage)
            }
            if lovelanguage.llName == activity.secondLL{
                ll.append(lovelanguage)
            }
        }
        a.id = UUID()
        a.activity = activity.activity
        let llActivity = Set(ll)
        for i in llActivity{
            a.addToActivityToLL(i)
        }
        
        try? moc.save()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
