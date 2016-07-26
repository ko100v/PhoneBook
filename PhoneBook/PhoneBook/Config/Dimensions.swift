//
//  Dimensions.swift
//  PhoneBook
//
//  Created by Dimitar Kostov on 7/25/16.
//  Copyright © 2016 Dimitar Kostov. All rights reserved.
//

import UIKit

public struct Basic {
    public struct Offset {
        static let x: CGFloat = 8
        static let y: CGFloat = Basic.Offset.x
    }
    
    public struct Size {
        static let StatusBarHeight: CGFloat = 20
        static let NavigationBarHeight: CGFloat = 44
        static let SearchBarHeight: CGFloat = 44
        static let ButtonHeight: CGFloat = 44
        static let SegmentHeight: CGFloat = 30
    }
}