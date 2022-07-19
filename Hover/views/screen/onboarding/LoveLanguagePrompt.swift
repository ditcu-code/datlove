//
//  LoveLanguagePrompt.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 24/06/22.
//

import SwiftUI

struct LoveLanguagePrompt: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var globalObject: GlobalObject
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LoveLanguages.llName, ascending: true)]) var loveLanguages : FetchedResults <LoveLanguages>
    
//    @Binding var onboardingStep: Int
    var user: User = GlobalObject.shared.user
    @State var isNavigationActive: Bool = false
    @State var isGotoTest: Bool = false
    @State var llselections: [LoveLanguages] = []
    
    var onboardingStep: Int = 4
    
    var progress: Int {
        onboardingStep + 1
    }
    
    var disabledForm: Bool {
        llselections.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                VStack {
                    ProgressView(value: (Float(progress) / Float(onboardingTotalStep)))
                        .animation(.easeInOut(duration: 1), value: onboardingTotalStep)
                        .padding(.bottom, 50)
                    HStack {
                        Text("What is your\nLove Language?")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                }
                Spacer()
                ForEach(loveLanguages, id: \.self) { loveLanguage in
                    LoveLanguageOption(title: loveLanguage.llName ?? "Unknown", isSelected: self.llselections.contains(loveLanguage)) {
                        if self.llselections.contains(loveLanguage) {
                            self.llselections.removeAll(where: { $0 == loveLanguage})
                        } else {
                            if self.llselections.count < 1 {
                                self.llselections.append(loveLanguage)
                            } else {
                                self.llselections.removeAll()
                                self.llselections.append(loveLanguage)
                            }
                        }
                    }.padding(.bottom, 10)
                }
                Spacer().frame(height: 20)
                NavigationLink(isActive: $isNavigationActive) {
                    TestResultPage(user: user, onboardingStep: self.onboardingStep + 2)
                } label: {
                }
                VStack {
                    Button {
                        saveLoveLanguage()
//                        globalObject.onboardingStep += 2
                        self.isNavigationActive.toggle()
                    } label: {
                        OnboardingNextButton(isDisabled: disabledForm)
                            .disabled(disabledForm)
                    }
                    .padding(.bottom, 35)
                    Text("Don't know your Love Language yet?")
                        .font(.subheadline)
                        .foregroundColor(Color("CaptionColor"))
                    NavigationLink(isActive: $isGotoTest) {
                        LoveLanguagePageController(user: user, onboardingStep: self.onboardingStep + 1)
//                        QuestionLoveLanguage(user: user, onboardingStep: onboardingStep + 1)
                    } label: {
                    }
                    Button {
//                        globalObject.onboardingStep += 1
                        isGotoTest.toggle()
                    } label: {
                        Text("Take the test now")
                            .foregroundColor(.black)
                            .underline()
                            .padding(.bottom, 60)
                    }
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
        }
    }
    
    func saveLoveLanguage() {
        let updatedUser = self.onboardingStep == 4 ? globalObject.user : globalObject.partner

        switch(llselections[0].llName) {
        case LoveLanguageEnum.actOfService.rawValue:
            updatedUser.aos = Int32(100)
        case LoveLanguageEnum.wordsOfAffirmation.rawValue:
            updatedUser.woa = Int32(100)
        case LoveLanguageEnum.physicalTouch.rawValue:
            updatedUser.pt = Int32(100)
        case LoveLanguageEnum.qualityTime.rawValue:
            updatedUser.qt = Int32(100)
        case LoveLanguageEnum.receivingGift.rawValue:
            updatedUser.rg = Int32(100)
        default:
            print(llselections[0].llName ?? "")
            print("Do Nothing")
        }
//        print(updatedUser)
        
        try? moc.save()
        if self.onboardingStep == 4 {
//            GlobalObject.shared.user = updatedUser
            globalObject.user = updatedUser
        } else {
//            GlobalObject.shared.partner = updatedUser
            globalObject.partner = updatedUser
        }
    }
}

private struct LoveLanguageOption: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                Spacer()
                if self.isSelected {
                    Checklist(size: 25)
                }
            }
            .padding()
            .frame(height: 44)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: self.isSelected ? Color.activeButtonColor : .black, radius: 1)
        }
    }
}
//
//struct LoveLanguagePrompt_Previews: PreviewProvider {
//    static var previews: some View {
//        LoveLanguagePrompt()
//            .environment(\.managedObjectContext, CoreDataPreviewHelper.preview.container.viewContext)
//            .environmentObject(GlobalObject.shared)
//    }
//}
