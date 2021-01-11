//
//  BETableHeaderView.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/26/20.
//

import Foundation

open class BETableHeaderView: BEView {
    // MARK: - Properties
    weak var tableView: UITableView?
    
    // MARK: - Initializers
    public required convenience init(tableView: UITableView) {
        self.init(frame: .zero)
        self.tableView = tableView
        defer {
            setUpTableHeaderView()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        reassignTableHeaderView()
    }
    
    func setUpTableHeaderView() {
        guard let tableView = tableView else {return}
        let containerView = UIView(forAutoLayout: ())
        
        containerView.addSubview(self)
        self.autoPinEdgesToSuperviewEdges()
        
        tableView.tableHeaderView = containerView
        
        containerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        
        tableView.tableHeaderView?.layoutIfNeeded()
    }
    
    func reassignTableHeaderView() {
        superview?.layoutIfNeeded()
        tableView?.tableHeaderView = tableView?.tableHeaderView
    }
}
