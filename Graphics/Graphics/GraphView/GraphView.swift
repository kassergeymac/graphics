//
//  GraphView.swift
//  Graphics
//
//  Created by Sergey Kaliberda on 6/23/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import UIKit


@IBDesignable
class GraphView: UIView {
    
    private var graphLines: [GraphLine]!
    private var bezierLines: [UIBezierPath] = []
    
    func setGraphLines(graphLines: [GraphLine]) {
        self.graphLines = graphLines
        self.setNeedsDisplay()
        UIView.transition(with: self,
                          duration: 2.0,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.layer.displayIfNeeded()
        },
                          completion: nil)
    }
    
    @IBInspectable var topMargin:CGFloat = 10.0
    @IBInspectable var bottomMargin:CGFloat = 10.0
    @IBInspectable var leftMargin:CGFloat = 10.0
    @IBInspectable var rightMargin:CGFloat = 10.0
    @IBInspectable var shouldShowHorizontalLines:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyDefaultUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyDefaultUI()
    }
    
    private func applyDefaultUI(){
        self.backgroundColor = UIColor.white
    }
    
    struct Constants {
        static let lineWidth:CGFloat = 2.0
        static let horizontalLinesCount:Int = 6
        static let horizontalLineColor = UIColor(red: 201.0/255.0,
                                                 green: 203.0/255.0,
                                                 blue: 204.0/255.0,
                                                 alpha: 1.0)
        static let horizontalLineWidth:CGFloat = 0.5
        static let horizontalLineTitleFontSize:CGFloat = 12.0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let maxYValue = self.findMaxValueForYAxes()
        for axis in self.graphLines {
            self.drawGraph(for: axis, inRect: rect, maxYValue:maxYValue)
        }
        if self.shouldShowHorizontalLines {
            self.drawHorizontalLines(count: Constants.horizontalLinesCount,
                                     minValue: 0,
                                     maxValue: maxYValue,
                                     inRect: rect)
        }
    }
    
    func findMaxValueForYAxes() -> Float {
        var maxValue = -Float.greatestFiniteMagnitude
        for axis in self.graphLines {
            guard let maxValueForAxis = axis.values.max() else {
                continue
            }
            if maxValue<maxValueForAxis {
                maxValue = maxValueForAxis
            }
        }
        return maxValue
    }
    
    func drawGraph(for coordinateAxis: GraphLine,
                   inRect rect:CGRect,
                   maxYValue: Float) {
        coordinateAxis.color?.setFill()
        coordinateAxis.color?.setStroke()
        let countOfValues = coordinateAxis.values.count
        
        if countOfValues < 1 {
            return
        }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.calculateXPosition(forPosition: 0,
                                                         countOfValues: countOfValues,
                                                         inRect: rect),
                              y: self.calculateYPosition(forValue: coordinateAxis.values[0],
                                                         maxYValue: maxYValue,
                                                         inRect: rect)))
        for i in 1..<countOfValues {
            path.addLine(to: CGPoint(x: self.calculateXPosition(forPosition: i,
                                                                countOfValues: countOfValues,
                                                                inRect: rect),
                                     y: self.calculateYPosition(forValue: coordinateAxis.values[i],
                                                                maxYValue: maxYValue,
                                                                inRect: rect)))
        }
        path.lineWidth = Constants.lineWidth
        path.stroke()
    }
    
    func calculateXPosition(forPosition position: Int,
                            countOfValues: Int,
                            inRect rect: CGRect) -> CGFloat {
        //30 points, 3 elements
        //0, 10, 20 - space right - position/countOfValues
        //10, 20, 30 - space left - (position+1)/countOfValues
        //0, 15, 30 - 👍 - position/(countOfValues+1)
        let width = rect.width-self.leftMargin-self.rightMargin
        return (CGFloat(position))/CGFloat(countOfValues-1)*width+self.leftMargin
    }
    
    func calculateYPosition(forValue value: Float,
                            maxYValue: Float,
                            inRect rect: CGRect) -> CGFloat {
        let height = rect.height-self.topMargin-self.bottomMargin
        let yPosition = CGFloat(value/maxYValue)*height-self.topMargin
        //inverse y position
        return height-yPosition
    }
    
    func drawHorizontalLines(count: Int, minValue: Float, maxValue: Float, inRect rect: CGRect) {
        if (graphLines == nil) {
            return
        }
        if (graphLines.count == 0) {
            return
        }
        let lines = UIBezierPath()
        Constants.horizontalLineColor.setStroke()
        for i in 0..<count {
            let lineYValue = Float(i)/Float(count)*maxValue
            let yPosition = self.calculateYPosition(forValue: lineYValue,
                                                    maxYValue: maxValue,
                                                    inRect: rect)
            lines.move(to: CGPoint(x: self.leftMargin, y:yPosition))
            lines.addLine(to: CGPoint(x:rect.width-self.rightMargin, y:yPosition))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: Constants.horizontalLineTitleFontSize)!,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let lineDescription = "\(Int(lineYValue))"
            lineDescription.draw(with: CGRect(x: self.leftMargin,
                                              y: yPosition-self.bottomMargin-4.0,
                                              width: 100,
                                              height: 15),
                                 options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        lines.lineWidth = Constants.horizontalLineWidth
        lines.stroke()
    }

}
