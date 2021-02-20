//
//  PermissionModelSet.swift
//
//
//  Created by Jevon Mao on 2/6/21.
//

import Foundation
import SwiftUI

//MARK: Storage
struct PermissionStore {
    private init(){}
    //a private singleton instance that allows read & write, but for this file's methods only
    fileprivate static var mutableShared = PermissionStore()
    //Read only singleton exposed to other parts of program
    static var shared:PermissionStore{
        get{
            mutableShared
        }
    }
    var permissions: [PermissionType] = []
    var permissionsToAsk: [PermissionType]{
        FilterPermissions.filterForShouldAskPermission(for: permissions)
    }
    var mainTexts = MainTexts()
    var autoDismissModal: Bool = true
    var autoDismissAlert: Bool = true
    var autoCheckModalAuth: Bool = true
    var autoCheckAlertAuth: Bool = true
    var onAppear: (()->Void)?
    var onDisappear: (()->Void)?
    struct MainTexts{
        var headerText: String = "Need Permissions"
        var headerDescription: String = """
                                       In order for you use certain features of this app, you need to give permissions. See description for each permission
                                       """
        var bottomDescription: String = """
                                            Permission are necessary for all the features and functions to work properly. If not allowed, you have to enable permissions in settings
                                            """
    }
    var cameraPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "camera.fill")),
        title: "Camera",
        description: "Allow to use your camera", authorized: false)
    
    var locationPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "location.fill.viewfinder")),
        title: "Location",
        description: "Allow to access your location", authorized: false
    )
    var locationAlwaysPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "location.fill.viewfinder")),
        title: "Location Always",
        description: "Allow to access your location", authorized: false
    )
    var photoPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "photo")),
        title: "Photo Library",
        description: "Allow to access your photos", authorized: false
    )
    var microphonePermisson = JMPermission(
        imageIcon: AnyView(Image(systemName: "mic.fill")),
        title: "Microphone",
        description: "Allow to record with microphone", authorized: false
    )
    var notificationPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "bell.fill")),
        title: "Notification",
        description: "Allow to send notifications", authorized: false
    )
    var calendarPermisson = JMPermission(
        imageIcon: AnyView(Image(systemName: "calendar")),
        title: "Calendar",
        description: "Allow to access calendar", authorized: false
    )
    var bluetoothPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "wave.3.left.circle.fill")),
        title: "Bluetooth",
        description: "Allow to use bluetooth", authorized: false
    )
    var trackingPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "person.circle.fill")),
        title: "Tracking",
        description: "Allow to track your data", authorized: false
    )
    var contactsPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "book.fill")),
        title: "Contacts",
        description: "Allow to access your contacts", authorized: false
    )
    var motionPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "hare.fill")),
        title: "Motion",
        description: "Allow to access your motion sensor data", authorized: false
    )
    var remindersPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "list.bullet.rectangle")),
        title: "Reminders",
        description: "Allow to access your reminders", authorized: false
    )
    var speechPermission = JMPermission(
        imageIcon: AnyView(Image(systemName: "rectangle.3.offgrid.bubble.left.fill")),
        title: "Speech",
        description: "Allow to access speech recognition", authorized: false
    )
    var healthPermission = JMPermission(imageIcon: AnyView(Image(systemName: "heart.fill")),
                                        title: "Health",
                                        description: "Allow to access your health information",
                                        authorized: false)
    
}
// MARK: Updating methods
extension PermissionStore{
    //Used for unit testing, need to reset storage before each subtest
    static func resetPermissionsModelStore(){
        mutableShared = PermissionStore()
    }
    //inout enables caller to modify PermissionStore
    func updateStore<T>(property:(inout PermissionStore, T)->Void, value:T){
        //Closure passes back PermissionStore instance, and the generic value passed in method
        property(&PermissionStore.mutableShared, value)
    }
}
