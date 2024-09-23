//
//  ItunesSearchRes.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/19/24.
//

import Foundation


struct ItunesSearchRes: Codable {
    struct Result: Codable {
        var artistViewUrl: String?
        var artworkUrl60: String?
        var supportedDevices: [String]?
        var features: [String]?
        var isGameCenterEnabled: Bool?
        var advisories: [String]?
        var screenshotUrls: [String]?
        var ipadScreenshotUrls: [String]?
        var appletvScreenshotUrls: [String]?
        var artworkUrl512: String?
        var trackViewUrl: String?
        var contentAdvisoryRating: String?
        var averageUserRating: Float?
        var currentVersionReleaseDate: String?
        var releaseNotes: String?
        var minimumOsVersion: String?
        var artistId: Int?
        var artistName: String?
        var genres: [String]?
        var price: Float?
        var genreIds: [String]?
        var primaryGenreName: String?
        var description: String?
        var bundleId: String?
        var trackId: Int?
        var trackName: String?
        var sellerName: String?
        var currency: String?
        var fileSizeBytes: String?
        var userRatingCountForCurrentVersion: Int?
        var trackContentRating: String?
        var averageUserRatingForCurrentVersion: Float?
        var releaseDate: String?
        var version: String?
        var userRatingCount: Int?
    }
    
    var results: [Result]
    var resultCount: Int
}

extension ItunesSearchRes {
    mutating func removeWeirdResults(){
        let newRes = self.results.filter {obj in obj.price != nil && obj.releaseDate != nil}
        self.results = newRes
    }
}

//#if targetEnvironment(simulator)
extension ItunesSearchRes {
    
