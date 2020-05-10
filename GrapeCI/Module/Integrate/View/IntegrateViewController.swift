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
    var logView: ShowLogViewController?

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
            presenter.integrate(
                pipeline: pipelineTextView.string,
                progress: { [weak self] log in
                    guard let self = self else { return }
                    if self.logView == nil {
                        self.logView = ShowLogViewController()
                        self.presentAsSheet(self.logView!)
                    }
                    self.logView?.updateLog(line: "\(log)\n") },
                completion: { [weak self] result in
                    guard let self = self else { return }
                    if result.status == 0 {
                        if let logView = self.logView {
                            self.dismiss(logView)
                        }
                    } else {
                        self.showAlert(title: "Clone Error",
                                        informativeText: "Error cloning repository.",
                                        buttonTitle: "OK")
                    }
                    self.flowController?.didChangeIntegratedRepositories()
            })
        } else {
            showAlert(
                title: "Empty build script.",
                informativeText: "The build script cannot be empty.",
                buttonTitle: "OK")
        }
    }

    @IBAction func didPressDeIntegrate(_ sender: Any) {
        showAlert(title: "Deintegrate Repository?",
                  informativeText: "The pipeline of this repository will delete!",
                  confirmationTitle: "OK",
                  cancelTitle: "Cancel") { confirmation in
                    if confirmation { presenter.deIntegrate() }
                    flowController?.didChangeIntegratedRepositories()
        }
    }

}
