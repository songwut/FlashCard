//
//  Localized.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

let notifyChangeLanguage = Notification.Name("NotificationChangeLanguage")
let isOpenedAppKey = "isOpenedAppKey"
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"
let LCLCurrentLanguageUpdateTimeKey = "LCLCurrentLanguageUpdateTimeKey"
let LCLDefaultLanguage = "LCLDefaultLanguage"

var isLocalizeOnline = true

extension String {
    func localized() -> String {
        if isLocalizeOnline {
            return Localized.shared.string(forKey: self) // localize with API
        } else {
            return Localized.localized(text: self) // localize in local
        }
    }
}
    
class Localized: NSObject {
    class var shared: Localized {
        
        struct Static {
            static let instance: Localized = Localized()
        }
        return Static.instance
    }
    
    var dict: [String : Any]?
    var language = configLocale[defaultLanguageIndex]
    
    func lineSpacing() -> CGFloat {
        return configParagraphLineSpacing[language] ?? 2.0
    }
    
    override init() {
        
        super.init()
        
    }
    
    func string(forKey: String) -> String {
        if let dict = self.dict {
            if let lang = dict[language] as? [String : String] {
                if let text = lang[forKey] {
                    return text
                }
            }
        }
        return forKey
    }
    
    open class func localized(text: String) -> String {
        if  let path = Bundle.main.path(forResource: Localized.currentLanguage(), ofType: "lproj"),
            let bun = Bundle(path: path) {
            return bun.localizedString(forKey: text, value: text, table: nil)
        }
        
        return text
    }
    
    open class func setCurrentLanguage(_ language: String) {
        
        if !availableLanguages().contains(language), isActiveDictKey {
            Localized.shared.language = language
            UserDefaults.standard.set(language, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: notifyChangeLanguage, object: nil)
            
        } else {
            let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
            if (selectedLanguage != currentLanguage()){
                Localized.shared.language = language
                UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: notifyChangeLanguage, object: nil)
            }
        }
        let newCalendar = Localized.shared.language == "th" ? Calendar.Identifier.buddhist : Calendar.Identifier.gregorian
        mainCalendar = Calendar(identifier: newCalendar)
    }
    
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.index(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}
