//
//  DrawLoginView.swift
//  DrawLoginView
//
//  Created by Mobil Bankacılık on 16.01.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import UIKit;

open class DrawLoginView: UIView
{
    private var borderColor = UIColor(red: 13, green: 24, blue: 31);
    private var borderWidth: CGFloat = 10.0;
    
    @IBInspectable public var BorderWidth: CGFloat
    {
        get { return self.borderWidth; }
        set { self.borderWidth = newValue; }
    }
    
    @IBInspectable public var BorderColor: UIColor
    {
        get { return self.borderColor; }
        set { self.borderColor = newValue; }
    }
    
    @IBInspectable public var SelectedColor: UIColor
    {
        get { return CircleView.SELECTED_COLOR; }
        set { CircleView.SELECTED_COLOR = newValue; }
    }
    
    @IBInspectable public var UnSelectedColor: UIColor
    {
        get { return CircleView.UNSELECTED_COLOR; }
        set { CircleView.UNSELECTED_COLOR = newValue; }
    }
    
    private var route: [CircleView]?;
    private var footPrints: [CAShapeLayer] = [CAShapeLayer]();
    
    private var allowFootPrint = false;
    
    @IBOutlet var contentView: UIView!
    
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
        let podBundle = Bundle(for: DrawLoginView.self)
        let bundleURL = podBundle.url(forResource: "DrawLoginView", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        bundle.loadNibNamed("DrawLoginView", owner: self, options: nil);
        self.addSubview(self.contentView);
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = [ .flexibleWidth, .flexibleHeight];
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for view in self.allSubviews where view is CircleView
        {
            if  let point = touches.first?.location(in: self.superview)
            {
                if let viewTouched = self.hitTest(point, with: event),viewTouched == view
                {
                    print("Tapped")
                    self.route = [CircleView]();
                    break;
                }
                else
                {
                    print("Not Tapped")
                }
            }
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let point = touches.first?.location(in: self.superview)
        {
            print("\(point)");
            
            for view in self.allSubviews where view is CircleView
            {
                if let circleViewFrame = view.globalFrame
                {
                    print("\(circleViewFrame)");
                    
                    if (point.x >= circleViewFrame.origin.x && point.x <= circleViewFrame.origin.x + circleViewFrame.width
                        && point.y >= circleViewFrame.origin.y && point.y <= circleViewFrame.origin.y + circleViewFrame.height
                        )
                    {
                        self.addRoute(circleView: view as! CircleView);
                        
                    }
                }
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let route = self.route
        {
            for circleView in route
            {
                print("\(circleView.Key)");
            }
        }
        
        self.reset();
    }
}

extension DrawLoginView
{
    private func addRoute(circleView: CircleView)
    {
        if (self.isLastNode(circleView: circleView))
        {
            self.route!.append(circleView);
            circleView.select();
            self.addFootPrint();
        }
    }
    
    private func isLastNode(circleView: CircleView) -> Bool
    {
        if let route = self.route
        {
            if (route.count == 0)
            {
                return true;
            }
            
            if (route.count == 1)
            {
                if (route[0].Key != circleView.Key)
                {
                    return true;
                }
            }
            
            if (route[route.count - 1].Key != circleView.Key)
            {
                return true;
            }
            return false;
        }
        return false;
    }
    
    private func addFootPrint()
    {
        if let route = self.route, route.count > 1, allowFootPrint
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
}
extension DrawLoginView
{
    open func reset()
    {
        for circleView in self.allSubviews where circleView is CircleView
        {
            let circle = circleView as! CircleView;
            circle.reset();
            self.route?.removeAll();
            print("\(circle.Key)");
        }
        
        for shape in self.footPrints
        {
            shape.removeFromSuperlayer();
        }
        self.footPrints.removeAll();
    }
}

