//
//  DrawLoginDesignable.swift
//  DrawLoginView
//
//  Created by Volkan SÖNMEZ on 1.08.2020.
//  Copyright © 2020 sonmez.volkan. All rights reserved.
//

import Foundation
import UIKit

public class DrawLoginDesignable: UIView {
    
    internal var _borderColor = UIColor(red: 13, green: 24, blue: 31);
    internal var _borderWidth: CGFloat = 10.0;
    internal var _withAnimate: Bool = true;
    internal var _scaleValue: CGFloat = 0.9;
    internal var _showFootPrint = true;
    internal var _rowColumnCount: Int = 4
    internal var _nodeWidth: CGFloat = 70.0
    
    @IBInspectable public var borderWidth: CGFloat
    {
        get { return self._borderWidth; }
        set { self._borderWidth = newValue; }
    }
    
    @IBInspectable public var borderColor: UIColor
    {
        get { return self._borderColor; }
        set { self._borderColor = newValue; }
    }
    
    @IBInspectable public var selectedColor: UIColor
    {
        get { return NodeView.SELECTED_COLOR; }
        set { NodeView.SELECTED_COLOR = newValue; }
    }
    
    @IBInspectable public var unSelectedColor: UIColor
    {
        get { return NodeView.UNSELECTED_COLOR; }
        set { NodeView.UNSELECTED_COLOR = newValue; }
    }
    
    @IBInspectable public var withAnimate: Bool
    {
        get { return self._withAnimate; }
        set { self._withAnimate = newValue; }
    }
    
    @IBInspectable public var scaleValue: CGFloat
    {
        get { return self._scaleValue; }
        set { self._scaleValue = newValue; }
    }
    
    @IBInspectable public var nodeWidth: CGFloat
    {
        get { return self._nodeWidth; }
        set { self._nodeWidth = newValue; }
    }
    
    @IBInspectable public var showFootPrint: Bool
    {
        get { return self._showFootPrint; }
        set { self._showFootPrint = newValue; }
    }
    
    @IBInspectable public var rowColumnCount: Int
    {
        get { return self._rowColumnCount; }
        set { self._rowColumnCount = newValue; }
    }
}
