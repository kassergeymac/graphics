//
//  ViewController.swift
//  Graphics
//
//  Created by Sergey Kaliberda on 6/17/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var graphics: [Graphic]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "chart_data", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! Array<Dictionary<String, Any>>
        self.graphics = StupidJsonParser().graphics(fromJson: json)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let graphicVC = storyboard.instantiateViewController(withIdentifier: "GraphicViewController") as! GraphicViewController
        graphicVC.graphic = self.graphics[0]
        let graphicNavVC = UINavigationController(rootViewController: graphicVC)
        graphicVC.title = "Statistics"
        self.present(graphicNavVC,
                     animated: true,
                     completion: nil)
    }
    
    
}

