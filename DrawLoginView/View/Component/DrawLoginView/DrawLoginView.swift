//
//  DrawLoginView.swift
//  DrawLoginView
//
//  Created by Volkan Sönmez on 16.01.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import UIKit;

public class DrawLoginView: DrawLoginDesignable
{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    private var onMoveFinished: ((String) -> Void)?;
    
    private var route = [NodeView]()
    private var footPrints: [CAShapeLayer] = [CAShapeLayer]();
    
    private var keys = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame);
        self.setUp();
    }
    
    public required init?(coder: NSCoder)
    {
        super.init(coder: coder);
        self.setUp();
    }
    
    private func setUp()
    {
        let podBundle = Bundle(for: DrawLoginView.self);
        let bundleURL = podBundle.url(forResource: "DrawLoginView", withExtension: "bundle");
        let bundle = Bundle(url: bundleURL!)!;
        bundle.loadNibNamed("DrawLoginView", owner: self, options: nil);
        self.addSubview(self.contentView);
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = [ .flexibleWidth, .flexibleHeight];
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.changeBackgroundNodeViews();
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for view in self.allSubviews where view is NodeView
        {
            if  let point = touches.first?.location(in: self.superview)
            {
                if let viewTouched = self.superview!.hitTest(point, with: event), viewTouched == view
                {
                    self.route = [NodeView]();
                    break;
                }
            }
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let point = touches.first?.location(in: self.superview), let drawLoginViewFrame = self.globalFrame
        {
            if (self.isInArea(point: point, frame: drawLoginViewFrame))
            {
                for view in self.allSubviews where view is NodeView
                {
                    if let nodeViewFrame = view.globalFrame
                    {
                        if (self.isInArea(point: point, frame: nodeViewFrame))
                        {
                            self.addRoute(nodeView: view as! NodeView);
                        }
                    }
                }
            }
            else
            {
                self.reset();
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for nodeView in route {
            print("\(nodeView.key)");
        }
        
        self.reset();
    }
}

extension DrawLoginView {
    
    private func removeAllRows() {
        for row in mainStackView.arrangedSubviews {
            mainStackView.removeArrangedSubview(row)
        }
    }
    
    private func createRowsAndColumns() {
        if rowColumnCount <= 0 { return }
        
        for row in 0..<rowColumnCount {
            mainStackView.addArrangedSubview(createRow(row: row))
        }
    }
    
    private func createRow(row: Int) -> UIView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 0
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.backgroundColor = .clear
        
        for column in 0..<rowColumnCount {
            horizontalStackView.addArrangedSubview(createColumn(row: row, column: column))
        }
        
        return horizontalStackView
    }
    
    private func createColumn(row: Int, column: Int) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let nodeView = NodeView()
        containerView.addSubview(nodeView)
        nodeView.translatesAutoresizingMaskIntoConstraints = false
        nodeView.widthAnchor.constraint(equalToConstant: nodeWidth).isActive = true
        nodeView.heightAnchor.constraint(equalToConstant: nodeWidth).isActive = true
        nodeView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nodeView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nodeView.backgroundColor = NodeView.UNSELECTED_COLOR
        nodeView.key = getKey(row: row, column: column)
        nodeView.row = row
        nodeView.column = column
        nodeView.design(width: nodeWidth)
        
        return containerView
    }
    
    private func getKey(row: Int, column: Int) -> String {
        let index = row * rowColumnCount + column
        return keys[index]
    }
}

extension DrawLoginView
{
    private func addRoute(nodeView: NodeView)
    {
        if (!isSelfNode(nodeView: nodeView))
        {
            self.route.append(nodeView);
            nodeView.select(withAnimate: self.withAnimate, scaleValue: self.scaleValue);
            self.addFootPrint();
            if route.count > 1 {
                autoSelectNodesOnWay(nodeView: route[route.count - 2])
            }
        }
    }
    
    private func insertNodeForOnWay(node: NodeView) {
        node.selectWithoutAnimation()
        
        print("tmp key: \(node.key)")
        route.insert(node, at: route.count - 1)
    }
    
    private func autoSelectNodesOnWay(nodeView: NodeView) {
        guard let nodeRow = nodeView.row, let nodeColumn = nodeView.column, route.count > 0, let lastNode = route.last else { return }
        
        if nodeRow == lastNode.row {
            print("horizontal")
            selectHorizontallNodesOnWay(nodeView: nodeView, lastNode: lastNode)
        }
        
        if nodeColumn == lastNode.column {
            print("vertical")
            selectVerticalNodesOnWay(nodeView: nodeView, lastNode: lastNode)
        }
    }
    
