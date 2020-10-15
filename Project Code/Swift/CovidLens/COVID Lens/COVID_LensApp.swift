//
//  COVID_LensApp.swift
//  COVID Lens
//
//  Created by Seth Goodwin on 10/4/20.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import Combine

@available(iOS 14.0, *)

@main
struct COVID_LensApp: App {
    
    @StateObject var authVM = AuthVM()
    
    // attach App Delegate to SwiftUI
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if (authVM.isLoggedIn) {
                TabContainterView()
                    .environmentObject(authVM)
            } else {
                LoginView(info: self.appDelegate)
                    .environmentObject(authVM)
            }
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate, ObservableObject{
    
    var window: UIWindow?
    
    
  
    @Published var userId:String?
    @Published var idToken:String?
    @Published var fullName:String?
    @Published var email:String?
    @Published var googleProfilePicURL:String?
    var apiKey = "AIzaSyBTOYwfO5V6sRC2z3QpxklUjizntrNnpd8"
     // [START didfinishlaunching]
     func application(_ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // Initialize sign-in
       GIDSignIn.sharedInstance().clientID = "429712041183-baisri01foho74au10khrorhs157khn6.apps.googleusercontent.com"
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
    
        GIDSignIn.sharedInstance().delegate = self

       return true
     }
     // [END didfinishlaunching]
     // [START openurl]
     func application(_ application: UIApplication,
                      open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       return GIDSignIn.sharedInstance().handle(url)
     }
     // [END openurl]
     // [START openurl_new]
     @available(iOS 9.0, *)
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
       return GIDSignIn.sharedInstance().handle(url)
     }
     // [END openurl_new]
    
     // [START signin_handler]
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
               withError error: Error!) {
       if let error = error {
         if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
           print("The user has not signed in before or they have since signed out.")
         } else {
           print("\(error.localizedDescription)")
         }
         // [START_EXCLUDE silent]
         NotificationCenter.default.post(
           name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
         // [END_EXCLUDE]
         return
       }
       // Perform any operations on signed in user here.
        self.userId = user.userID                  // For client-side use only!
        self.idToken = user.authentication.idToken // Safe to send to the server
        self.fullName = user.profile.name
        self.email = user.profile.email
        self.googleProfilePicURL = user.profile.imageURL(withDimension: 150)?.absoluteString ?? ""
        
       // [START_EXCLUDE]
       NotificationCenter.default.post(
         name: Notification.Name(rawValue: "ToggleAuthUINotification"),
         object: nil,
         userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
       // [END_EXCLUDE]
     }
     // [END signin_handler]
     // [START disconnect_handler]
     func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
               withError error: Error!) {
       // Perform any operations when the user disconnects from app here.
       // [START_EXCLUDE]
       NotificationCenter.default.post(
         name: Notification.Name(rawValue: "ToggleAuthUINotification"),
         object: nil,
         userInfo: ["statusText": "User has disconnected."])
       // [END_EXCLUDE]
     }
     // [END disconnect_handler]

        // conntect to database
         //send user info to database
        // instantiate User Struct
//    @EnvironmentObject var user = User(name: fullName, email: self.email, password: "", googleID: self.idToken, profilePic: self.googleProfilePicURL)

    
    
}
