//
//  GridView.swift
//  PixelArt
//
//  Created by Daniil on 04.06.2022.
//

import UIKit

final class GridView: UIView {
    private struct LineCoordinates {
        let firstCoordinate: CGPoint
        let secondCoordinate: CGPoint
    }
    
    private struct Node: Equatable {
        var color: UIColor
        let point: CGPoint
    }
    
    private var rows: Int = 0
    private var columns: Int = 0
    private var cellSize: CGSize = .zero
    
    private var lines: [LineCoordinates] = []
    private var nodes: [Node] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        
        // draw grid
        
        context?.setStrokeColor(UIColor.black.cgColor)
        
        lines.forEach {
            context?.move (to: $0.firstCoordinate)
            context?.addLine (to: $0.secondCoordinate)
            context?.strokePath()
        }
        
        // draw selected rectangles
        
        nodes.forEach { node in
            context?.setFillColor(node.color.cgColor)
            context?.addRect(.init(x: node.point.x + 1, y: node.point.y + 1, width: cellSize.width - 1, height: cellSize.height - 1))
            context?.fillPath()
        }
    }
    
    func configure(rows: Int, columns: Int, cellSize: CGSize) {
        lines.removeAll()
        nodes.removeAll()
        
        self.rows = rows
        self.columns = columns
        self.cellSize = cellSize
        calculateCoordinates()
        calculateNodes()
        setNeedsDisplay()
    }
    
    func handleTap(point: CGPoint, color: UIColor) {
        let leftTopNodeIndex = nodes.firstIndex { node in
            let xCondition = node.point.x < point.x && node.point.x + cellSize.width > point.x
            let yCondition = node.point.y < point.y && node.point.y + cellSize.height > point.y
            return xCondition && yCondition
        }
        
        guard let leftTopNodeIndex = leftTopNodeIndex else {
            return
        }
        
        nodes[leftTopNodeIndex].color = color
        setNeedsDisplay()
    }
    
    private func calculateCoordinates() {
        let verticalLines: [LineCoordinates] = (0...columns + 1).map { index in
            let firstCoordinate = CGPoint(x: CGFloat(index) * cellSize.width, y: 0)
            let maxY: CGFloat = (CGFloat(rows) + 1) * cellSize.height
            let secondCoordinate = CGPoint(x: CGFloat(index) * cellSize.width, y: maxY)
            
            return LineCoordinates(
                firstCoordinate: firstCoordinate,
                secondCoordinate: secondCoordinate
            )
        }
        
        let horizontalLines: [LineCoordinates] = (0...rows + 1).map { index in
            let firstCoordinate = CGPoint(x: 0, y: CGFloat(index) * cellSize.height)
            let maxX: CGFloat = (CGFloat(columns) + 1) * cellSize.width
            let secondCoordinate = CGPoint(x: maxX, y: CGFloat(index) * cellSize.height)
            
            return LineCoordinates(
                firstCoordinate: firstCoordinate,
                secondCoordinate: secondCoordinate
            )
        }
        
        lines = verticalLines + horizontalLines
    }
    
    private func calculateNodes() {
        (0...rows + 1).forEach { row in
            (0...columns + 1).forEach { column in
                nodes.append(
                    .init(
                        color: .white,
                        point: .init(
                            x: CGFloat(column) * cellSize.width,
                            y: CGFloat(row) * cellSize.height
                        )
                    )
                )
            }
        }
    }
}
