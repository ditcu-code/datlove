//
//  Func.swift
//  MC1-Group12
//
//  Created by Aditya Cahyo on 20/05/22.
//

import Foundation
import SwiftUI

let screenSize = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let onboardingTotalStep = 10

enum LoveLanguageEnum: String {
    case actOfService = "Acts of Service", qualityTime = "Quality Time", receivingGift = "Receiving Gifts", physicalTouch = "Physical Touch", wordsOfAffirmation = "Word of Affirmation", combination = "Combination"
}

func dateToString(_ date: Date, dateFormat: String = "dd MMM yyyy") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    let someDateTime = formatter.string(from: date)
    return someDateTime
}

func getLoveLanguageByCode(code: String) -> String {
    switch code {
    case "A":
        return "Words of Affirmation"
    case "B":
        return "Quality Time"
    case "C":
        return "Receiving Gifts"
    case "D":
        return "Acts of Service"
    case "E":
        return "Physical Touch"
    default:
        return ""
    }
}

func getLoveLanguageSymbolName(code: String) -> String {
    switch code {
    case "A":
        return "character.bubble.fill"
    case "B":
        return "clock.fill"
    case "C":
        return "gift.fill"
    case "D":
        return "fork.knife"
    case "E":
        return "hand.point.up.fill"
    default:
        return ""
    }
}

func getLoveLanguageColorName(code: String) -> String {
    switch code {
    case "A":
        return "WordsOfAffirmation"
    case "B":
        return "QualityTime"
    case "C":
        return "ReceivingGift"
    case "D":
        return "ActOfService"
    case "E":
        return "PhysicalTouch"
    default:
        return ""
    }
}

func getLoveLanguageIcon(loveLanguage: String) -> Image {
    switch loveLanguage {
    case LoveLanguageEnum.actOfService.rawValue:
        return Image(systemName: "fork.knife")
    case LoveLanguageEnum.receivingGift.rawValue:
        return Image(systemName: "gift.fill")
    case LoveLanguageEnum.physicalTouch.rawValue:
        return Image(systemName: "hand.point.up.fill")
    case LoveLanguageEnum.qualityTime.rawValue:
        return Image(systemName: "clock.fill")
    case LoveLanguageEnum.wordsOfAffirmation.rawValue:
        return Image(systemName: "character.bubble.fill")
    case LoveLanguageEnum.combination.rawValue:
        return Image(systemName: "heart.fill")
    default:
        return Image(systemName: "hourglass")
    }
}

func getLoveLanguageColor(loveLanguage: String) -> Color {
    switch loveLanguage {
    case LoveLanguageEnum.actOfService.rawValue:
        return Color.actOfService
    case LoveLanguageEnum.receivingGift.rawValue:
        return Color.receivingGift
    case LoveLanguageEnum.physicalTouch.rawValue:
        return Color.physicalTouch
    case LoveLanguageEnum.qualityTime.rawValue:
        return Color.qualityTime
    case LoveLanguageEnum.wordsOfAffirmation.rawValue:
        return Color.wordsOfAffirmation
    case LoveLanguageEnum.combination.rawValue:
        return Color.combination
    default:
        return Color.primary
    }
}

func getLoveLanguageBackgroundColor(loveLanguage: String) -> Color {
    switch loveLanguage {
    case LoveLanguageEnum.actOfService.rawValue:
        return Color.bgActOfService
    case LoveLanguageEnum.receivingGift.rawValue:
        return Color.bgReceivingGift
    case LoveLanguageEnum.physicalTouch.rawValue:
        return Color.bgPhysicalTouch
    case LoveLanguageEnum.qualityTime.rawValue:
        return Color.bgQualityTime
    case LoveLanguageEnum.wordsOfAffirmation.rawValue:
        return Color.bgWordsOfAffirmation
    case LoveLanguageEnum.combination.rawValue:
        return Color.bgCombination
    default:
        return Color.primary
    }
}
