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
    @State private var selectedActivity: [(ActivityList,LoveLanguages)] = []
    @State private var selectedActivity1: [(ActivityList,LoveLanguages)] = []
    @State private var selectedActivity2: [(ActivityList,LoveLanguages)] = []
    @State private var selectedActivity3: [(ActivityList,LoveLanguages)] = []
    @State private var listActivities : [[(ActivityList,LoveLanguages)]] = [[]]
    @State private var randomElement: [(ActivityList,LoveLanguages)] = []
    @State private var filteredOneActivities: [ActivityList] = []
    @State private var filteredTwoActivities: [ActivityList] = []
    @State private var randomTwoActivities: [ActivityList] = []
    @State private var randomOneActivities: [ActivityList] = []
    //    [
    //      (ActivityList, LoveLanguages) ?
    //        ActivityList -> [LoveLanguages]
    //      let activity = ActivityList
    //      loveLanguages = activity.llArray
    //      for i in loveLanguages { }
    //    ]
    //    [(ActivityList, LoveLanguages)]
    //    @Binding var partner: User
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
            
            
            VStack(alignment: .leading) {
                Text("Have you done this together 👩‍❤️‍👨 \nwith \(globalObject.partner.wrappedName)?").font(.headline).padding(.horizontal)
                ForEach(randomTwoActivities, id: \.self) { act in
                    HStack {
                        LoveLanguageLogoBg(loveLanguageName: getLLLogo(llData: act.llArray) , size: 45, cornerRadius: 8)
                        ZStack {
                            RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft]).fill(.black).opacity(0.5)
                            VStack(alignment: .leading) {
                                Text(act.wrappedActivity)
                                    .font(.title3)
                                    .bold()
                                    .padding(.leading, 15)
                                Spacer()
                                HStack {
                                    Spacer()
                                    ForEach(act.llArray, id: \.self) { ll in
                                        Text(ll.wrappedLLName).font(.subheadline)
                                    }
                                }
                            }.padding()
                        }
                        .frame(height: 120)
                        .foregroundColor(.white)
                    }.padding(.leading)
                }
                Text("Have you tried these activities to \(globalObject.partner.wrappedName)? \nHe definitely will happy 🤩").font(.headline).padding()
                    .lineLimit(nil)
                ForEach(randomOneActivities, id: \.self) { act in
                    HStack {
                        LoveLanguageLogoBg(loveLanguageName: getLLLogo(llData: act.llArray) , size: 45, cornerRadius: 8)
                            
                        ZStack {
                            getLoveLanguageBg(loveLanguage: getLLLogo(llData: act.llArray))
                            VStack(alignment: .leading) {
                                Text(act.wrappedActivity)
                                    .font(.title3)
                                    .bold()
                                    .padding(.leading, 15)
                                Spacer()
                                HStack {
                                    Spacer()
                                    ForEach(act.llArray, id: \.self) { ll in
                                        Text(ll.wrappedLLName).font(.subheadline)
                                    }
                                }
                            }.padding(10)
                        }
                    }.padding(.leading).frame(height: 120)
                }
            }
            
            .navigationTitle("Activities")
        }
        .onAppear{
            getActivity()
            randomizeOneActivity()
            randomizeTwoActivity()
        }
    }
    
    func randomizeOneActivity() {
        randomOneActivities = []
        while randomOneActivities.count < 3 {
            let random = filteredOneActivities.randomElement()!
            let isExist = randomOneActivities.filter { activity in
                activity.wrappedActivity == random.wrappedActivity || random.wrappedActivity == filteredOneActivities[0].wrappedActivity
            }
            if isExist.count == 0 {
                if random.llArray.count<2{
                    randomOneActivities.append(random)
                }
            }
        }
    }
    func randomizeTwoActivity() {
        randomTwoActivities = []
        while randomTwoActivities.count < 1 {
            let random = filteredTwoActivities.randomElement()!
            let isExist = randomTwoActivities.filter { activity in
                activity.wrappedActivity == random.wrappedActivity || random.wrappedActivity == filteredTwoActivities[0].wrappedActivity
            }
            if isExist.count == 0 {
                if random.llArray.count == 2{
                    randomTwoActivities.append(random)
                }
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
        
        self.filteredTwoActivities = sortBasedOnLL
        self.filteredOneActivities = sortBasedOnLL
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

