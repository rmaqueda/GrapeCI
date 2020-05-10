//
//  ListViewController.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 25/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Cocoa
import Combine

class ListViewController: NSViewController {
    private var presenter: ListPresenterProtocol
    private weak var flowController: FlowControllerProtocol?
    private var repositories: [GitRepository] = []
    private var subscriptions = Set<AnyCancellable>()
    @Published private var searchText = ""

    @IBOutlet private weak var repositoryNameTextField: NSTextField!
    @IBOutlet private weak var activityIndicator: NSProgressIndicator!
    @IBOutlet private weak var tableView: NSTableView!

    init(presenter: ListPresenterProtocol, flowController: FlowControllerProtocol) {
        self.presenter = presenter
        self.flowController = flowController

        super.init(nibName: "ListViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        repositoryNameTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.action = #selector(onItemClicked)

        title = "Search repository"
        createSubcriber()
    }

    private func createSubcriber() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimation(self)

        $searchText
            .removeDuplicates()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .setFailureType(to: Error.self)
            .flatMap(presenter.fetchRepositories(nameFilter:))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    if case let .failure(error) = completion {
                        self.activityIndicator.isHidden = true
                        self.showAlert(title: "Error", text: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] repositories in
                    guard let self = self else { return }
                    self.repositories = repositories
                    self.activityIndicator.isHidden = true
                    self.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }

    func showAlert(title: String, text: String) {
        showAlert(title: title, informativeText: text, buttonTitle: "ok")
    }

    @objc private func onItemClicked() {
        guard tableView.clickedRow >= 0 else { return }
        let repository = repositories[tableView.clickedRow]
        flowController?.loadIntegrationModule(repository: repository)
    }

    func clear() {
        repositoryNameTextField.stringValue = ""
        presenter.fetchRepositories(nameFilter: "")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    if case let .failure(error) = completion {
                        self.activityIndicator.isHidden = true
                        self.showAlert(title: "Error", text: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] repositories in
                    guard let self = self else { return }
                    self.repositories = repositories
                    self.activityIndicator.isHidden = true
                    self.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
}

extension ListViewController: NSTextFieldDelegate {

    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            activityIndicator.isHidden = false
            activityIndicator.startAnimation(self)
            searchText = textField.stringValue
        }
    }

}

extension ListViewController: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        repositories.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn?.identifier.rawValue else { return nil }
        let repo = repositories[row]

        switch column {
        case "ProviderColumn":
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ProviderCell"),
                                          owner: self) as? NSTableCellView
            cell?.textField?.stringValue = repo.provider.rawValue

            return cell
        case "RepositoryNameColumn":
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RepositoryNameCell"),
                                          owner: self) as? NSTableCellView
            cell?.textField?.stringValue = repo.name

            return cell
        case "IntegratedColumn":
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IntegratedCell"),
                                          owner: self) as? NSTableCellView
            cell?.textField?.stringValue = String(repo.integrated)

            return cell
        default:
            return nil
        }
    }

}
