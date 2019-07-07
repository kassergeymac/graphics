//
//  LegendTableController.swift
//  Graphics
//
//  Created by Sergey Kaliberda on 6/30/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import UIKit

protocol LegendTableControllerDelegate {
    func legendTableController(_ legendTableController: LegendTableController, selectedGraphLines: [GraphLine])
}

class LegendTableController: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let graphLines: [GraphLine]
    var selectedGraphLines: [GraphLine]
    
    var delegate: LegendTableControllerDelegate?
    
    struct Constants {
        static let cellReuseIdentifier = "graphLineDescrCell"
        static let rowHeight:CGFloat = 55.0
    }
    
    init(graphLines: [GraphLine]) {
        self.graphLines = graphLines
        self.selectedGraphLines = graphLines
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.graphLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) as? LegendTableViewCell
        if cell==nil {
            cell = LegendTableViewCell()
        }
        cell?.graphLine = self.graphLines[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LegendTableViewCell
        let currentGraphLine = cell.graphLine!
        let isSelectedGraphLine =  self.selectedGraphLines.contains { return $0 == currentGraphLine }
        if isSelectedGraphLine {
            self.selectedGraphLines.removeAll { return $0 == currentGraphLine }
            cell.accessoryType = .none
        } else {
            self.selectedGraphLines.append(currentGraphLine)
            cell.accessoryType = .checkmark
        }
        self.delegate?.legendTableController(self, selectedGraphLines: self.selectedGraphLines)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }

}
