//
//  UIViewExtension.swift
//  DrawLoginView
//
//  Created by Volkan Sönmez on 16.01.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import UIKit;

extension UIView
{
    public var globalFrame: CGRect?
    {
        return self.superview?.convert(self.frame, to: nil);
    }
    
    public var allSubviews: [UIView]
    {
        return self.subviews.flatMap { [$0] + $0.allSubviews };
    }
    
    public func rotate(angle: CGFloat)
    {
        let radians = angle / 180.0 * CGFloat.pi;
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation;
    }
}
