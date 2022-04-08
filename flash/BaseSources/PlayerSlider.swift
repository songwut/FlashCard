//
//  PlayerSlider.swift
//  LEGO
//
//  Created by Songwut on 1/8/2561 BE.
//  Copyright © 2561 Conicle. All rights reserved.
//

import UIKit

protocol PlayerSliderDelegate {
    func touchDownSlider(value: Float)
    func didEndSeekFromSlider(value: Float)
    func didTouchDragOutsite(value: Float)
    func didError(error: PlayerSliderError)
}

enum PlayerSliderError: Error{
    case overLimited
}

class PlayerSlider: UISlider {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBInspectable private var trackHeight: CGFloat = 3
    @IBInspectable private var thumbRadius: CGFloat = 20
    private(set) var isTouchThumb: Bool = false
    private(set) var limitedValue: Float = 0
    var delegate: PlayerSliderDelegate?
    var isNonSkipable: Bool = false
    
    func setForceValue(_ value: Float, animated: Bool) {
        if !isTouchThumb || isNonSkipable == false {
            super.setValue(value, animated: animated)
            if self.limitedValue <= value {
                self.limitedValue = value
            }
        }
    }
    
    func setLimitedValue(_ limitedValue: Float) {
        self.limitedValue = limitedValue
    }
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .white
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.white.cgColor
        return thumb
    }()
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 6.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // See this: https://stackoverflow.com/a/41288197/7235585
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        self.thumbTintColor = .white
        self.tintColor = .white
        self.setThumbImage(UIImage(named: "ic_v2_thumb"), for: .normal)
        self.minimumTrackTintColor = .white
        self.maximumTrackTintColor = .gray
        super.awakeFromNib()
        self.addTarget(self, action: #selector(self.didEndSeekFromSlider), for: [.touchUpInside , .touchUpOutside])
        self.addTarget(self, action: #selector(self.didTouchSlider), for: [.touchDown])
        self.addTarget(self, action: #selector(self.didTouchDragSlider), for: [.touchDragInside, .touchDragOutside])
        let thumb = thumbImage(radius: thumbRadius)
        self.setThumbImage(thumb, for: .normal)
    }
    
    @objc private func didTouchSlider() {
        isTouchThumb = true
        delegate?.touchDownSlider(value: self.value)
    }
    
    @objc private func didTouchDragSlider() {
        isTouchThumb = true
        delegate?.didTouchDragOutsite(value: self.value)
    }
    
    @objc private func didEndSeekFromSlider() {
        isTouchThumb = false
        if (self.value - self.limitedValue) > 1  && self.isNonSkipable {
            self.value = limitedValue
            delegate?.didError(error: PlayerSliderError.overLimited)
        }
        delegate?.didEndSeekFromSlider(value: self.value)
    }
}
