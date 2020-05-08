//
//  ClosableWindow.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 01/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import AppKit

class ClosableWindow: NSWindow {

    override func close() {
        self.orderOut(NSApp)
    }

}
