//
//  PhotoFullController.swift
//  PhotoBrowser
//
//  Created by zf on 2019/2/9.
//  Copyright © 2019 zf. All rights reserved.
//

import UIKit
import SDWebImage
import RxCocoa
import RxSwift

class PhotoFullController: UIViewController {

    @IBOutlet weak var photoFullImageView: UIImageView!
    var imageurl: String = ""
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var infoField: UITextField!
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoFullImageView.sd_setImage(with: URL(string: imageurl), placeholderImage: nil, options: [SDWebImageOptions.allowInvalidSSLCertificates], completed: nil)
        
        //closeBtn.addTarget(self, action: #selector(closeDone), for: UIControl.Event.touchUpInside)
        closeBtn.rx.tap.subscribe { (event: Event<()>) in
            
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
        
        infoField.rx.text.subscribe(onNext: { (str: String?) in
            dPrint(item: str ?? "")
        }).disposed(by: bag)
        
        infoField.rx.text.bind(to: infoLabel.rx.text).disposed(by: bag)
        
        
        //kvo
        //infoLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
        
        //rx
        infoLabel.rx.observe(String.self, "text").subscribe(onNext: { (str: String?) in
            dPrint(item:"rx 方式监听 label text ：\( str ?? "")")
            
            if str == "123" {
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "checkRX", sender: nil)
                }
                
                
            }
        }).disposed(by: bag)
    }

}


extension PhotoFullController {
    
    @objc func closeDone() {
        dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "text" {
            dPrint(item: change ?? "")
        }
    }
}
