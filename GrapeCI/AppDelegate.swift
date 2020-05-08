//
//  AppDelegate.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 22/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var flowController: FlowControllerProtocol = FlowController()

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(AppDelegate.handleURLEvent(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil { return }

        flowController.loadWelcomeIfNeeded()
        flowController.loadStatusModule()
        flowController.startScheduler()
    }

    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue,
            let url = URL(string: urlString), url.scheme == "grapeci" else {
                print("Invalid callback URL.")
                return
        }

        flowController.handleOauthRedirectURL(url)
    }

}
