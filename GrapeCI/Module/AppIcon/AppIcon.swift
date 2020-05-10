//
//  AppIcon.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 21/12/2019.
//  Copyright © 2019 Ricardo.Maqueda. All rights reserved.
//

import Cocoa

class AppIcon {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let popover = NSPopover()

    init(contentViewController: NSViewController) {
        popover.contentViewController = contentViewController
        popover.behavior = .transient

        if let button = statusItem.button {
            button.image = NSImage(named: "grapes")

            #if DEBUG
            button.image = button.image?.tint(color: NSColor.red.withAlphaComponent(0.6))
            #endif

            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    @objc private func togglePopover() {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }

    private func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    private func closePopover() {
        popover.performClose(popover.contentViewController)
    }

    func show(for status: GitBuildState) {
        guard let button = statusItem.button else { return }
        button.imageScaling = .scaleProportionallyUpOrDown

        switch status {
        case .none:
            button.image = NSImage(named: "grapes")
        case .inprogress:
            button.image = NSImage(named: "download")
        case .success:
            button.image = NSImage(named: "grapes")
        case .failed:
            button.image = NSImage(named: "failure")
        }
        #if DEBUG
        button.image = button.image?.tint(color: NSColor.red.withAlphaComponent(0.6))
        #endif
    }

}
