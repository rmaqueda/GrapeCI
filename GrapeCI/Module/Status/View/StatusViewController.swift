//
//  StatusViewController.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 16/02/2020.
//  Copyright © 2020 Ricardo.Maqueda. All rights reserved.
//

import Cocoa
import Combine

class StatusViewController: NSViewController {
    private var presenter: StatusPresenterProtocol
    private weak var flowController: FlowControllerProtocol?
    private var subscriptions = Set<AnyCancellable>()
    private var statusViews: [StatusViewModel] = []

    @IBOutlet private weak var activityIndicator: NSProgressIndicator!
    @IBOutlet private weak var tableView: NSTableView!

    init(presenter: StatusPresenterProtocol, flowController: FlowControllerProtocol) {
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

        tableView.dataSource = self
        tableView.delegate = self
        tableView.action = #selector(onItemClicked)
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        reload()
    }

    func reload() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimation(self)
        presenter.refreshIntegratedRepositories()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.activityIndicator.isHidden = true
                    if case let .failure(error) = completion {
                        print(error)
                    }
                }, receiveValue: { [weak self] viewModels in
                    self?.statusViews = viewModels
                    self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }

    @objc private func onItemClicked() {
        let row = tableView.clickedRow
        guard row >= 0 else { return }

        let status = statusViews[row]

        if tableView.clickedColumn == 0, let log = status.log {
            let showLogVC = ShowLogViewController()
            showLogVC.log = log
            presentAsModalWindow(showLogVC)
        } else if let url = status.url {
            NSWorkspace.shared.open(url)
        }
    }

    @IBAction func didPressQuit(_ sender: Any) {
        NSApplication.shared.terminate(nil)
    }

    @IBAction func didPressConfig(_ sender: Any) {
        flowController?.loadConfigurationModule()
    }

}

extension StatusViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        statusViews.count
    }

}

extension StatusViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let statusView = statusViews[row]
        guard let column = tableColumn?.identifier.rawValue else { return nil }

        var cell: NSTableCellView?
        if column == "StatusColumn" {
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "StatusCell"),
                                      owner: self) as? NSTableCellView

            cell?.imageView?.image = NSImage(named: NSImage.Name(statusView.status.rawValue))
        } else if column == "InfoColumn" {
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "InfoCell"),
                                               owner: self) as? NSTableCellView

            cell?.textField?.attributedStringValue = NSAttributedString(string: statusView.infoText)
        } else if column == "ProviderColumn" {
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ProviderCell"),
                                              owner: self) as? NSTableCellView

            cell?.textField?.stringValue = statusView.provider.rawValue
        } else if column == "RepoColumn" {
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RepoCell"),
                                              owner: self) as? NSTableCellView

            cell?.textField?.stringValue = statusView.repositoryName
        }

        return cell
    }

}
