//
//  PhotoCollectionViewController.swift
//  PhotoBrowser
//
//  Created by zf on 2019/2/3.
//  Copyright © 2019 zf. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Photo.Cell"

class PhotoCollectionViewController: UICollectionViewController {

    
    @IBOutlet weak var flowLayout: PhotoFlowLayout!
    var pageNumber: Int = 0
    
    var images:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadImages(page: self.pageNumber)
    }
    
    
    func loadImages(page: Int) {
        let networkClient = NetworkClient.client
        let params: [String : Any] = ["pn" : page, "rn": 30, "tag1": "美女", "tag2": "全部", "ie": "utf8"]
        //pn=0&rn=30&tag1=美女&tag2=全部&ie=utf8
        dPrint(item: "params:\(params)")
        networkClient.request(method: .GET, url: buyShow1, params: params) { (resopnesJson:[[String :Any]]) in
            
            for item in resopnesJson {
                if let imageUrl = (item["image_url"] as? String){
                    self.images.append(imageUrl)
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        let photoFull = segue.destination as? PhotoFullController
        photoFull?.imageurl = sender as! String
        
    }


}


// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 66
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        cell.contentView.addSubview(imageView)
        if self.images.count > indexPath.item{
            if let url = URL(string: self.images[indexPath.item]) {
                //print("url--:\(url)")
                imageView.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.allowInvalidSSLCertificates], completed: nil)
            }
            
            if indexPath.item == (self.images.count - 1) {
                self.pageNumber += 1
                self.loadImages(page: self.pageNumber)
            }
        }
        
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegate
extension PhotoCollectionViewController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageurl = self.images[indexPath.item]
        self.performSegue(withIdentifier: "photoFull", sender: imageurl)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: flowLayout.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.margin
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: flowLayout.margin, left: flowLayout.margin, bottom: flowLayout.margin, right: flowLayout.margin)
    }
    
}

