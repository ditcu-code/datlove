//
//  SpecialDateEditForm.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 08/07/22.
//

import SwiftUI

struct SpecialDayEditForm: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var globalObject: GlobalObject
    
    var selectedSpecialDay: SpecialDay
    
    @State var navActive: Bool = false
    @State private var specialDayName: String = ""
    @State private var isRepeated: Bool = true
    @State private var isActivityWanted: Bool = true
    
    @State var selectedDate = Date()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var activities : FetchedResults <ActivityList>
    @State var actSelections: [ActivityList] = []
    @State private var selectedRepeat: Repeat = .monthly
    @State private var selectedAlert: Alert = .oneDay
    @State var showAddPlan: Bool = false
    
    var body: some View {
        let nameNotEmpty = specialDayName.count > 0
        
        NavigationView {
            VStack(alignment: .center) {
                
                VStack(alignment: .leading) {
                    
                    Text("I want to **celebrate**")
                    
                    TextField("", text: $specialDayName)
                        .textFieldStyle(.roundedBorder)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor))
                    
                    if nameNotEmpty {
                        HStack {
                            
                            Text("on").bold()
                            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                .labelsHidden()
                                .scaleEffect(1.1)
                                .padding(.horizontal, 5)
                            
                            Text("and")
                            Button(isRepeated ? "would" : "wouldn't") {
                                withAnimation(.easeInOut) {
                                    isRepeated.toggle()
                                }
                            }.buttonStyle(.bordered)
                        }
                        
                        HStack {
                            
                            Text("be repeated\(isRepeated ? "" : ".")")
                            if isRepeated {
                                Menu(selectedRepeat.rawValue) {
                                    ForEach(Repeat.allCases, id: \.self) { item in
                                        Button(item.rawValue) {
                                            selectedRepeat = item
                                        }
                                    }
                                }.menuStyle(GrayButtonStyle())
                            }
                            
                        }
                        
                        HStack {
                            Text("Please **remind** me")
                            Menu(selectedAlert.rawValue) {
                                ForEach(Alert.allCases, id: \.self) { a in
                                    Button(a.rawValue) {
                                        selectedAlert = a
                                    }
                                }
                            }.menuStyle(GrayButtonStyle(width: 115))
                        }
                        
                        Text("before the date.")
                    }
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(.white))
                
                if nameNotEmpty {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("I think, I")
                            Button(isActivityWanted ? "want" : "haven't") {
                                withAnimation(.easeInOut) {
                                    isActivityWanted.toggle()
                                }
                            }.buttonStyle(.bordered)
                            Text("to do some")
                        }
                        HStack {
                            Text("activities during the celebration.")
                            Spacer()
                        }
                        
                        if isActivityWanted {
                            ScrollView() {
                                ActivityItem(actSelections: $actSelections)
                            }
                        }
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(.white))
                }
                Spacer()
                
            }
            .padding()
            .font(.title2)
            .background(Color.backgroundColor)
            .animation(.default, value: nameNotEmpty)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveData()
                        dismiss()
                    }){
                        Text("Save").bold()
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    if nameNotEmpty {
                        if isActivityWanted {
                            withAnimation {
                                Button(action: {showAddPlan.toggle()}) {
                                    Label("I have my own activitiy plan", systemImage: "plus.circle.fill").labelStyle(.titleAndIcon)
                                }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if isActivityWanted {
                        Spacer()
                    }
                }
            }
            .navigationTitle("Edit Special Day")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                specialDayName = selectedSpecialDay.wrappedName
                selectedAlert = Alert(rawValue: selectedSpecialDay.wrappedAlert) ?? .oneDay
                selectedRepeat = Repeat(rawValue: selectedSpecialDay.wrappedRepeatNotif) ?? .monthly
                actSelections = selectedSpecialDay.activityInSDArray
            }
        }
        
        .sheet(isPresented: $showAddPlan) {
            AddActivityForm(actSelections: $actSelections)
        }
    }
    
    func saveData(){
        selectedSpecialDay.date = selectedDate
        selectedSpecialDay.name = specialDayName
        selectedSpecialDay.repeatNotif = selectedRepeat.rawValue
        selectedSpecialDay.alert = selectedAlert.rawValue
        let sdActivity = Set(actSelections)
        for act in sdActivity{
            selectedSpecialDay.addToSpecialToActivity(act)
        }
        try? moc.save()
    }
}
//
//struct SpecialDayEditForm_Previews: PreviewProvider {
//    static var previews: some View {
//        SpecialDayEditForm(selectedSpecialDay: GlobalObject.shared.specialDayWithAct)
//            .environment(\.managedObjectContext, CoreDataPreviewHelper.preview.container.viewContext)
//            .environmentObject(GlobalObject.shared)
//    }
//}
