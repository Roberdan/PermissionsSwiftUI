//
//  JMPermissionsView.swift
//
//
//  Created by Jevon Mao on 1/30/21.
//

import SwiftUI
import Introspect

struct ModalMainView<Body: View>: View, CustomizableView {
    #warning("Refactor all the property here into a view model, along with all the other views.")
    @EnvironmentObject var store: PermissionStore
    @State var isModalNotShown = true
    var showModal: Binding<Bool>
    //var thisView: AnyView
    var bodyView: Body
    var _permissionsToAsk: [PermissionType]?
    var permissionsToAsk: [PermissionType] {
        #warning("Fix this awkward computed property.")
        guard _permissionsToAsk == nil else {
            return _permissionsToAsk!
        }
        return store.undeterminedPermissions
    }
    var shouldShowPermission: Binding<Bool>{
        Binding(get: {
            if store.configStore.autoCheckAuth && isModalNotShown {
                return !permissionsToAsk.isEmpty
            }
            return true
        }, set: {_ in})
    }
    
    init(for bodyView: Body,
         show showModal: Binding<Bool>,
         permissionsToAsk: [PermissionType]?=nil) {
        self.bodyView = bodyView
        self.showModal = showModal
        self._permissionsToAsk = permissionsToAsk
        //self.thisView = self.typeErased()
    }
    
    var body: some View {
        bodyView
            .sheet(isPresented: showModal.combine(with: shouldShowPermission), content: {
                ModalView(showModal: showModal)
                    .onAppear(perform: store.configStore.onAppear)
                    .onDisappear(perform: store.configStore.onDisappear)
                    .onAppear{isModalNotShown=false}
                    .onDisappear{showModal.wrappedValue = false; isModalNotShown=true}
                    .introspectViewController{
                        if store.configStore.restrictDismissal {
                            $0.isModalInPresentation = store.shouldStayInPresentation
                        }
                    }
                
            })
           
        
    }
    //if DEBUG to ensure these functions are never used in production. They are for unit testing only.
    #if DEBUG
    func testCallOnAppear(){
        guard let onAppear = store.configStore.onAppear else {return}
        onAppear()
    }
    func testCallOnDisappear(){
        guard let onDisappear = store.configStore.onDisappear else {return}
        onDisappear() 
    }
    #endif
    
}
//Extension Binding wrapper for Binding booleans
extension Binding where Value == Bool{
    func combine(with value2: Binding<Bool>) -> Binding<Bool>{
        //Combine two Binding Bool conditions with AND operator
        return self.wrappedValue && value2.wrappedValue ? .constant(true) : .constant(false)
    }
}
