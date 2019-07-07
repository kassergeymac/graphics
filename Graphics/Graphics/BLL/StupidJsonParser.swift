//
//  StupidJsonParser.swift
//  Graphics
//
//  Created by Sergey Kaliberda on 6/17/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import UIKit

struct StupidJsonParser {
    
    public func graphics(fromJson json: Array<Dictionary<String, Any>>) -> [Graphic] {
        return json.map({ (graphicDict) -> Graphic in
            self.graphic(fromDictionary: graphicDict)
        })
    }
    
    private func graphic(fromDictionary dictionary: Dictionary<String, Any>) -> Graphic {
        let types = dictionary["types"] as! Dictionary<String, String>
        let xId = types.first { (key, value) -> Bool in
            if value == "x" {
                return true
            }
            return false
        }!.key
        let columnsY = (dictionary["columns"] as! Array<Array<Any>>).filter { (column) -> Bool in
            return (column[0] as! String) != xId
        }
        let columnX = (dictionary["columns"] as! Array<Array<Any>>).filter { (column) -> Bool in
            return (column[0] as! String) == xId
        }.first
        let coordinateAxesValues = columnsY.map { (column) -> (id: String, values: Array<Float>) in
            self.coordinateAxisValues(fromArray: column)
        }
        var coordinateAxes = coordinateAxesValues.map { (axisValues) -> GraphLine in
            GraphLine(id:axisValues.id,
                      name: "",
                      color: UIColor.black,
                      values: axisValues.values)
        }
        if let namesDict = dictionary["names"] as? Dictionary<String, String> {
            coordinateAxes = self.axisWithSetterProperties(fromCoordinateAxes: coordinateAxes,
                                                           propertiesDict: namesDict,
                                                           mapFunc: { (coordinateAxis, name) -> GraphLine in
                                                            var coordinateAxis = coordinateAxis
                                                            coordinateAxis.name = name
                                                            return coordinateAxis
            })
        }
        if let typesDict = dictionary["colors"] as? Dictionary<String, String> {
            coordinateAxes = self.axisWithSetterProperties(fromCoordinateAxes: coordinateAxes,
                                                           propertiesDict: typesDict,
                                                           mapFunc: { (coordinateAxis, hexColor) -> GraphLine in
                                                            var coordinateAxis = coordinateAxis
                                                            let color = self.colorWithHexString(hexString: hexColor)
                                                            coordinateAxis.color = color
                                                            return coordinateAxis
            })
        }
        return Graphic(x: self.timeStamps(forColumnX: columnX!), yAxes: coordinateAxes)
    }
    
    private func coordinateAxisValues(fromArray array: Array<Any>) -> (id: String, values: Array<Float>) {
        let id = array.first as! String
        let values = Array(array[1...]).map { (number) -> Float in
            (number as! NSNumber).floatValue
        }
        return (id, values)
    }
    
    private func axisWithSetterProperties<T>(fromCoordinateAxes coordinateAxes: Array<GraphLine>,
                                          propertiesDict: [String: T],
                                          mapFunc: (GraphLine, T) -> GraphLine) -> Array<GraphLine> {
        return coordinateAxes.map { (coordinateAxis) in
            guard let value = propertiesDict[coordinateAxis.id] else {
                return coordinateAxis
            }
            return mapFunc(coordinateAxis, value)
            
        }
    }
    
    private func timeStamps(forColumnX columnX: Array<Any>) -> [Date] {
        let timestamps = Array(columnX[1...]) as! Array<Int>
        return timestamps.map({ (timestamp) -> Date in
            Date(timeIntervalSince1970: TimeInterval(timestamp))
        })
    }
    
    private func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    private func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
}
