//
//  XCTestView.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 31/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import XCTest

class XCTestView: XCTestCase {

    private let windowSize = NSSize(width: 0, height: 0)
    private let screenSize = NSScreen.main?.frame.size ?? .zero
    private lazy var rect = NSMakeRect(screenSize.width / 2 - windowSize.width / 2,
                               screenSize.height / 2 - windowSize.height / 2,
                               windowSize.width,
                               windowSize.height)
    lazy var window = NSWindow(contentRect: rect,
                               styleMask: [.miniaturizable, .closable, .resizable, .titled],
                               backing: .buffered,
                               defer: false)

    override func setUpWithError() throws {
        try super.setUpWithError()

        window.makeKeyAndOrderFront(nil)
        RunLoop.current.run(until: Date())
    }

}
