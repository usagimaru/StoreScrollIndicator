//
//  ScrollIndicatorView.swift
//
//  Created by Satori Maru on 16.10.11.
//  Copyright © 2016年 usagimaru. All rights reserved.
//

import UIKit

// Original Background Color: #D8D8D8
// Original Indicator Color: #525252

class ScrollIndicatorView: UIView {
	
	enum ScrollIndicatorStyle: Int {
		case marker
		case progress
	}
	
	private var fadingIn: Bool = false
	private var fadingOut: Bool = false
	private var pageValue: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	private var indicator = UIView()
	
	var numberOfPages: Int = 0
	var style: ScrollIndicatorStyle = .marker
	@IBInspectable var indicatorColor: UIColor! = #colorLiteral(red: 0.3234693706, green: 0.3234777451, blue: 0.3234732151, alpha: 1) {
		didSet {
			indicator.backgroundColor = indicatorColor
		}
	}
	
	
    override init(frame: CGRect) {
		super.init(frame: frame)
		_init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_init()
	}
	
	private func _init() {
		clipsToBounds = true
		alpha = 0.4
		
		indicator.clipsToBounds = true
		indicator.backgroundColor = indicatorColor
		
		addSubview(indicator)
	}
	
	
	// MARK: -
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if layer.cornerRadius != frame.height / 2 {
			layer.cornerRadius = frame.height / 2
		}
		if indicator.layer.cornerRadius != frame.height / 2 {
			indicator.layer.cornerRadius = frame.height / 2
		}
		
		let h = frame.height
		var w = CGFloat(0.0)
		var x = CGFloat(0.0)
		
		switch style {
		case .marker:
			x = pageValue
			w = numberOfPages > 0 ? frame.width / CGFloat(numberOfPages) : 0
		case .progress:
			w = pageValue
		}
		
		let indicatorFrame = CGRect(x: x, y: 0, width: w, height: h)
		indicator.frame = indicatorFrame
	}
	
	
	// MARK: -
	
	func scrollTo(pageOffset: CGFloat, pageWidth: CGFloat) {
		switch style {
		case .marker:
			let pageRate = (frame.width / pageWidth / CGFloat(numberOfPages))
			let x = pageOffset * pageRate
			pageValue = x
		case .progress:
			let pageRate = (frame.width / pageWidth / CGFloat(numberOfPages - 1))
			let x = pageOffset * pageRate
			pageValue = x
		}
	}
	
	func scrollToOffsetOf(scrollView: UIScrollView) {
		scrollTo(pageOffset: scrollView.contentOffset.x, pageWidth: scrollView.frame.width)
	}
	
	func fadeIn() {
		if fadingIn {return}
		
		fadingIn = true
		fadingOut = false
		UIView.animate(withDuration: 0.25,
		               delay: 0,
		               options: UIViewAnimationOptions.beginFromCurrentState,
		               animations: {
						self.alpha = 1.0
			},
		               completion: { (finished: Bool) in
						self.fadingIn = false
		})
	}
	
	func fadeOut() {
		if fadingOut {return}
		
		fadingOut = true
		fadingIn = false
		UIView.animate(withDuration: 0.8,
		               delay: 0.3,
		               options: UIViewAnimationOptions.beginFromCurrentState,
		               animations: {
						self.alpha = 0.4
			},
		               completion: { (finished: Bool) in
						self.fadingOut = false
		})
	}
	
}

extension ScrollIndicatorView: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView){
		scrollToOffsetOf(scrollView: scrollView)
		
		if scrollView.isTracking || scrollView.isDragging {
			fadeIn()
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		fadeOut()
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		fadeOut()
	}
	
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		fadeOut()
	}
	
}
