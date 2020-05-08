//
//  Alert.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 08/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import AppKit

extension NSViewController {

    func showAlert(title: String,
                   informativeText: String,
                   buttonTitle: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = informativeText
        alert.alertStyle = .informational
        alert.addButton(withTitle: buttonTitle)
        alert.runModal()
    }

}
