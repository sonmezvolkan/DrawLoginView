//
//  DrawLoginView.swift
//  DrawLoginView
//
//  Created by Volkan Sönmez on 16.01.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import UIKit;

open class DrawLoginView: UIView
{
    private var borderColor = UIColor(red: 13, green: 24, blue: 31);
    private var borderWidth: CGFloat = 10.0;
    private var withAnimate: Bool = true;
    private var scaleValue: CGFloat = 0.9;
    private var showFootPrint = true;
    
    private var onMoveFinished: ((String) -> Void)?;
    
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
    
    @IBInspectable public var WithAnimate: Bool
    {
        get { return self.withAnimate; }
        set { self.withAnimate = newValue; }
    }
    
    @IBInspectable public var ScaleValue: CGFloat
    {
        get { return self.scaleValue; }
        set { self.scaleValue = newValue; }
    }
    
    @IBInspectable public var ShowFootPrint: Bool
    {
        get { return self.showFootPrint; }
        set { self.showFootPrint = newValue; }
    }
    
    private var route: [CircleView]?;
    private var footPrints: [CAShapeLayer] = [CAShapeLayer]();
    
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
        self.changeBackgroundCircleViews();
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for view in self.allSubviews where view is CircleView
        {
            if  let point = touches.first?.location(in: self.superview)
            {
                if let viewTouched = self.superview!.hitTest(point, with: event), viewTouched == view
                {
                    self.route = [CircleView]();
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
                for view in self.allSubviews where view is CircleView
                {
                    if let circleViewFrame = view.globalFrame
                    {
                        if (self.isInArea(point: point, frame: circleViewFrame))
                        {
                            self.addRoute(circleView: view as! CircleView);
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
            circleView.select(withAnimate: self.withAnimate, scaleValue: self.scaleValue);
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
        if let route = self.route, route.count > 1, ShowFootPrint
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
        if let route = self.route, route.count > 0
        {
            var result = "";
            for circleView in route
            {
                result += circleView.Key;
                circleView.reset();
            }
            self.onMoveFinished?(result);
            self.route?.removeAll();
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
    
    public func changeBackgroundCircleViews()
    {
        for circleView in self.allSubviews where circleView is CircleView
        {
            circleView.backgroundColor = self.UnSelectedColor;
        }
    }
}

extension DrawLoginView
{
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

