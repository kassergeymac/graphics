//
//  GraphicViewController.swift
//  Graphics
//
//  Created by Sergey Kaliberda on 6/30/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import UIKit

class GraphicViewController: UITableViewController, LegendTableControllerDelegate {
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var periodSelectionView: GraphView!
    @IBOutlet weak var legendTable: UITableView!
    var legendTableController: LegendTableController!
    
    var graphic: Graphic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.legendTableController = LegendTableController(graphLines: self.graphic.yAxes)
        self.legendTable.dataSource = self.legendTableController
        self.legendTable.delegate = self.legendTableController
        self.legendTableController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.graphView.setGraphLines(graphLines: self.graphic.yAxes)
        self.periodSelectionView.shouldShowHorizontalLines = false
        self.periodSelectionView.setGraphLines(graphLines: self.graphic.yAxes)
    }

    func legendTableController(_ legendTableController: LegendTableController, selectedGraphLines: [GraphLine]) {
        self.graphView.setGraphLines(graphLines: selectedGraphLines)
        self.periodSelectionView.setGraphLines(graphLines: selectedGraphLines)
    }
    
}
