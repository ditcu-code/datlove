//
//  HomeScreen.swift
//  Hover
//
//  Created by Aditya Cahyo on 19/06/22.
//

import SwiftUI
import CoreData

struct HomeScreen: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var globalObject: GlobalObject
    
    var body: some View {
        TabView {
            NavigationView {
                ActivityPage()
                    .environmentObject(globalObject)
            }
            .tabItem {
                VStack {
                    Image(systemName: "lightbulb")
                    Text("Activities")
                }
            }
            NavigationView {
                SpecialDatePage()
            }
            .tabItem {
                VStack {
                    Image(systemName: "calendar.badge.exclamationmark")
                    Text("Special Day")
                }
            }
            NavigationView {
                ProfilePage()
            }
            .tabItem {
                VStack {
                    Image(systemName: "person.2.wave.2.fill")
                    Text("Profile")
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .onAppear {
            loadCurrentUser()
        }
        .onChange(of: scenePhase) { _ in
            loadCurrentUser()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func loadCurrentUser() {
        let idUser = UserDefaults.standard.string(forKey: "idUser")
        let idPartner = UserDefaults.standard.string(forKey: "idPartner")
        
        let request: NSFetchRequest<User> = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "id IN %@", [idUser, idPartner])
        
        do {
            let users = try moc.fetch(request)
            for i in users {
                if i.id?.uuidString == idUser {
                    globalObject.user = i
                } else if i.id?.uuidString == idPartner {
                    globalObject.partner = i
                }
            }
        } catch {
            print("gagal query \(error.localizedDescription)")
        }
    }
}
//
//struct HomeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreen()
//            .environment(\.managedObjectContext, CoreDataPreviewHelper.preview.container.viewContext)
//            .environmentObject(GlobalObject.shared)
//    }
//}
