//
//  SpecialDateList.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 24/06/22.
//

import SwiftUI
import CoreData

struct SpecialDatePage: View {
    @FetchRequest(sortDescriptors: []) var specialDays : FetchedResults <SpecialDay>
    @State var navActive : Bool = false
    @State var selectedSpecialDay : SpecialDay?
    @State var goToDetail : Bool = false
    
    var upcomingDay: SpecialDay {
        specialDays.sortedByIncomingEvent()[0]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .topLeading) {
                Rectangle().fill(.clear)
                Image("bg-home")
                    .resizable()
                    .ignoresSafeArea()
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.white)
                        .opacity(0.3)
                        .frame(height: 120)
                    
                    HStack(alignment: .center, spacing: 40) {
                        VStack(alignment: .center) {
                            Text("\(dateToString(upcomingDay.wrappedDate, dateFormat: "MMM").uppercased())")
                                .font(.title2)
                                .bold()
                            Text("\(dateToString(upcomingDay.wrappedDate, dateFormat: "dd"))")
                                .font(.system(size: 36, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.captionColor)
                                .frame(width: 90, height: 90)
                        )
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(upcomingDay.wrappedName)
                                    .font(.title3)
                                    .bold()
                                if !upcomingDay.activityInSDArray.isEmpty {
                                    Text(upcomingDay.activityInSDArray[0].wrappedActivity)
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .font(.title2)
                        }.padding(.trailing, 10)
                    }
                    .padding(.leading, 50)
                    .onTapGesture {
                        selectedSpecialDay = upcomingDay
                        goToDetail.toggle()
                    }
                }.padding(.top, 15)
            }.frame(height: 150)
            NavigationLink(isActive: $goToDetail) {
                SpecialDayDetail(selectedSpecialDay: selectedSpecialDay ?? SpecialDay())
            } label: {
                
            }
            ScrollView {
                ForEach(specialDays.sortedByIncomingEvent().filter({ specialDay in
                    specialDay.id != upcomingDay.id ?? UUID()
                })) { specialDayItem in
                    if specialDayItem.activityInSDArray.isEmpty {
                        EmptyActivitySpecialDayCard(specialDayItem: specialDayItem)
                            .onTapGesture {
                                selectedSpecialDay = specialDayItem
                                goToDetail.toggle()
                            }
                    }
                    else {
                        WithActivitySpecialDayCard(specialDayItem: specialDayItem)
                            .onTapGesture {
                                selectedSpecialDay = specialDayItem
                                goToDetail.toggle()
                            }
                    }
                }
            }
            
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {navActive.toggle()}) {
                    Label("Hello", systemImage: "plus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.title)
                }
            }
        }
        
        .sheet(isPresented: $navActive){
            SpecialDateForm()
        }
        
        .navigationTitle("Upcoming")
        .navigationBarTitleDisplayMode(.large)
        
    }
}

extension Collection where Element == SpecialDay {
    func sortedByIncomingEvent() -> [Element] {
        sorted { lhs, rhs in
            if lhs.date == nil { return false }
            let lhs = lhs.date ?? .distantFuture
            let rhs = rhs.date ?? .distantFuture
            let lhsMonth = Calendar.current.component(.month, from: lhs)
            let lhsDay = Calendar.current.component(.day, from: lhs)
            let rhsMonth = Calendar.current.component(.month, from: rhs)
            let rhsDay = Calendar.current.component(.day, from: rhs)
            let currMonth = Calendar.current.component(.month, from: Date())
            let currDay = Calendar.current.component(.day, from: Date())
            // lhs date is today or is in the future
            return (lhsMonth, lhsDay) >= (currMonth, currDay) ?
            // rhs date is today or is in the future
            (rhsMonth, rhsDay) >= (currMonth, currDay) ?
            // sort them by a month day order
            (lhsMonth, lhsDay) < (rhsMonth, rhsDay) :
            // otherwise is in increasing order
            true :
            // lhs date is in the past
            // sort them by a month day order
            (lhsMonth, lhsDay) < (rhsMonth, rhsDay)
        }
    }
}

struct WithActivitySpecialDayCard: View {
    var specialDayItem : SpecialDay
    
    var body: some View {
        HStack{
            VStack {
                Text(dateToString(specialDayItem.wrappedDate, dateFormat: "MMM").uppercased()).font(.subheadline)
                Text(dateToString(specialDayItem.wrappedDate, dateFormat: "dd")).font(.title).bold()
            }
            .padding(.leading, 20)
            .padding(.trailing, 5)
            
            ZStack {
                RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft]).fill(Color.combination)
                RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft]).fill(Color.white).offset(x: 10, y:0).scaleEffect(0.99)
                
                HStack {
                    LoveLanguageLogoBg(loveLanguageName: LoveLanguageEnum.combination.rawValue, size: 45, cornerRadius: 8)
                    VStack(alignment: .leading) {
                        Text(specialDayItem.wrappedName).font(.headline)
                        Text(specialDayItem.activityInSDArray.first?.wrappedActivity ?? "" ).lineLimit(1)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .frame(height: 80)
            }
        }
    }
}

struct EmptyActivitySpecialDayCard: View {
    var specialDayItem: SpecialDay
    
    var body: some View {
        HStack{
            ZStack {
                RoundedCorner(radius: 8, corners: [.topRight, .bottomRight]).fill(Color.combination)
                RoundedCorner(radius: 8, corners: [.topRight, .bottomRight]).fill(Color.white).offset(x: -10, y:0).scaleEffect(0.99)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(specialDayItem.wrappedName)
                            .font(.headline)
                        Text("Have you planned activities?").lineLimit(1)
                    }
                    
                    LoveLanguageLogoBg(loveLanguageName: "", size: 45, cornerRadius: 8)
                }
                .padding(.trailing, 25)
                .padding(.leading, 10)
                .frame(height: 80)
                
            }
            
            VStack {
                Text(dateToString(specialDayItem.wrappedDate, dateFormat: "MMM").uppercased()).font(.subheadline)
                Text(dateToString(specialDayItem.wrappedDate, dateFormat: "dd")).font(.title).bold()
            }
            .padding(.trailing, 20)
            .padding(.leading, 5)
            
        }
    }
}
//
//struct SpecialDatePage_Previews: PreviewProvider {
//    static var previews: some View {
//        SpecialDatePage()
//            .environmentObject(GlobalObject.shared)
//            .environment(\.managedObjectContext, CoreDataPreviewHelper.preview.container.viewContext)
//    }
//}
