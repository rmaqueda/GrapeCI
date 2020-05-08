//
//  ShowLogViewController.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 24/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Cocoa

class ShowLogViewController: NSViewController {
    var log: String?
    @IBOutlet private var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Build log"
        textView.string = log ?? "Empty log"
    }
}
