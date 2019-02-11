//
//  Const.swift
//  PhotoBrowser
//
//  Created by zf on 2019/2/3.
//  Copyright © 2019 zf. All rights reserved.
//

import Foundation
import UIKit

let kScrennWidth = UIScreen.main.bounds.size.width

let buyShow1 = "http://image.baidu.com/channel/listjson"

func dPrint(file: String = #file, lineNum: Int = #line, item: @autoclosure () -> Any) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print ("fileName:\(fileName) , lineNum:\(lineNum), \(item())")
    #endif
}

