//
//  IntegrateViewController.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 16/02/2020.
//  Copyright © 2020 Ricardo.Maqueda. All rights reserved.
//

import Cocoa

class IntegrateViewController: NSViewController {
    private var presenter: IntegratePresenterProtocol
    private weak var flowController: FlowControllerProtocol?

    @IBOutlet weak var repositoryNameLabel: NSTextField!
    @IBOutlet weak var pipelineTextView: NSTextView!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var deIntegrateButton: NSButton!

    init(presenter: IntegratePresenterProtocol, flowController: FlowControllerProtocol) {
        self.presenter = presenter
        self.flowController = flowController

        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pipelineTextView.isAutomaticQuoteSubstitutionEnabled = false
        pipelineTextView.isAutomaticTextReplacementEnabled = false

        repositoryNameLabel.stringValue = presenter.title
        pipelineTextView.string = presenter.pipeline
        button.title = presenter.buttonTitle
        deIntegrateButton.title = presenter.deIntegrateButtonTitle
    }

    @IBAction func didPressSave(_ sender: Any) {
        if pipelineTextView.string.count > 0 {
            presenter.integrate(pipeline: pipelineTextView.string)
            flowController?.didChangeIntegratedRepositories()
        } else {
            // TODO: Show empty pipeline warning?
        }
    }

    @IBAction func didPressDeIntegrate(_ sender: Any) {
        // TODO: Show confirmation dialog?
        presenter.deIntegrate()
        flowController?.didChangeIntegratedRepositories()
    }

}
