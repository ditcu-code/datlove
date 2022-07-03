//
//  QuestionLoveLanguage.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 24/06/22.
//

import SwiftUI

struct QuestionLoveLanguage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var globalObject: GlobalObject
    
    @State private var option1Label: String = "Opsi 1"
    @State private var option2Label: String = "Opsi 2"
    @State private var option1Checked: Bool = false
    @State private var option2Checked: Bool = false
    @State private var counter: Int = 0
    @State private var chosenOptions: [String:Int] = ["A": 0, "B": 0, "C": 0, "D": 0, "E": 0]
    @State private var isTestDone: Bool = false
    
    var user: User
    var onboardingStep: Int = 0
    var loveLanguageQuestion = LoveLanguageQuestion()
    
    var body: some View {
        VStack {
            Text("\(counter + 1) / 30")
                .font(.title2)
                .bold()
            Spacer()
            HStack {
                Text("It's more meaningful to me when ...")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding()
            Button {
                option1Checked.toggle()
                processChoice(chosenOption: loveLanguageQuestion.options[counter].valueOption1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    updateUI()
                }
            } label: {
                Text(option1Label)
                    .padding()
                    .frame(width: screenSize * 0.9, height: 100)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: option1Checked ? Color.yellowSun: .black, radius: 1)
            }
            Button {
                option2Checked.toggle()
                processChoice(chosenOption: loveLanguageQuestion.options[counter].valueOption2)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    updateUI()
                }
            } label: {
                Text(option2Label)
                    .padding()
                    .frame(width: screenSize * 0.9, height: 100)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: option2Checked ? Color.yellowSun: .black, radius: 1)
            }
            Spacer()
        }
        .onAppear {
            updateUI()
        }
        .background(
            NavigationLink("", isActive: $isTestDone) {
                TestResultPage(onboardingStep: .constant(onboardingStep + 1), user: user)
            }
        )
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func processChoice(chosenOption: String) {
        chosenOptions[chosenOption] = (chosenOptions[chosenOption] ?? 0) + 1
        if counter+1 < loveLanguageQuestion.options.count {
            counter += 1
        } else {
            saveUserLL()
            isTestDone.toggle()
        }
    }
    
    func updateUI() {
        option1Label = loveLanguageQuestion.options[counter].labelOption1
        option2Label = loveLanguageQuestion.options[counter].labelOption2
        option1Checked = false
        option2Checked = false
    }
    
    func saveUserLL() {
        user.woa = Int32(calculate(value: chosenOptions["A"] ?? 0))
        user.qt = Int32(calculate(value: chosenOptions["B"] ?? 0))
        user.rg = Int32(calculate(value: chosenOptions["C"] ?? 0))
        user.aos = Int32(calculate(value: chosenOptions["D"] ?? 0))
        user.pt = Int32(calculate(value: chosenOptions["E"] ?? 0))
        if user.isUser {
            globalObject.user = user
        } else {
            globalObject.partner = user
        }
        
        try? moc.save()
    }
    
    func calculate(value: Int) -> Int {
        var total = 0
        for option in chosenOptions {
            total += option.value
        }
        
        return (value * 100 / total)
    }
}

struct QuestionLoveLanguage_Previews: PreviewProvider {
    static var previews: some View {
        QuestionLoveLanguage(user: GlobalObject.shared.user)
            .environmentObject(GlobalObject.shared)
    }
}
