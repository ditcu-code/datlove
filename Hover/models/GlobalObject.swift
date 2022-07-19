//
//  GlobalObject.swift
//  Hover
//
//  Created by Eddo Careera Iriyanto Putra on 30/06/22.
//

import Foundation

class GlobalObject: ObservableObject {
    static let shared: GlobalObject = GlobalObject()
    
    @Published var user: User = User()
    @Published var partner: User = User()
    
    @Published var specialDayNoAct : SpecialDay = SpecialDay()
    @Published var specialDayWithAct : SpecialDay = SpecialDay()
    
//    @Published var onboardingStep: Int = 0
    @Published var showCongrats: Bool = false
    @Published var showResult: Bool = false

}
