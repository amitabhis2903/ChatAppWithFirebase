//
//  Extension.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 03/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    func loadImageCacheWithUrlString(urlString: String)
    {
        self.image = nil
        
        //Mark: Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.image = cachedImage
            return
        }
        
        
        //Mark: Download for new images
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Download Image Successfull
            
            DispatchQueue.main.async {
                
                if let downloadImage = UIImage(data: data!)
                {
                    imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                    self.image = downloadImage
                }
                
               
            }
            
        }).resume()
        
    }
}
