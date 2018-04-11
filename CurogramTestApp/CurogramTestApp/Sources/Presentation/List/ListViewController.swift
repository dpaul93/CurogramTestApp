//
//  ListViewController.swift
//  CurogramTestApp
//
//  Created Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

// MARK: - Implementation

class ListViewController: UIViewController, ListPresenterOutput {
    @IBOutlet weak var listTableView: UITableView!
    fileprivate var presenter: ListPresenter!
    private var progressViewCounter: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    
    private func setupTableView() {
        listTableView.separatorColor = .gray
        listTableView.tableFooterView = UIView(frame: .zero)
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 116
        
        listTableView.register(ListTableViewCell.nib(), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier())
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonDidTap(_:)))
        navigationItem.setRightBarButton(addButton, animated: true)
        
        let restoreButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(onRestoreButtonDidTap(_:)))
        navigationItem.setLeftBarButton(restoreButton, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func onAddButtonDidTap(_ sender: Any) {
        let progressView = addProgressView()
        progressViewCounter += 1
        presenter.handleAddNumber { [weak self] progress in
            progressView.progress = Float(progress)
            if progressView.progress >= 1.0 {
                self?.removeProgressView(progressView)
            }
        }
    }
    
    @objc private func onRestoreButtonDidTap(_ sender: Any) {
        guard presenter.hasItemsToRestore() else { return }
        
        let progressView = addProgressView()
        progressViewCounter += 1
        presenter.handleRestoreNumber { [weak self] progress in
            progressView.progress = Float(progress)
            if progressView.progress >= 1.0 {
                self?.removeProgressView(progressView)
            }
        }
    }

    // MARK: - ListPresenterOutput
    
    func handleDataDidUpdate() {
        listTableView.reloadData()
    }
    
    // MARK: - Helpers
    private func addProgressView() -> UIProgressView {
        let spacing: CGFloat = 25
        let progressView = UIProgressView(frame: .zero)
        progressView.frame.origin.y = view.bounds.height
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        let y = progressViewCounter * spacing + spacing
        let bottomConstraint = progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -y)
        bottomConstraint.identifier = String(progressView.hash)
        bottomConstraint.isActive = true
        progressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: spacing).isActive = true
        progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -spacing).isActive = true
        
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
        return progressView
    }
    
    private func removeProgressView(_ progressView: UIProgressView) {
        view.constraints.filter { $0.identifier == String(progressView.hash) }.first?.constant = 0
        progressViewCounter -= 1
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            progressView.removeFromSuperview()
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier()) as? ListTableViewCell,
            let viewModel = presenter.viewModels[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.populate(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let viewModel = presenter.viewModels[safe: indexPath.row] {
                presenter.handleRemoveNumber(with: viewModel)
            }
        }
    }
}

extension ListViewController: UITableViewDelegate {
    
}

// MARK: - Factory

final class ListViewControllerFactory {
    static func new(
        presenter: ListPresenter
    ) -> ListViewController? {
        guard let controller = UIStoryboard.instantiateViewController(type: .list) as? ListViewController else {  return nil }
        controller.presenter = presenter
        presenter.output = controller
        return controller
    }
}
