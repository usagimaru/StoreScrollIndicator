# StoreScrollIndicator
A paging indicator like Apple Store app.

![](images/sample.gif)


Apple Store App:

![](images/applestore.gif)

# Summary

- iOS 9.3 and later
- Swift 3
- Xcode 8 (Sample Project)

# Usage

## 1. Copy ScrollIndicatorView.swift to your project

- `ScrollIndicatorView.swift`

## 2. Put ScrollIndicatorView

Put custom view on nib, then set Class as `ScrollIndicatorView`.

<img width=746 src="images/2.png" >

Also initializable from code.

## 3. Set properties

```
scrollIndicatorView.numberOfPages = 5
scrollIndicatorView.style = .marker   // Marker Style
scrollIndicatorView.style = .progress // Progress Style
scrollIndicatorView.indicatorColor = UIColor.orange // Indicator Color
```

## 4. Implement UIScrollViewDelegate

- To fade in effect
	- scrollViewDidScroll()
- To fade out effect
	- scrollViewDidEndDragging()
	- scrollViewDidEndDecelerating()
	- scrollViewDidEndScrollingAnimation()

```
func scrollViewDidScroll(_ scrollView: UIScrollView){
	scrollIndicatorView.scrollToOffsetOf(scrollView: scrollView)
	
	if scrollView.isTracking || scrollView.isDragging {
		scrollIndicatorView.fadeIn()
	}
}

func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
	scrollIndicatorView.fadeOut()
}

func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
	scrollIndicatorView.fadeOut()
}

func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
	scrollIndicatorView.fadeOut()
}
```

# License

See [LICENSE](LICENSE) (MIT) for details. 