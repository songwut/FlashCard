//
//  FLAnimateVC.swift
//  flash
//
//  Created by Songwut Maneefun on 2/7/2564 BE.
//

import UIKit
import iCarousel

class FLAnimateVC: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var items: [Int] = []
    @IBOutlet var carousel: iCarousel!

    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0 ... 99 {
            items.append(i)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .linear
        carousel.isPagingEnabled = true
        //carousel.contentOffset = CGSize(width: 20, height: 20)
        carousel.reloadData()
    }

    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView

        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            let width = carousel.frame.width * FlashStyle.pageCardWidthRatio
            let height = width * FlashStyle.pageCardRatio
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            itemView.image = UIImage(named: "page")
            itemView.contentMode = .scaleAspectFill
            itemView.backgroundColor = .black

            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = label.font.withSize(50)
            label.tag = 1
            itemView.addSubview(label)
        }

        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = "\(items[index])"

        return itemView
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        print("DidEndDecelerating")
    }
}
