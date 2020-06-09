//
//  Constants.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 18/09/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//let kBaseUrl = "https://rentasuit.ca/api/v1.0/"
let kBaseUrl = "https://rentasuit.sandboxbuild.com/api/v1.0/"
//let kBaseUrlImage = "https://rentasuit.ca/"
let kBaseUrlImage = "https://rentasuit.sandboxbuild.com/"

let REQUEST_TIME_OUT = 30.0
let ContentType = "application/json"
let urlencodedContentType = "application/x-www-form-urlencoded"
let formContentType =  "form-data"
let GET_METHOD = "GET"
let POST_METHOD = "POST"
let DELETE_METHOD = "DELETE"
let PUT_METHOD = "PUT"

// app inforamtion
//let RENT_FB_URL = "https://www.facebook.com/rentasuitclothes/"
let RENT_SOCIAL_URL = "rentasuitclothes"
//let RENT_PINTEREST_URL = "https://www.pinterest.ca/rentasuitclothes/"
let RENT_APP_EMAIL = "info@rentsuit.ca"
let RENT_APP_PHONE = "+91-22-2301111"
let RENT_APP_LCOATION = "123 connecticut st."


let kUserLogged = "UserLogged"
//Home Pager
let HOME_PAGE =  0
let GARMENTS_PAGE  = 1
let SHIPPING_PAGE  = 2
let SEARCH_PAGE  = 3
let CONTACT_PAGE  = 4

// data set category
let categorySet :[String] = ["Plz_category_key".localized,"item_damaged_key".localized,"item_late_key".localized,"item_wrong_key".localized,"technical_problme_key".localized]
let priceSet :[String] = ["per_week_key".localized,"per_day_key".localized, "per_month_key".localized]

let sizeSet :[String] = ["XS","S","M","L","XL"]
let citySet :[String] = ["plz_select_key".localized,"AB".localized,"BC".localized,"MB".localized,"NB".localized,"NL".localized,"NT".localized,"NS".localized,"NU".localized,"ON".localized,"PE".localized,"QC".localized,"SK".localized,"YT".localized]
let  paysCity : [String] = ["canada_key".localized,"UPS_key".localized]


let altarationSet : [String] = ["altaration_yes".localized,
                                "altaration_no".localized]

let seasonSet : [String] = ["season_winter".localized,
                            "season_autaumn".localized,
                            "season_spring".localized,
                            "season_summer".localized]

let conditionSet : [String] = ["condition_like_new".localized,
                               "condition_worn".localized,
                               "condition_looks_good".localized]

let cancelationSet : [String] = ["cancelation_agressive".localized,
                                 "cancelation_moderate".localized]

let deliveryOptionSet : [String] = ["do_localisation".localized,
                                       "do_mail".localized,
                                       "do_ups".localized]

let sortNotifSet : [String] = ["date-recently", "date-beginning"]

var rentDaysSet : [String] {
    get {
        var arr = [String]()
        for index in 1...30 {
            arr.append(String(format: "%d", index))
        }
        return arr
    }
}

// cgu and privacy
let cguUrl = "https://www.rentasuit.ca/terms-and-conditions"
let privacyUrl = "https://www.rentasuit.ca/privacy-policy"


let Twitter_secret  = "RkhwmBXOsSVTauiiPgKbTbXawCcI0aEQvtGFOruGwPYSi6YyRE"
let twitter_app_id  = "F95kvasU5WqMmbOqWOt1djik8"

let Facebook_secret = "21f7354be644801d1947ffc87f095b61"
let facebook_app_id  = "2008114579409719"
