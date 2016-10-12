//
//  ViewController.swift
//  StoreScrollIndicator
//
//  Created by Satori Maru on 16.10.11.
//  Copyright © 2016年 usagimaru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var scrollIndicatorView1: ScrollIndicatorView!
	@IBOutlet weak var scrollIndicatorView2: ScrollIndicatorView!
	@IBOutlet weak var scrollIndicatorView3: ScrollIndicatorView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let pageCount = 5
		scrollIndicatorView1.numberOfPages = pageCount
		scrollIndicatorView2.numberOfPages = pageCount
		scrollIndicatorView3.numberOfPages = pageCount
		scrollIndicatorView1.style = .marker
		scrollIndicatorView2.style = .progress
		scrollIndicatorView3.style = .marker
		
		scrollView.layoutIfNeeded()
		scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pageCount), height: scrollView.frame.height)
		
		for i in 0..<pageCount {
			let v = UIView()
			v.clipsToBounds = true
			
			let x = scrollView.frame.width * CGFloat(i)
			v.frame = CGRect(x: x, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
			v.backgroundColor = UIColor(hue: CGFloat(i)/CGFloat(pageCount), saturation: 0.3, brightness: 1, alpha: 1)
			
			scrollView.addSubview(v)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

}

extension ViewController: UIScrollViewDelegate {
	
	private func endScrolling() {
		scrollIndicatorView1.fadeOut()
		scrollIndicatorView2.fadeOut()
		scrollIndicatorView3.fadeOut()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView){
		scrollIndicatorView1.scrollToOffsetOf(scrollView: scrollView)
		scrollIndicatorView2.scrollToOffsetOf(scrollView: scrollView)
		scrollIndicatorView3.scrollToOffsetOf(scrollView: scrollView)
		
		if scrollView.isTracking || scrollView.isDragging {
			scrollIndicatorView1.fadeIn()
			scrollIndicatorView2.fadeIn()
			scrollIndicatorView3.fadeIn()
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		endScrolling()
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		endScrolling()
	}
	
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		endScrolling()
	}
	
}
