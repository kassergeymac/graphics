//
//  StupidJsonParserTest.swift
//  GraphicsTests
//
//  Created by Sergey Kaliberda on 6/17/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import XCTest

class StupidJsonParserTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGraphic_parseManyColumn_shouldReturnDatesForXAxis() {
        //given
        let json = [["columns": [["x", 1561315893, 1561316354, 1561317265, 1561381263, 1561318695],
                                 ["y1", 11, 22, 33, 44, 55],
                                 ["y2", 66, 77, 88, 99, 1]],
                     "types": ["x":"x", "y1":"line", "y2":"line"]]]
        
        //when
        let graphic = StupidJsonParser().graphics(fromJson: json).first!
        let xValues = [Date(timeIntervalSince1970: 1561315893),
                       Date(timeIntervalSince1970: 1561316354),
                       Date(timeIntervalSince1970: 1561317265),
                       Date(timeIntervalSince1970: 1561381263),
                       Date(timeIntervalSince1970: 1561318695)]
        
        //then
        XCTAssertEqual(graphic.x, xValues)
        XCTAssertEqual(graphic.yAxes[0].values, [11, 22, 33, 44, 55])
        XCTAssertEqual(graphic.yAxes[1].values, [66, 77, 88, 99, 1])
        XCTAssertEqual(graphic.yAxes[0].id, "y1")
        XCTAssertEqual(graphic.yAxes[1].id, "y2")
    }
    
    func testGraphic_parseManyColumnIdOfXNonStandart_shouldReturnDatesForXAxis() {
        //given
        let json = [["columns": [["x1", 1561315893, 1561316354, 1561317265, 1561381263, 1561318695],
                                 ["y1", 11, 22, 33, 44, 55],
                                 ["y2", 66, 77, 88, 99, 1]],
                     "types": ["x1":"x", "y1":"line", "y2":"line"]]]
        
        //when
        let graphic = StupidJsonParser().graphics(fromJson: json).first!
        let xValues = [Date(timeIntervalSince1970: 1561315893),
                       Date(timeIntervalSince1970: 1561316354),
                       Date(timeIntervalSince1970: 1561317265),
                       Date(timeIntervalSince1970: 1561381263),
                       Date(timeIntervalSince1970: 1561318695)]
        
        //then
        XCTAssertEqual(graphic.x, xValues)
        XCTAssertEqual(graphic.yAxes[0].values, [11, 22, 33, 44, 55])
        XCTAssertEqual(graphic.yAxes[1].values, [66, 77, 88, 99, 1])
        XCTAssertEqual(graphic.yAxes[0].id, "y1")
        XCTAssertEqual(graphic.yAxes[1].id, "y2")
    }
    
    func testGraphic_parseManyColumn_shouldReturnValuesForAxis() {
        //given
        let json = [["columns": [["x", 1561315893, 1561316354, 1561317265, 1561381263, 1561318695],
                                 ["y1", 11, 22, 33, 44, 55],
                                 ["y2", 66, 77, 88, 99, 1]],
                     "types": ["x":"x", "y1":"line", "y2":"line"]]]
        
        //when
        let graphic = StupidJsonParser().graphics(fromJson: json).first!
        
        //then
        XCTAssertEqual(graphic.yAxes[0].values, [11, 22, 33, 44, 55])
        XCTAssertEqual(graphic.yAxes[1].values, [66, 77, 88, 99, 1])
        XCTAssertEqual(graphic.yAxes[0].id, "y1")
        XCTAssertEqual(graphic.yAxes[1].id, "y2")
    }
    
    func testGraphic_parseManyColumnWithNames_shouldReturnValuesAndNamesForAxis() {
        //given
        let json = [["columns": [["x", 1561315893, 1561316354, 1561317265, 1561381263, 1561318695],
                                 ["y1", 11, 22, 33, 44, 55],
                                 ["y2", 66, 77, 88, 99, 1]],
                     "names": ["y1":"line1", "y2":"line2"],
                     "types": ["x":"x", "y1":"line", "y2":"line"]]]
        
        //when
        let graphic = StupidJsonParser().graphics(fromJson: json).first!
        
        //then
        XCTAssertEqual(graphic.yAxes[0].values, [11, 22, 33, 44, 55])
        XCTAssertEqual(graphic.yAxes[1].values, [66, 77, 88, 99, 1])
        XCTAssertEqual(graphic.yAxes[0].name, "line1")
        XCTAssertEqual(graphic.yAxes[1].name, "line2")
    }
    
    func testGraphic_parseManyColumnWithColors_shouldReturnValuesAndColors() {
        //given
        let json = [["columns": [["x", 1561315893, 1561316354, 1561317265, 1561381263, 1561318695],
                                 ["y1", 11, 22, 33, 44, 55],
                                 ["y2", 66, 77, 88, 99, 1],
                                 ["y3", 66, 77, 88, 99, 1]],
                     "colors":["y1":"#ff0000", "y2":"#00ff00", "y3":"#0000ff"],
                     "types": ["x":"x", "y1":"line", "y2":"line"]]]
        
        //when
        let graphic = StupidJsonParser().graphics(fromJson: json).first!
        
        //then
        XCTAssertEqual(graphic.yAxes[0].values, [11, 22, 33, 44, 55])
        XCTAssertEqual(graphic.yAxes[1].values, [66, 77, 88, 99, 1])
        XCTAssertEqual(graphic.yAxes[2].values, [66, 77, 88, 99, 1])
        XCTAssertEqual(graphic.yAxes[0].color, .red)
        XCTAssertEqual(graphic.yAxes[1].color, .green)
        XCTAssertEqual(graphic.yAxes[2].color, .blue)
    }
    
}
