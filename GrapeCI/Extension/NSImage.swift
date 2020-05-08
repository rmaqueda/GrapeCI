//
//  NSImage.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 22/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Cocoa

extension NSImage {

    func tint(color: NSColor) -> NSImage {
        guard let image = self.copy() as? NSImage else { return self }
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        return image
    }

}