    private func selectVerticalNodesOnWay(nodeView: NodeView, lastNode: NodeView) {
        guard let nodeRow = nodeView.row, let lastNodeRow = lastNode.row else { return }
        if nodeRow - nodeRow == 1 || nodeRow - lastNodeRow == -1 { return }
        
        print("node column: \(nodeRow)   - lastNodeColunm: \(lastNodeRow)")
        if nodeRow < lastNodeRow {
            let startIndex = nodeRow + 1
            for index in startIndex..<lastNodeRow {
                let rowStackView = mainStackView.arrangedSubviews[index] as! UIStackView
                let containerView = rowStackView.arrangedSubviews[nodeView.column!]
                if let tmpNodeView = containerView.getNodeViewIfIsExist() {
                    insertNodeForOnWay(node: tmpNodeView)
                }
            }
        }
        
        if lastNodeRow < nodeRow {
            let startIndex = nodeRow - 1
            for index in stride(from: startIndex, to: lastNodeRow, by: -1) {
                let rowStackView = mainStackView.arrangedSubviews[index] as! UIStackView
                let containerView = rowStackView.arrangedSubviews[nodeView.column!]
                if let tmpNodeView = containerView.getNodeViewIfIsExist() {
                    insertNodeForOnWay(node: tmpNodeView)
                }
            }
        }
    }
    
    private func selectHorizontallNodesOnWay(nodeView: NodeView, lastNode: NodeView) {
        guard let nodeColumn = nodeView.column, let lastNodeColumn = lastNode.column else { return }
        if nodeColumn - lastNodeColumn == 1 || nodeColumn - lastNodeColumn == -1 { return }
        let rowStackView = mainStackView.arrangedSubviews[nodeView.row!] as! UIStackView
        
        print("node column: \(nodeColumn)   - lastNodeColunm: \(lastNodeColumn)")
        if nodeColumn < lastNodeColumn {
            let startIndex = nodeColumn + 1
            for index in startIndex..<lastNodeColumn {
                let containerView = rowStackView.arrangedSubviews[index]
                if let tmpNodeView = containerView.getNodeViewIfIsExist() {
                    insertNodeForOnWay(node: tmpNodeView)
                }
            }
        }
        
        if nodeColumn > lastNodeColumn {
            let startIndex = nodeColumn - 1
            for index in stride(from: startIndex, to: lastNodeColumn, by: -1) {
                let containerView = rowStackView.arrangedSubviews[index]
                if let tmpNodeView = containerView.getNodeViewIfIsExist() {
                    insertNodeForOnWay(node: tmpNodeView)
                }
            }
        }
    }
    
    private func isSelfNode(nodeView: NodeView) -> Bool
    {
        if (route.count == 0) {
            return false
        }
            
        if (route.count == 1) {
            if (route[0].key != nodeView.key) {
                return false
            }
        }
            
        if (route[route.count - 1].key != nodeView.key) {
            return false
        }

        return true
    }
    
    private func addFootPrint()
    {
        if route.count > 1, showFootPrint
        {
            let startFrame = route[route.count - 2].globalFrame;
            let destinationFrame = route[route.count - 1].globalFrame;

            let startPoint = CGPoint(x: (startFrame!.origin.x + (startFrame!.width / 2)), y: startFrame!.origin.y + (startFrame!.height / 2));
            let destinationPoint = CGPoint(x: (destinationFrame!.origin.x + (destinationFrame!.width / 2)), y: destinationFrame!.origin.y + (destinationFrame!.height / 2));
            
            let sPoint = convert(startPoint, from: self.superview);
            let ePoint = convert(destinationPoint, from: self.superview);
            
            self.drawLine(start: sPoint, end: ePoint);
        }
    }
    
    private func drawLine(start: CGPoint, end: CGPoint)
    {
        let path = UIBezierPath();
        path.move(to: start);
        path.addLine(to: end);
    
        let shapeLayer = CAShapeLayer();
        shapeLayer.path = path.cgPath;
        shapeLayer.strokeColor = self.borderColor.cgColor;
        shapeLayer.lineWidth = self.borderWidth;
        shapeLayer.zPosition = -1;
        
        self.footPrints.append(shapeLayer);
        
        self.layer.addSublayer(shapeLayer);
    }
    
    private func isInArea(point: CGPoint, frame: CGRect) -> Bool
    {
        if (point.x >= frame.origin.x && point.x <= frame.origin.x + frame.width
            && point.y >= frame.origin.y && point.y <= frame.origin.y + frame.height)
        {
            return true;
        }
        return false;
    }
    
    private func setResult()
    {
        if route.count > 0 {
            var result = "";
            for nodeView in route
            {
                result += nodeView.key;
                nodeView.reset();
            }
            self.onMoveFinished?(result);
            self.route.removeAll();
        }
    }
    
    private func resetFootPrints()
    {
        for shape in self.footPrints
        {
            shape.removeFromSuperlayer();
        }
        self.footPrints.removeAll();
    }
    
    public func changeBackgroundNodeViews()
    {
        for nodeView in self.allSubviews where nodeView is NodeView
        {
            nodeView.backgroundColor = self.unSelectedColor;
        }
    }
}

extension DrawLoginView
{
    public func setKeys(keys: [String]) {
        self.keys = keys
    }
    
    public func createRows() {
        removeAllRows()
        createRowsAndColumns()
    }
    
    public func reset()
    {
        self.setResult();
        self.resetFootPrints();
    }
    
    public func setOnMoveFinished(onMoveFinished: @escaping ((String) -> Void))
    {
        self.onMoveFinished = onMoveFinished;
    }
}

