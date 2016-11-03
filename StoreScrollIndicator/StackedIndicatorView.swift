//
//  StackedIndicatorView.swift
//
//  Created by Satori Maru on 16.11.03.
//  Copyright © 2016年 usagimaru. All rights reserved.
//

import UIKit

protocol StackedIndicatorViewDelegate: AnyObject {
	
	func stackedIndicator(view: StackedIndicatorView, didComplete indicator: ScrollIndicatorView, at index: Int)
	func stackedIndicator(view: StackedIndicatorView, shouldStartNext indicator: ScrollIndicatorView, at index: Int) -> Bool
	func stackedIndicatorViewDidCompleteAll(sender: StackedIndicatorView)
	
}

class StackedIndicatorView: UIView {
	
	private var stackView = UIStackView()
	fileprivate(set) var indicators = [ScrollIndicatorView]()
	
	var spacing: CGFloat {
		get {
			return stackView.spacing
		}
		set {
			stackView.spacing = newValue
		}
	}
	
	var numberOfIndicators: UInt = 1 {
		didSet {
			setIndicators()
		}
	}
	
	var resetTimerWhenCompleted: Bool = false
	
	weak var delegate: StackedIndicatorViewDelegate?
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		_init()
	}
	
	private func _init() {
		addSubview(stackView)
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
		                                              options: NSLayoutFormatOptions(rawValue: 0),
		                                              metrics: nil,
		                                              views: ["view" : stackView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
		                                              options: NSLayoutFormatOptions(rawValue: 0),
		                                              metrics: nil,
		                                              views: ["view" : stackView]))
		
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
		spacing = 2
	}
	
	private func setIndicators() {
		for indicator in indicators {
			stackView.removeArrangedSubview(indicator)
			indicator.stopTimer()
		}
		indicators.removeAll()
		
		for _ in 0..<numberOfIndicators {
			let indicator = ScrollIndicatorView()
			indicator.style = .autoProgress
			indicator.delegate = self
			indicator.timerDuration = 2.0
			indicator.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
			stackView.addArrangedSubview(indicator)
			indicators.append(indicator)
		}
	}
	
	func setTimerDuration(duration: CGFloat) {
		for indicator in indicators {
			indicator.timerDuration = duration
		}
	}
	
	func start() {
		if let firstIndicator = indicators.first {
			if delegate?.stackedIndicator(view: self, shouldStartNext: firstIndicator, at: 0) ?? true {
				firstIndicator.startTimer()
			}
		}
	}
	
	func reset() {
		for indicator in indicators {
			indicator.reset()
		}
	}

}

extension StackedIndicatorView: ScrollIndicatorViewDelegate {
	
	func scrollIndicatorViewDidComplete(sender: ScrollIndicatorView){
		if !indicators.contains(sender) {
			return
		}
		
		if let index = indicators.index(of: sender) {
			if index < indicators.count - 1 {
				delegate?.stackedIndicator(view: self, didComplete: indicators[index], at: index)
				
				let next = index + 1
				let nextIndicator = indicators[next]
				if delegate?.stackedIndicator(view: self, shouldStartNext: nextIndicator, at: next) ?? true {
					nextIndicator.startTimer()
				}
			}
			else if index == indicators.count - 1 {
				let indicator = indicators[index]
				delegate?.stackedIndicator(view: self, didComplete: indicator, at: index)
				
				if resetTimerWhenCompleted {
					reset()
				}
				
				delegate?.stackedIndicatorViewDidCompleteAll(sender: self)
			}
		}
	}
	
}

