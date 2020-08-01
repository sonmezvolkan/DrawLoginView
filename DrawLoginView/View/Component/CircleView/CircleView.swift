//
//  CircleView.swift
//  DrawLoginView
//
//  Created by Volkan Sönmez on 16.01.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import UIKit;

public class CircleView: UIView
{
    public static var UNSELECTED_COLOR = UIColor(red: 237, green: 237, blue: 237);
    public static var SELECTED_COLOR = UIColor(red: 13, green: 25, blue: 31);
    
    private var key: String = "";
    
    @IBInspectable public var Key: String
    {
        get { return self.key; }
        set { self.key = newValue; }
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.design();
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder);
        self.design();
    }
    
    public override func awakeFromNib()
    {
        super.awakeFromNib();
        self.design();
    }
    
    private func design()
    {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true;
        self.layer.borderWidth = 0.0;
        self.reset();
    }
    
    public func reset()
    {
        self.backgroundColor = CircleView.UNSELECTED_COLOR;
    }
    
    public func select()
    {
        self.backgroundColor = CircleView.SELECTED_COLOR;
    }
    
    public func select(withAnimate: Bool, scaleValue: CGFloat)
    {
        if (withAnimate)
        {
            self.animate(scaleValue: scaleValue);
        }
        else
        {
            self.backgroundColor = CircleView.SELECTED_COLOR;
        }
    }
    
    private func animate(scaleValue: CGFloat)
    {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations:
        {
            self.backgroundColor = CircleView.SELECTED_COLOR;
            self.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue);
        }) { (complete) in
            if (complete)
            {
                self.transform = .identity;
            }
        }
    }
}