    static let DUMMY = ItunesSearchRes(results: DUMMY_RESULTS, resultCount: DUMMY_RESULTS.count)
    static let DUMMY_RESULTS: [Result] = [
        
        Result(
            artistViewUrl: "https://apps.apple.com/us/developer/faceapp-technology-limited/id1561581171?uo=4",
            artworkUrl60: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/f1/f1/ec/f1f1ece3-8c3a-07ff-b97d-035320d16e5b/AppIcon-1x_U007emarketing-0-7-0-85-220-0.png/60x60bb.jpg",
            supportedDevices: ["iPhone5s-iPhone5s",
                               "iPadAir-iPadAir",
                               "iPadAirCellular-iPadAirCellular",
                               "iPadMiniRetina-iPadMiniRetina",
                               "iPadMiniRetinaCellular-iPadMiniRetinaCellular",
                               "iPhone6-iPhone6",
                               "iPhone6Plus-iPhone6Plus",
                               "iPadAir2-iPadAir2",
                               "iPadAir2Cellular-iPadAir2Cellular",
                               "iPadMini3-iPadMini3",
                               "iPadMini3Cellular-iPadMini3Cellular",
                               "iPodTouchSixthGen-iPodTouchSixthGen",
                               "iPhone6s-iPhone6s",
                               "iPhone6sPlus-iPhone6sPlus",
                               "iPadMini4-iPadMini4",
                               "iPadMini4Cellular-iPadMini4Cellular",
                               "iPadPro-iPadPro",
                               "iPadProCellular-iPadProCellular",
                               "iPadPro97-iPadPro97",
                               "iPadPro97Cellular-iPadPro97Cellular",
                               "iPhoneSE-iPhoneSE",
                               "iPhone7-iPhone7",
                               "iPhone7Plus-iPhone7Plus",
                               "iPad611-iPad611",
                               "iPad612-iPad612",
                               "iPad71-iPad71",
                               "iPad72-iPad72",
                               "iPad73-iPad73",
                               "iPad74-iPad74",
                               "iPhone8-iPhone8",
                               "iPhone8Plus-iPhone8Plus",
                               "iPhoneX-iPhoneX",
                               "iPad75-iPad75",
                               "iPad76-iPad76",
                               "iPhoneXS-iPhoneXS",
                               "iPhoneXSMax-iPhoneXSMax",
                               "iPhoneXR-iPhoneXR",
                               "iPad812-iPad812",
                               "iPad834-iPad834",
                               "iPad856-iPad856",
                               "iPad878-iPad878",
                               "iPadMini5-iPadMini5",
                               "iPadMini5Cellular-iPadMini5Cellular",
                               "iPadAir3-iPadAir3",
                               "iPadAir3Cellular-iPadAir3Cellular",
                               "iPodTouchSeventhGen-iPodTouchSeventhGen",
                               "iPhone11-iPhone11",
                               "iPhone11Pro-iPhone11Pro",
                               "iPadSeventhGen-iPadSeventhGen",
                               "iPadSeventhGenCellular-iPadSeventhGenCellular",
                               "iPhone11ProMax-iPhone11ProMax",
                               "iPhoneSESecondGen-iPhoneSESecondGen",
                               "iPadProSecondGen-iPadProSecondGen",
                               "iPadProSecondGenCellular-iPadProSecondGenCellular",
                               "iPadProFourthGen-iPadProFourthGen",
                               "iPadProFourthGenCellular-iPadProFourthGenCellular",
                               "iPhone12Mini-iPhone12Mini",
                               "iPhone12-iPhone12",
                               "iPhone12Pro-iPhone12Pro",
                               "iPhone12ProMax-iPhone12ProMax",
                               "iPadAir4-iPadAir4",
                               "iPadAir4Cellular-iPadAir4Cellular",
                               "iPadEighthGen-iPadEighthGen",
                               "iPadEighthGenCellular-iPadEighthGenCellular",
                               "iPadProThirdGen-iPadProThirdGen",
                               "iPadProThirdGenCellular-iPadProThirdGenCellular",
                               "iPadProFifthGen-iPadProFifthGen",
                               "iPadProFifthGenCellular-iPadProFifthGenCellular",
                               "iPhone13Pro-iPhone13Pro",
                               "iPhone13ProMax-iPhone13ProMax",
                               "iPhone13Mini-iPhone13Mini",
                               "iPhone13-iPhone13",
                               "iPadMiniSixthGen-iPadMiniSixthGen",
                               "iPadMiniSixthGenCellular-iPadMiniSixthGenCellular",
                               "iPadNinthGen-iPadNinthGen",
                               "iPadNinthGenCellular-iPadNinthGenCellular",
                               "iPhoneSEThirdGen-iPhoneSEThirdGen",
                               "iPadAirFifthGen-iPadAirFifthGen",
                               "iPadAirFifthGenCellular-iPadAirFifthGenCellular",
                               "iPhone14-iPhone14",
                               "iPhone14Plus-iPhone14Plus",
                               "iPhone14Pro-iPhone14Pro",
                               "iPhone14ProMax-iPhone14ProMax",
                               "iPadTenthGen-iPadTenthGen",
                               "iPadTenthGenCellular-iPadTenthGenCellular",
                               "iPadPro11FourthGen-iPadPro11FourthGen",
                               "iPadPro11FourthGenCellular-iPadPro11FourthGenCellular",
                               "iPadProSixthGen-iPadProSixthGen",
                               "iPadProSixthGenCellular-iPadProSixthGenCellular",
                               "iPhone15-iPhone15",
                               "iPhone15Plus-iPhone15Plus",
                               "iPhone15Pro-iPhone15Pro",
                               "iPhone15ProMax-iPhone15ProMax",
                               "iPadAir11M2-iPadAir11M2",
                               "iPadAir11M2Cellular-iPadAir11M2Cellular",
                               "iPadAir13M2-iPadAir13M2",
                               "iPadAir13M2Cellular-iPadAir13M2Cellular",
                               "iPadPro11M4-iPadPro11M4",
                               "iPadPro11M4Cellular-iPadPro11M4Cellular",
                               "iPadPro13M4-iPadPro13M4",
                               "iPadPro13M4Cellular-iPadPro13M4Cellular",
                               "iPhone16-iPhone16",
                               "iPhone16Plus-iPhone16Plus",
                               "iPhone16Pro-iPhone16Pro",
                               "iPhone16ProMax-iPhone16ProMax"],
            features: ["iosUniversal"],
            isGameCenterEnabled: false,
            advisories: ["Infrequent/Mild Mature/Suggestive Themes"],
            screenshotUrls: [],
            ipadScreenshotUrls: ["https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/d1/00/8c/d1008ce7-9568-93cb-abca-6ecb90e0837a/pr_source.jpg/576x768bb.jpg",
                                 "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/db/d0/82/dbd082b0-20ca-0e20-fb63-86591d2ff6eb/pr_source.jpg/576x768bb.jpg",
                                 "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/5c/23/f6/5c23f64e-d36e-5f51-bae9-13fcc06cc9e2/pr_source.jpg/576x768bb.jpg",
                                 "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/58/ed/27/58ed270a-8941-22c3-fdc4-60320b57006f/pr_source.jpg/576x768bb.jpg",
                                 "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/09/b0/e7/09b0e7d9-944b-cf7a-788b-ae7c28e5f0cf/pr_source.jpg/576x768bb.jpg"],
            appletvScreenshotUrls: [],
            artworkUrl512: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/f1/f1/ec/f1f1ece3-8c3a-07ff-b97d-035320d16e5b/AppIcon-1x_U007emarketing-0-7-0-85-220-0.png/512x512bb.jpg",
            trackViewUrl: "https://apps.apple.com/us/app/faceapp-perfect-face-editor/id1180884341?uo=4",
            contentAdvisoryRating: "9+",
            averageUserRating: 4.73332,
            currentVersionReleaseDate: "2024-09-19T09:59:41Z",
            releaseNotes: """
    Bug fixes and performance improvements
    """,
            minimumOsVersion: "15.0",
            artistId: 1561581171,
            artistName: "FaceApp Technology Limited",
            genres: ["Photo & Video",
                     "Entertainment"],
            price: 0,
            genreIds: ["6008",
                       "6016"],
            primaryGenreName: "Photo & Video",
            description: """
    FaceApp is one of the best mobile apps for advanced photo editing. Turn your selfies into modeling portraits using one of the most popular apps with over 500 million downloads to date. FaceApp gives you everything you need to create Insta-worthy edits for free. No more extra tapping on your screen!
    
    Use a fantastic set of filters, backgrounds, effects, and other tools to create a seamless and photorealistic edit in ONE TAP. You will never have to spend hours photoshopping again!
    
    More than 60 highly photorealistic filters
    
    PHOTO EDITOR
    
    - Perfect your selfies with Impression filters
    - Add a beard or mustache
    - Change your hair color and hairstyle
    - Add volume to your hair
    - Try trendy full makeup filters
    - Creative light effects
    - Remove acne and blemishes
    - Smooth wrinkles
    - Easily enlarge or minimize facial features
    - Try out the color lens
    - Easy Compare tool at every step to compare before & after
    - Total control of temperature, saturation, and more
    
    
    HAVE FUN
    
    - See what you'd look like as a different gender
    - Discover your best hairstyle and color with our advanced tool
    - Aging: try our popular Old & Young filters
    - Borrow your favorite style from different photos
    - Put your face in a popular movie scene
    - Try weight filters: get bigger or smaller
    - And many more fun filters!
    
    READY TO SHARE?
    
    Share your FaceApp edits directly to your favorite social media accounts
    
    Just ONE tap and your photo is ready for a total social media blitz!
    
    FaceApp PRO
    
    You can subscribe to get access to useful style filters, filters updates and all the features and content offered for purchase within FaceApp.
    
    Subscriptions are auto renewable and are billed monthly or annually at the rate selected depending on the subscription plan.
    
    
    Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Subscriptions can be managed and auto-renewal can be turned off in Account Settings in iTunes after the purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.
    
    - Terms of Use: https://www.faceapp.com/terms
    - Privacy Policy: https://www.faceapp.com/privacy
    - Online Tracking Opt-Out Guide: https://www.faceapp.com/online-tracking-opt-out-guide
    
    You are welcome to contact us at support.ios@faceapp.com
    """,
            bundleId: "io.faceapp.ios",
            trackId: 1180884341,
            trackName: "FaceApp: Perfect Face Editor",
            sellerName: "FaceApp Technology Limited",
            currency: "USD",
            fileSizeBytes: "132574208",
            userRatingCountForCurrentVersion: 1597749,
            trackContentRating: "9+",
            averageUserRatingForCurrentVersion: 4.73332,
            releaseDate: "2017-01-24T14:13:07Z",
            version: "12.5.2",
            userRatingCount: 1597749
        ),
        Result(
            artistViewUrl: "https://apps.apple.com/us/developer/shantanu-pte-ltd/id1619465920?uo=4",
            artworkUrl60: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/d7/93/42/d79342fa-d9f9-83fb-7b2a-a1b72f49b5ba/AppIcon-0-0-1x_U007epad-0-1-0-sRGB-0-85-220.png/60x60bb.jpg",
            supportedDevices: ["iPhone5s-iPhone5s",
                               "iPadAir-iPadAir",
                               "iPadAirCellular-iPadAirCellular",
                               "iPadMiniRetina-iPadMiniRetina",
                               "iPadMiniRetinaCellular-iPadMiniRetinaCellular",
                               "iPhone6-iPhone6",
                               "iPhone6Plus-iPhone6Plus",
                               "iPadAir2-iPadAir2",
                               "iPadAir2Cellular-iPadAir2Cellular",
                               "iPadMini3-iPadMini3",
                               "iPadMini3Cellular-iPadMini3Cellular",
                               "iPodTouchSixthGen-iPodTouchSixthGen",
                               "iPhone6s-iPhone6s",
                               "iPhone6sPlus-iPhone6sPlus",
                               "iPadMini4-iPadMini4",
                               "iPadMini4Cellular-iPadMini4Cellular",
                               "iPadPro-iPadPro",
                               "iPadProCellular-iPadProCellular",
                               "iPadPro97-iPadPro97",
                               "iPadPro97Cellular-iPadPro97Cellular",
                               "iPhoneSE-iPhoneSE",
                               "iPhone7-iPhone7",
                               "iPhone7Plus-iPhone7Plus",
                               "iPad611-iPad611",
                               "iPad612-iPad612",
                               "iPad71-iPad71",
                               "iPad72-iPad72",
                               "iPad73-iPad73",
                               "iPad74-iPad74",
                               "iPhone8-iPhone8",
                               "iPhone8Plus-iPhone8Plus",
                               "iPhoneX-iPhoneX",
                               "iPad75-iPad75",
                               "iPad76-iPad76",
                               "iPhoneXS-iPhoneXS",
                               "iPhoneXSMax-iPhoneXSMax",
                               "iPhoneXR-iPhoneXR",
                               "iPad812-iPad812",
                               "iPad834-iPad834",
                               "iPad856-iPad856",
                               "iPad878-iPad878",
                               "iPadMini5-iPadMini5",
                               "iPadMini5Cellular-iPadMini5Cellular",
                               "iPadAir3-iPadAir3",
                               "iPadAir3Cellular-iPadAir3Cellular",
                               "iPodTouchSeventhGen-iPodTouchSeventhGen",
                               "iPhone11-iPhone11",
                               "iPhone11Pro-iPhone11Pro",
                               "iPadSeventhGen-iPadSeventhGen",
                               "iPadSeventhGenCellular-iPadSeventhGenCellular",
                               "iPhone11ProMax-iPhone11ProMax",
                               "iPhoneSESecondGen-iPhoneSESecondGen",
                               "iPadProSecondGen-iPadProSecondGen",
                               "iPadProSecondGenCellular-iPadProSecondGenCellular",
                               "iPadProFourthGen-iPadProFourthGen",
                               "iPadProFourthGenCellular-iPadProFourthGenCellular",
                               "iPhone12Mini-iPhone12Mini",
                               "iPhone12-iPhone12",
                               "iPhone12Pro-iPhone12Pro",
                               "iPhone12ProMax-iPhone12ProMax",
                               "iPadAir4-iPadAir4",
                               "iPadAir4Cellular-iPadAir4Cellular",
                               "iPadEighthGen-iPadEighthGen",
                               "iPadEighthGenCellular-iPadEighthGenCellular",
                               "iPadProThirdGen-iPadProThirdGen",
                               "iPadProThirdGenCellular-iPadProThirdGenCellular",
                               "iPadProFifthGen-iPadProFifthGen",
                               "iPadProFifthGenCellular-iPadProFifthGenCellular",
                               "iPhone13Pro-iPhone13Pro",
                               "iPhone13ProMax-iPhone13ProMax",
                               "iPhone13Mini-iPhone13Mini",
                               "iPhone13-iPhone13",
                               "iPadMiniSixthGen-iPadMiniSixthGen",
                               "iPadMiniSixthGenCellular-iPadMiniSixthGenCellular",
                               "iPadNinthGen-iPadNinthGen",
                               "iPadNinthGenCellular-iPadNinthGenCellular",
                               "iPhoneSEThirdGen-iPhoneSEThirdGen",
                               "iPadAirFifthGen-iPadAirFifthGen",
                               "iPadAirFifthGenCellular-iPadAirFifthGenCellular",
                               "iPhone14-iPhone14",
                               "iPhone14Plus-iPhone14Plus",
                               "iPhone14Pro-iPhone14Pro",
                               "iPhone14ProMax-iPhone14ProMax",
                               "iPadTenthGen-iPadTenthGen",
                               "iPadTenthGenCellular-iPadTenthGenCellular",
                               "iPadPro11FourthGen-iPadPro11FourthGen",
                               "iPadPro11FourthGenCellular-iPadPro11FourthGenCellular",
                               "iPadProSixthGen-iPadProSixthGen",
                               "iPadProSixthGenCellular-iPadProSixthGenCellular",
                               "iPhone15-iPhone15",
                               "iPhone15Plus-iPhone15Plus",
                               "iPhone15Pro-iPhone15Pro",
                               "iPhone15ProMax-iPhone15ProMax",
                               "iPadAir11M2-iPadAir11M2",
                               "iPadAir11M2Cellular-iPadAir11M2Cellular",
                               "iPadAir13M2-iPadAir13M2",
                               "iPadAir13M2Cellular-iPadAir13M2Cellular",
                               "iPadPro11M4-iPadPro11M4",
                               "iPadPro11M4Cellular-iPadPro11M4Cellular",
                               "iPadPro13M4-iPadPro13M4",
                               "iPadPro13M4Cellular-iPadPro13M4Cellular",
                               "iPhone16-iPhone16",
                               "iPhone16Plus-iPhone16Plus",
                               "iPhone16Pro-iPhone16Pro",
                               "iPhone16ProMax-iPhone16ProMax"],
            features: ["iosUniversal"],
            isGameCenterEnabled: false,
            advisories: [],
            screenshotUrls: ["https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/d0/6a/15/d06a15c3-5f08-0080-9fbd-42698db13767/ba60ddfa-d268-433a-9a48-a233132db448_1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/04/ae/0d/04ae0d70-7c66-e2f7-9ffc-871fb38dacd8/0190b895-a72b-443a-bd75-707eef4ed3df_2.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/3e/77/28/3e7728ed-83cd-924d-0459-6a999d253482/8bdfb394-6c48-497c-af4f-b5d0b6cdcdc5_3.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/04/ff/82/04ff82b4-2c2d-054b-0af5-21bb6053ed2a/3f36320d-d9f8-4296-ab69-4fa91370b308_4.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/b3/05/8b/b3058bae-70b6-43fe-a7e4-b722089d22f6/ce016b4b-03c7-427d-be58-258fcb771597_5.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/da/58/c3/da58c3cb-bfc7-132c-fda3-e0f11f13806b/963a3840-5f75-4f28-bb8e-05f2c16c80c4_1-1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/23/34/8d/23348d8a-198d-e9b4-0f92-429096963808/b107bd1f-be54-4c8c-ba31-0c85461f4091_7.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/1a/9b/08/1a9b0857-51ef-3f8e-b0a1-c144e869374c/0a8bb74f-8580-420c-93ba-a2575ef29d3f_8.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/9d/2c/8e/9d2c8e9b-253d-8c5e-e8fe-0ac207598a99/1c9985b3-3df3-4946-98d0-1899bd66a2eb_9.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/0e/99/23/0e992373-1c1f-05d0-0fa7-519c15af7c86/70c67b55-ab8a-4256-9c16-4a744c95a624_10.jpg/392x696bb.jpg"],
            ipadScreenshotUrls: ["https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/13/b0/0b/13b00b55-1d33-66e7-5cf1-42d3e363428f/9fe73e80-f551-4e9f-9966-6983a0cc5a3c_1.png/576x768bb.png",
                                 "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/2a/eb/48/2aeb4800-7da9-c2c1-d5d0-b96605e8cf35/9cba6414-72e5-48b6-a8c1-cbce9ab75754_2.png/576x768bb.png",
                                 "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/13/1b/3b/131b3bd8-fc53-78ce-6bb6-05098ff9f803/e37694b4-064a-46ec-8bf1-93c0b0e784c9_3.png/576x768bb.png",
                                 "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/88/b2/c2/88b2c28e-5989-daec-3bdc-6478a932e1bb/8bfa56d8-bb3a-42e0-9304-fb7f4e7e3b33_4.png/576x768bb.png",
                                 "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/7a/68/ce/7a68ce6b-590c-18db-ed77-cadab6ff11d5/a4102f46-ec76-4a95-8e70-d28a94661fa1_5.png/576x768bb.png",
                                 "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/39/c3/1f/39c31f54-a411-6e4a-3025-7083ef116bd0/de80c3ac-26a5-43f6-b8f6-ff76617daddb_6.png/576x768bb.png"],
            appletvScreenshotUrls: [],
            artworkUrl512: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/d7/93/42/d79342fa-d9f9-83fb-7b2a-a1b72f49b5ba/AppIcon-0-0-1x_U007epad-0-1-0-sRGB-0-85-220.png/512x512bb.jpg",
            trackViewUrl: "https://apps.apple.com/us/app/peachy-ai-face-body-editor/id1390423469?uo=4",
            contentAdvisoryRating: "4+",
            averageUserRating: 4.85311,
            currentVersionReleaseDate: "2024-09-11T16:18:52Z",
            releaseNotes: """
    - [Body - Auto]: Now includes background protection
    - [Cutout - Detach]: Separate the subject from backdrop with one click
    - [Makeup - Mark]: Explore more facial decorations like freckles
    - Bug fixes and other improvements
    
    Thanks for using Peachy. Your ideas and feedback are very important to us!
    > Contact us at peachy.ios@inshot.com
    > Follow us on instagram @peachyapp.official
    """,
            minimumOsVersion: "14.0",
            artistId: 1619465920,
            artistName: "SHANTANU PTE. LTD.",
            genres: ["Photo & Video",
                     "Entertainment"],
            price: 0,
            genreIds: ["6008",
                       "6016"],
            primaryGenreName: "Photo & Video",
            description: """
    Aiming at perfection in everything, Peachy is a powerful & handy pro photo editor, especially for selfie editing & retouching, body shape editing.
    
    Everybody is an excellent photographer with this simple retouch tool, it helps you meet the best version of you, smooth skin, whiten teeth, reshape face, fix blemishes, remove wrinkles, become taller, add makeup, tattoo, muscles, filters, and more.
    
    Peachy provides lots of portrait and selfie photo editing features. Download it and give a try!
    
    RETOUCH
    ·Remove wrinkles and acne
    ·Smooth and brightened your skin
    ·Reduce dark circles under your eyes
    ·Whiten your teeth
    ·Add volume and darken your eyebrow
    
    RESHAPE
    ·Reshape your body and facial structure
    ·Refine a specific area of the selfie, for example, arms or facial features
    ·Bloat your breast, enlarge muscles and facial features
    
    MAKEUP
    ·Put on a full set of trendy makeup
    ·Foundation and Concealer tools for skin retouch
    ·Contour, Blush, Eye Makeup, Lipstick, etc. Everything you need for makeup
    ·Change hair color with just one tap
    
    HEIGHT CORRECTION
    ·Elongate your legs and become taller
    ·Enhance your body both laterally and longitudinally
    
    AI REMOVE
    ·Automatic object detection
    ·Easily remove unwanted objects with high quality
    
    RELIGHT
    ·Portrait Relight to highlight your beauty
    ·Lighting Adjustment (brightness, radius, warmth and softness)
    
    AI TOOLS
    ·Al Enhance: Improve low-quality or blurry images
    ·Al Cartoon: Enjoy AI Art and generate avatars in various styles
    ·AI Touch: Effortlessly retouch photos with just one tap
    ·AI Adjust: Improve the tone of visual effects automatically
    
    AUTO BODY RESHAPE
    ·Get smaller waist and bigger hips
    ·Automatically reshape your Head, Legs, Arms, Neck and Shoulders
    
    ADD MUSCLES
    ·Add six pack abs muscles
    ·Add chest muscles
    
    ADD TATTOO
    ·Add creative tattoos to your body
    
    LIGHTING EFFECTS
    ·Improve lighting effects of the selfie or portrait
    
    ACCESSORIES
    ·Decorate your selfie or portrait with stylish accessories
    
    ADJUST
    ·Adjusting brightness, contrast, vignette, highlights, shadows, etc.
    ·Selective options for image enhancement
    ·Professional HSL color correction
    
    CLOTHES
    ·Change dress style with preset patterns or featured colors
    
    BEAUTY CAMERA
    ·Real time selfie camera with smooth skin and face fine-tune
    
    BASIC PHOTO EDITING TOOLS
    ·High-fashion vintage filters, perfect for selfie
    ·Auto Background Blur and Bokeh tools
    ·BG Effects to make your photo unique
    ·Remove and change background easily
    ·Amazing Glitch effects
    ·Add text on your photo
    
    Perfect your selfies or portraits in Peachy, and share with your friends online, it can be fun and inspiring!
    
    Any suggestions or feedback for Peachy (photo and selfie editor, retouch tool), please email us at peachy.ios@inshot.com. We will get back to you as soon as possible.
    
    
    ------------------------------
    
    Peachy Pro Unlimited Subscription
    
    - With an Peachy Pro Unlimited subscription, you have access to all features and paid editing options and materials. Advertisements will be removed automatically.
    
    - Peachy Pro Unlimited subscription is billed annually. In addition, a one-time payment will be offered if needed, which is not one of the subscription plan.
    
    - Payment will be charged to iTunes Account at confirmation of purchase.
    
    - Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.
    
    - Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal.
    
    - Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.
    
    - Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.
    
    -Terms of Use
    https://inshot.cc/terms/terms_peachy.pdf
    
    -Privacy Policy
    https://inshot.cc/peachy/terms/privacy_policy.pdf
    """,
            bundleId: "com.camerasideas.Peachy",
            trackId: 1390423469,
            trackName: "Peachy - AI Face & Body Editor",
            sellerName: "SHANTANU PTE. LTD.",
            currency: "USD",
            fileSizeBytes: "255775744",
            userRatingCountForCurrentVersion: 134534,
            trackContentRating: "4+",
            averageUserRatingForCurrentVersion: 4.85311,
            releaseDate: "2018-06-29T20:02:55Z",
            version: "1.54.0",
            userRatingCount: 134534
        ),
        Result(
            artistViewUrl: "https://apps.apple.com/us/developer/alpha-mobile-limited/id1216139452?uo=4",
            artworkUrl60: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/b9/db/eb/b9dbebc6-eec3-686c-63a8-d6a04c436c03/AppIcon-0-0-1x_U007emarketing-0-5-0-0-85-220.png/60x60bb.jpg",
            supportedDevices: ["iPhone5s-iPhone5s",
                               "iPadAir-iPadAir",
                               "iPadAirCellular-iPadAirCellular",
                               "iPadMiniRetina-iPadMiniRetina",
                               "iPadMiniRetinaCellular-iPadMiniRetinaCellular",
                               "iPhone6-iPhone6",
                               "iPhone6Plus-iPhone6Plus",
                               "iPadAir2-iPadAir2",
                               "iPadAir2Cellular-iPadAir2Cellular",
                               "iPadMini3-iPadMini3",
                               "iPadMini3Cellular-iPadMini3Cellular",
                               "iPodTouchSixthGen-iPodTouchSixthGen",
                               "iPhone6s-iPhone6s",
                               "iPhone6sPlus-iPhone6sPlus",
                               "iPadMini4-iPadMini4",
                               "iPadMini4Cellular-iPadMini4Cellular",
                               "iPadPro-iPadPro",
                               "iPadProCellular-iPadProCellular",
                               "iPadPro97-iPadPro97",
                               "iPadPro97Cellular-iPadPro97Cellular",
                               "iPhoneSE-iPhoneSE",
                               "iPhone7-iPhone7",
                               "iPhone7Plus-iPhone7Plus",
                               "iPad611-iPad611",
                               "iPad612-iPad612",
                               "iPad71-iPad71",
                               "iPad72-iPad72",
                               "iPad73-iPad73",
                               "iPad74-iPad74",
                               "iPhone8-iPhone8",
                               "iPhone8Plus-iPhone8Plus",
                               "iPhoneX-iPhoneX",
                               "iPad75-iPad75",
                               "iPad76-iPad76",
                               "iPhoneXS-iPhoneXS",
                               "iPhoneXSMax-iPhoneXSMax",
                               "iPhoneXR-iPhoneXR",
                               "iPad812-iPad812",
                               "iPad834-iPad834",
                               "iPad856-iPad856",
                               "iPad878-iPad878",
                               "iPadMini5-iPadMini5",
                               "iPadMini5Cellular-iPadMini5Cellular",
                               "iPadAir3-iPadAir3",
                               "iPadAir3Cellular-iPadAir3Cellular",
                               "iPodTouchSeventhGen-iPodTouchSeventhGen",
                               "iPhone11-iPhone11",
                               "iPhone11Pro-iPhone11Pro",
                               "iPadSeventhGen-iPadSeventhGen",
                               "iPadSeventhGenCellular-iPadSeventhGenCellular",
                               "iPhone11ProMax-iPhone11ProMax",
                               "iPhoneSESecondGen-iPhoneSESecondGen",
                               "iPadProSecondGen-iPadProSecondGen",
                               "iPadProSecondGenCellular-iPadProSecondGenCellular",
                               "iPadProFourthGen-iPadProFourthGen",
                               "iPadProFourthGenCellular-iPadProFourthGenCellular",
                               "iPhone12Mini-iPhone12Mini",
                               "iPhone12-iPhone12",
                               "iPhone12Pro-iPhone12Pro",
                               "iPhone12ProMax-iPhone12ProMax",
                               "iPadAir4-iPadAir4",
                               "iPadAir4Cellular-iPadAir4Cellular",
                               "iPadEighthGen-iPadEighthGen",
                               "iPadEighthGenCellular-iPadEighthGenCellular",
                               "iPadProThirdGen-iPadProThirdGen",
                               "iPadProThirdGenCellular-iPadProThirdGenCellular",
                               "iPadProFifthGen-iPadProFifthGen",
                               "iPadProFifthGenCellular-iPadProFifthGenCellular",
                               "iPhone13Pro-iPhone13Pro",
                               "iPhone13ProMax-iPhone13ProMax",
                               "iPhone13Mini-iPhone13Mini",
                               "iPhone13-iPhone13",
                               "iPadMiniSixthGen-iPadMiniSixthGen",
                               "iPadMiniSixthGenCellular-iPadMiniSixthGenCellular",
                               "iPadNinthGen-iPadNinthGen",
                               "iPadNinthGenCellular-iPadNinthGenCellular",
                               "iPhoneSEThirdGen-iPhoneSEThirdGen",
                               "iPadAirFifthGen-iPadAirFifthGen",
                               "iPadAirFifthGenCellular-iPadAirFifthGenCellular",
                               "iPhone14-iPhone14",
                               "iPhone14Plus-iPhone14Plus",
                               "iPhone14Pro-iPhone14Pro",
                               "iPhone14ProMax-iPhone14ProMax",
                               "iPadTenthGen-iPadTenthGen",
                               "iPadTenthGenCellular-iPadTenthGenCellular",
                               "iPadPro11FourthGen-iPadPro11FourthGen",
                               "iPadPro11FourthGenCellular-iPadPro11FourthGenCellular",
                               "iPadProSixthGen-iPadProSixthGen",
                               "iPadProSixthGenCellular-iPadProSixthGenCellular",
                               "iPhone15-iPhone15",
                               "iPhone15Plus-iPhone15Plus",
                               "iPhone15Pro-iPhone15Pro",
                               "iPhone15ProMax-iPhone15ProMax",
                               "iPadAir11M2-iPadAir11M2",
                               "iPadAir11M2Cellular-iPadAir11M2Cellular",
                               "iPadAir13M2-iPadAir13M2",
                               "iPadAir13M2Cellular-iPadAir13M2Cellular",
                               "iPadPro11M4-iPadPro11M4",
                               "iPadPro11M4Cellular-iPadPro11M4Cellular",
                               "iPadPro13M4-iPadPro13M4",
                               "iPadPro13M4Cellular-iPadPro13M4Cellular",
                               "iPhone16-iPhone16",
                               "iPhone16Plus-iPhone16Plus",
                               "iPhone16Pro-iPhone16Pro",
                               "iPhone16ProMax-iPhone16ProMax"],
            features: [],
            isGameCenterEnabled: false,
            advisories: [],
            screenshotUrls: ["https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/93/c9/09/93c909e1-eb12-c942-291b-3d1e0d1c55aa/74a5cb8a-9bf7-40e1-8c67-80c72c8b26aa__U6362_U8138_1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/16/f6/f2/16f6f257-1d1b-f21b-28dd-f40e7b4b05c6/f76f20ff-9a0e-4538-b279-6af0f8c4469e__U8001_U7167_U72471.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/11/8b/e6/118be60a-e9fd-ccad-5c7e-8f2a795e3aeb/3e822cd4-d5f2-45a1-873b-44a1daddfb9c__U62fc_U56fe_1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/34/01/2d/34012d06-3413-8ada-ec89-c7c3cfd26c1a/6e71e436-ffd2-4d58-b696-d02fc09ece57__U62a0_U56fe_1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/8d/df/a7/8ddfa70f-9f4b-1423-a6e7-2e691dc30551/f90f3463-d353-471f-a54b-2099b2892699__U8179_U808c__1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/cf/bf/15/cfbf15fb-a177-f9c4-63f5-eec9a1a4d3d4/df119720-7ea4-498e-a853-8dd802dcc085__U6ee4_U955c1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/2d/4f/6d/2d4f6dfe-db74-1dd2-3dcc-94446aabc81e/b903a43f-2e8c-47d7-9128-f1af2c4b1db7__U4e94_U5b98_U8c03_U6574_1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/b5/94/eb/b594ebd9-2e16-c54a-4e79-861ff394339b/745227f8-df3b-44bc-b1cb-cfa9629c01f2__U7eb9_U8eab1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/2a/b7/7f/2ab77f81-f3db-7aee-9215-746808f9ccb7/e74bfbcb-0cea-4efc-bd5b-9573a64d9cf0__U78e8_U76ae_1.jpg/392x696bb.jpg",
                             "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/8c/06/17/8c0617dc-f952-8057-d7bc-8ef653ea813a/0dd320a8-68e1-4697-81dc-7eaa22f49b03__U53d1_U578b__U80e1_U5b50_1.jpg/392x696bb.jpg"],
            ipadScreenshotUrls: [],
            appletvScreenshotUrls: [],
            artworkUrl512: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/b9/db/eb/b9dbebc6-eec3-686c-63a8-d6a04c436c03/AppIcon-0-0-1x_U007emarketing-0-5-0-0-85-220.png/512x512bb.jpg",
            trackViewUrl: "https://apps.apple.com/us/app/manly-best-ai-body-editor/id1263326810?uo=4",
            contentAdvisoryRating: "4+",
            averageUserRating: 4.7271,
            currentVersionReleaseDate: "2024-09-20T14:51:36Z",
            releaseNotes: """
    - Bug fix.
    """,
            minimumOsVersion: "15.0",
            artistId: 1216139452,
            artistName: "Alpha Mobile Limited",
            genres: ["Photo & Video",
                     "Lifestyle"],
            price: 0,
            genreIds: ["6008",
                       "6012"],
            primaryGenreName: "Photo & Video",
            description: """
    Unleash your inner alpha with Manly, a photo editing app designed for men. Packed with a series of features like muscle enhancement, AI reface, body reshaping, face retouching, beard and hairstyle options, and more. Manly makes photo retouching a piece of cake. Dive into the world of Manly and revolutionize your selfies!
    
    --- Key Features ---
    # Muscle Editor #
    Choose from over 100 pre-set muscle designs with Manly's Muscle Editor, effortlessly adding bulk and charm to your physique in photos.
    
    # AI-Powered Editor#
    Swap faces and unlock vast styles of you on photos with AI reface. Improve photos to high quality with AI enhance and solve problems more than clarity and resolution.
    
    # Layout Templates #
    Collage multiple photos into an eye-catching one with various layouts.
    
    # Background Change #
    Cut out and change the background of photos with one tap, add amazing filters and overlay on the same page.
    
    # Body Transformation #
    Reshape your body to your liking with Manly, effortlessly achieving the perfect V-shaped physique in your photos.
    
    # Size Enhancement #
    Size Enhancement: Achieve your dream physique with a wider chest and larger biceps.
    
    # Height Adjustment #
    Taller stature and longer legs are just a tap away!
    
    # Tattoo Addition #
    Customize your look with over 100 tattoo designs.
    
    # Beard Styles #
    Try trendy beard styles and boost your charm!
    
    # Hairstyle Changes #
    Discover your next stunning look with our hairstyle options.
    
    # Hair Color #
    Choose from popular colors or go wild with unique shades.
    
    # Acne Remover #
    Look years younger with our skin smoothing feature.
    
    # Skin Tone Adjustment #
    Choose from a wide spectrum of skin tones.
    
    # Perfect Skin #
    Flaunt flawless, acne-free skin.
    
    # Accessories #
    Jazz up your look with stylish accessories.
    
    # Color Contact Lens #
    Create diverse looks with our colored lenses.
    
    # Filter Effects #
    Add an artistic touch with unique filters.
    
    # User-friendly Interface #
    Enjoy the simplicity and fun of photo editing!
    
    
    Download Manly now and embark on your photo editing adventure!
    
    
    ======================================
    Manly “Manly Pro” Subscriptions and other services
    ======================================
    
    1 Week: 1-week subscription: $2.99
    1 Month: 1-month subscription: $4.99
    12 Month: 1-year subscription: $35.99
    One-time Purchase: Permanent VIP: $69.99 (one-time payment)
    
    *Detailed information regarding the purchase, including the actual amount you need to pay, the length of the free trial period (if there is one), and the exact date on which you will be charged the subscription fee, can be found at the purchase confirmation screen.
    
    Payment will be charged to iTunes Account at confirmation of purchase. Subscriptions automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. No cancellation of the current subscription is allowed during active subscription period. Any unused portion of a free trial period will be forfeited when the user purchases a subscription to that publication.
    
    Manly Terms of Use: https://alphamotech.com/manly_terms.html
    Manly Privacy: https://alphamotech.com/manly_privacy.html
    """,
            bundleId: "com.alphatech.manly",
            trackId: 1263326810,
            trackName: "Manly- Best AI Body Editor",
            sellerName: "Alpha Mobile Limited",
            currency: "USD",
            fileSizeBytes: "217390080",
            userRatingCountForCurrentVersion: 1660,
            trackContentRating: "4+",
            averageUserRatingForCurrentVersion: 4.7271,
            releaseDate: "2017-08-15T02:12:41Z",
            version: "3.16.7",
            userRatingCount: 1660
        )
        
        
    ]
}
//#endif
