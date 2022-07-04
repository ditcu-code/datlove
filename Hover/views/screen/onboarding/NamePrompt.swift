//
//  UsernamePrompt.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 24/06/22.
//

import SwiftUI

struct NamePrompt: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var globalObject: GlobalObject
    
//    @Binding var onboardingStep: Int
    @State var username: String = ""
    @State var isNavigateActive: Bool = false
    var user: User = User()
    var partner: User = User()
    
    var disabledForm: Bool {
        username.isEmpty
    }
    
    var onboardingStep: Int {
        globalObject.onboardingStep
    }
    
    var progress: Int {
        onboardingStep + 1
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                VStack {
                    ProgressView(value: (Float(progress) / Float(onboardingTotalStep)))
                        .animation(.easeInOut(duration: 1), value: onboardingTotalStep)
                        .padding(.bottom, 160)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(self.onboardingStep == 0 ? "Hello,\n": "and...\n")What is\n\(self.onboardingStep == 0 ? "your": "your partner") name?")
                                .font(.title)
                                .bold()
                        }
                        Spacer()
                    }
                }.padding(.bottom, 50)
                TextField(self.onboardingStep == 0 ? "Your Name" : "Partner Name", text: $username)
                    .modifier(ClearButton(text: $username))
                    .padding()
                    .frame(height: 44)
                    .background(.white)
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 1)
                Spacer()
                NavigationLink(isActive: self.$isNavigateActive) {
                    if self.onboardingStep == 1 {
                        NamePrompt()
                    } else if self.onboardingStep == 2 {
                        SpecialDatePrompt()
                    }
                } label: {
                }.hidden()
                Button {
                    saveName()
                    globalObject.onboardingStep += 1
                    self.isNavigateActive.toggle()
                } label: {
                    OnboardingNextButton(isDisabled: disabledForm)
                        .padding(.bottom, 115)
                }
                .disabled(disabledForm)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    func saveName() {
        let user = User(context: moc)
        user.id = UUID()
        user.name = username
        user.isUser = onboardingStep == 0 ? true : false
        try? moc.save()
        
        if user.isUser {
//            GlobalObject.shared.user = user
            globalObject.user = user
            UserDefaults.standard.set(user.id?.uuidString ?? "user", forKey: "idUser")
        } else {
//            GlobalObject.shared.partner = user
            globalObject.partner = user
            UserDefaults.standard.set(user.id?.uuidString ?? "partner", forKey: "idPartner")
        }
    }
}

struct NamePrompt_Previews: PreviewProvider {
    static var previews: some View {
        NamePrompt()
            .environmentObject(GlobalObject.shared)
    }
}
