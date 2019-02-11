//
//  AddressesViewModel.swift
//  PhotoBrowser
//
//  Created by zf on 2019/2/12.
//  Copyright © 2019 zf. All rights reserved.
//

import UIKit
import RxSwift

class AddressesViewModel: NSObject {

    var address:Variable<[AddressBook]> = {
        
        let a1 = AddressBook(name: "a1")
        let a2 = AddressBook(name: "a2")
        let a3 = AddressBook(name: "a3")
        let a4 = AddressBook(name: "a4")
        let a5 = AddressBook(name: "a5")
        
        let array = [a1,a2,a3,a4,a5]
        return Variable(array)
    }()
    
    func addAddress(name: String) {
        let ax = AddressBook(name: name)
        address.value.append(ax)
    }
}
