//
//  ViewController.swift
//  ShoppingCollectionView
//
//  Created by Akshay Yendhe on 13/02/23.
//

import UIKit

class ViewController: UIViewController  {
    
    
    var devices = [product] ()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData(){
        
        let url = URL(string: "https://dummyjson.com/products")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            guard let data = data ,error == nil else{
                
                return
            }
            do{
                let products = try JSONDecoder().decode(ProductsModel.self, from: data)
                self.devices = products.products
                DispatchQueue.main.sync {
                    self.collectionView.reloadData()
                }
            }
            catch let error{
                print("Error Decoding JSON \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
}

extension UIImageView{
    func downloadThumbnails (url : URL) {
        contentMode = .scaleToFill
        let imageTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            
            guard let httpURLres = response as? HTTPURLResponse, httpURLres.statusCode == 200,
                  let imageType = response?.mimeType, imageType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else{
                return
            }
            DispatchQueue.main.sync {
                self.image = image
            } 
            
        })
        imageTask.resume()
    }
}
extension  ViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! productCollectionViewCell
        let product = devices[indexPath.row]
        cell.imageUIImageView.image = UIImage(named: product.thumbnail)
        
        cell.titleUILabel.text = "Title : \(product.title)"
        cell.priceUILabel.text = "Price : \(product.price)"
        cell.brandUILabel.text = "Brand : \(product.brand)"
        cell.ratingUILabel.text = "Rating : \(product.rating)"
        cell.discountUILabel.text = "Discount : \(product.discountPercentage)"
        cell.descriptionUILabel.text = "Description : \(product.description)"
        let url = URL(string: product.thumbnail)!
        cell.imageUIImageView.downloadThumbnails(url: url)
        cell.imageUIImageView.layer.cornerRadius = 25
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/2, height: collectionWidth/2)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
