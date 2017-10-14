//
//  BotonAjustable.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 10/11/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit


class BotonAjustable : UIButton{
    
        override var intrinsicContentSize: CGSize {
            print("we me estan llamando")
            let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
            let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
            
            return desiredButtonSize
        }
    
}
