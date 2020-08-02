//
//  NodeView.swift
//  DrawLoginView
//
//  Created by Volkan Sönmez on 16.01.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import UIKit;

public class NodeView: UIView
{
    public static var UNSELECTED_COLOR = UIColor(red: 237, green: 237, blue: 237);
    public static var SELECTED_COLOR = UIColor(red: 13, green: 25, blue: 31);
    
    private var _key: String = "";
    
    public var row: Int?
    public var column: Int?
    
    @IBInspectable public var key: String
    {
        get { return self._key; }
        set { self._key = newValue; }
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder);
    }
    
    internal func design(width: CGFloat)
    {
        self.layer.cornerRadius = width / 2
        self.clipsToBounds = true;
        self.layer.borderWidth = 0.0;
        self.reset();
    }
    
    public func reset()
    {
        self.backgroundColor = NodeView.UNSELECTED_COLOR;
    }
    
    public func select()
    {
        self.backgroundColor = NodeView.SELECTED_COLOR;
    }
    
    public func select(withAnimate: Bool, scaleValue: CGFloat)
    {
        if (withAnimate)
        {
            self.animate(scaleValue: scaleValue);
        }
        else
        {
            self.backgroundColor = NodeView.SELECTED_COLOR;
        }
    }
    
    public func selectWithoutAnimation() {
        self.backgroundColor = NodeView.SELECTED_COLOR;
    }
    
    private func animate(scaleValue: CGFloat)
    {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations:
        {
            self.backgroundColor = NodeView.SELECTED_COLOR;
            self.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue);
        }) { (complete) in
            if (complete)
            {
                self.transform = .identity;
            }
        }
    }
}
