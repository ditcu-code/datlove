//
//  ActivityPage.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 24/06/22.
//

import SwiftUI

struct ActivityPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var globalObject: GlobalObject
    @FetchRequest(sortDescriptors: []) var activities : FetchedResults <ActivityList>
    @FetchRequest(sortDescriptors: []) var loveLanguages : FetchedResults <LoveLanguages>
    @FetchRequest(sortDescriptors: []) var users : FetchedResults <User>
    @State private var listActivities : [[(ActivityList,LoveLanguages)]] = [[]]
    @State private var randomElement: [(ActivityList,LoveLanguages)] = []
    @State private var filteredActivities: [ActivityList] = []
    @State private var randomActivities: [ActivityList] = []
    
    let maximumRecommendation = 2
    
    var loveLanguageUser: LoveLanguageUser {
        LoveLanguageUser(user: globalObject.user)
    }
    var loveLanguagePartner: LoveLanguageUser {
        LoveLanguageUser(user: globalObject.partner)
    }
    var body: some View {
        //        NavigationView {
        ZStack(alignment:.topLeading) {
            Rectangle().fill(.clear)
            Image("bg-home").resizable().aspectRatio(contentMode: .fit).ignoresSafeArea()
            VStack {
                HStack{
                    Spacer()
                }.frame(height: UINavigationBar.appearance().bounds.height)
                HStack {
                    Text("Have you done this together 👩‍❤️‍👨 \nwith \(globalObject.partner.wrappedName)?").font(.headline).padding(.horizontal)
                    Spacer()
                }
                
                HStack {
                    if !filteredActivities.isEmpty {
                        LoveLanguageLogoBg(loveLanguageName: getLLLogo(llData: filteredActivities[0].llArray) , size: 45, cornerRadius: 8)
                    }
                    ZStack(alignment: .topLeading) {
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft]).fill(.black).opacity(0.5)
                        VStack(alignment: .leading) {
                            if !filteredActivities.isEmpty {
                                Text(filteredActivities[0].wrappedActivity)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                                Spacer()
                                HStack {
                                    ForEach(filteredActivities[0].llArray) { ll in
                                        HStack {
                                            LoveLanguageLogoBg(loveLanguageName: ll.wrappedLLName, size: 30, cornerRadius: 90)
                                            Text(ll.wrappedLLName).font(.caption)
                                        }
                                    }
                                }
                            }
                            
                        }.padding()
                    }
                    .frame(height: 120)
                    .foregroundColor(.white)
                }.padding(.leading)
                
                HStack {
                    Text("Have you tried these activities to \(globalObject.partner.wrappedName)? \nHe definitely will happy 🤩").font(.headline).padding()
                        .lineLimit(nil)
                    Spacer()
                }
                VStack {
                    ForEach(randomActivities, id: \.self) { act in
                        ActivityListItem(activity: act)
                    }
                }.padding(.leading, 20)
            }
            
            .navigationTitle("Activities")
        }
        .onAppear{
            getActivity()
            randomizeActivity()
        }
    }
    
    func randomizeActivity() {
        randomActivities = []
        while randomActivities.count < maximumRecommendation {
            let random = filteredActivities.randomElement()!
            let isExist = randomActivities.filter { activity in
                activity.wrappedActivity == random.wrappedActivity || random.wrappedActivity == filteredActivities[0].wrappedActivity
            }
            if isExist.count == 0 {
                randomActivities.append(random)
            }
        }
    }
    
    func getActivity(){
        let userPrimaryLL = getPrimaryLoveLanguageUser()
        let partnerPrimaryLL = getPrimaryLoveLanguagePartner()
        let partnerSecondaryLL = getSecondaryLoveLanguagePartner()
        
        let filteredActivites = activities.filter { activity in
            return activity.llArray.filter{ loveLanguage in
                loveLanguage.wrappedLLName == userPrimaryLL || loveLanguage.wrappedLLName == partnerPrimaryLL || loveLanguage.wrappedLLName == partnerSecondaryLL
            }.count > 0
        }
        
        let sortBasedOnLL = filteredActivites.sorted { a, b in
            a.llArray.count > b.llArray.count
        }
        
        self.filteredActivities = sortBasedOnLL
    }
    func getPrimaryLoveLanguageUser() -> String {
        return loveLanguageUser.getPrimaryLoveLanguage()
    }
    func getPrimaryLoveLanguagePartner() -> String {
        return loveLanguagePartner.getPrimaryLoveLanguage()
    }
    func getSecondaryLoveLanguagePartner() -> String {
        return loveLanguagePartner.getSecondaryLoveLanguage()
    }
}

struct ActivityListItem: View {
    let activity: ActivityList
    
    var body: some View {
        HStack {
            LoveLanguageLogoBg(loveLanguageName: getLLLogo(llData: activity.llArray) , size: 45, cornerRadius: 8)
            ZStack {
                getLoveLanguageBg(loveLanguage: getLLLogo(llData: activity.llArray))
                    .resizable()
                    .frame(width: 308, height: 120)
                    .overlay {
                        VStack {
                            HStack {
                                Text(activity.wrappedActivity)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.leading, 15)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                ForEach(activity.llArray, id: \.self) { ll in
                                    Text(ll.wrappedLLName).font(.subheadline)
                                        .padding(.trailing, 5)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
            }
        }
    }
}

struct ActivityPage_Previews: PreviewProvider {
    static var previews: some View {
        ActivityPage()
            .environmentObject(GlobalObject.shared)
            .environment(\.managedObjectContext, CoreDataPreviewHelper.preview.container.viewContext)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct IconLL: View {
    var loveLanguage: [LoveLanguages]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(Color.bgCombination).frame(width: 45, height: 45)
            
            LoveLanguageLogoBg(loveLanguageName: getLLLogo(llData: loveLanguage) , size: 45, cornerRadius: 8)
            
        }
    }
}

