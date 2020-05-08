//
//  NSButton.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 08/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import AppKit

class NSButtonBlock: NSButton {
    private var completion: () -> Void

    init(title: String, completion: @escaping (() -> Void)) {
        self.completion = completion
        super.init(frame: .zero)

        self.title = title
        self.target = self
        self.action = #selector(didClick)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didClick() {
        completion()
    }

}
