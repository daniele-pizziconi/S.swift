/// Autogenerated file

// swiftlint:disable all
import UIKit

/// Entry point for the app stylesheet
public class SkypeStyle: TeamsStyle {

	public override class func shared() -> SkypeStyle {
		 struct __ { static let _sharedInstance = SkypeStyle() }
		return __._sharedInstance
	}
	//MARK: - SkypeStyleDuration
	override public func DurationStyle() -> TeamsStyle.DurationAppearanceProxy {
		if let override = _Duration { return override }
			return SkypeStyleDurationAppearanceProxy(proxy: { return SkypeStyle.shared() })
		}
	public class SkypeStyleDurationAppearanceProxy: TeamsStyle.DurationAppearanceProxy {

		//MARK: - SkypeStyleintervalDuration
		override public func intervalStyle() -> TeamsStyle.DurationAppearanceProxy.intervalAppearanceProxy {
			if let override = _interval { return override }
				return SkypeStyleintervalDurationAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStyleintervalDurationAppearanceProxy: TeamsStyle.DurationAppearanceProxy.intervalAppearanceProxy {

			//MARK: long 
			override public func longProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
				if let override = _long { return override }
					return CGFloat(1.0)
				}
		}

	}
	//MARK: - SkypeStyleButton
	override public func ButtonStyle() -> TeamsStyle.ButtonAppearanceProxy {
		if let override = _Button { return override }
			return SkypeStyleButtonAppearanceProxy(proxy: { return SkypeStyle.shared() })
		}
	public class SkypeStyleButtonAppearanceProxy: TeamsStyle.ButtonAppearanceProxy {

		//MARK: - SkypeStylecolorButton
		override public func colorStyle() -> TeamsStyle.ButtonAppearanceProxy.colorAppearanceProxy {
			if let override = _color { return override }
				return SkypeStylecolorButtonAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStylecolorButtonAppearanceProxy: TeamsStyle.ButtonAppearanceProxy.colorAppearanceProxy {

			//MARK: focus 
			override public func focusProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _focus { return override }
					return mainProxy().Color.brand.b06Property(traitCollection)
				}

			//MARK: hover 
			override public func hoverProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _hover { return override }
					return mainProxy().Color.brand.b06Property(traitCollection)
				}

			//MARK: active 
			override public func activeProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _active { return override }
					return mainProxy().Color.whiteProperty(traitCollection)
				}

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _normal { return override }
					return mainProxy().Color.brand.normalProperty(traitCollection)
				}

			//MARK: disabled 
			override public func disabledProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _disabled { return override }
					return mainProxy().Color.gray.g06Property(traitCollection)
				}

			//MARK: activeDisabled 
			override public func activeDisabledProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _activeDisabled { return override }
					return mainProxy().Color.whiteProperty(traitCollection)
				}
		}

	}
	//MARK: - SkypeStyleColor
	override public func ColorStyle() -> TeamsStyle.ColorAppearanceProxy {
		if let override = _Color { return override }
			return SkypeStyleColorAppearanceProxy(proxy: { return SkypeStyle.shared() })
		}
	public class SkypeStyleColorAppearanceProxy: TeamsStyle.ColorAppearanceProxy {

		//MARK: - SkypeStylebrandColor
		override public func brandStyle() -> TeamsStyle.ColorAppearanceProxy.brandAppearanceProxy {
			if let override = _brand { return override }
				return SkypeStylebrandColorAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStylebrandColorAppearanceProxy: TeamsStyle.ColorAppearanceProxy.brandAppearanceProxy {

			//MARK: b04 
			override public func b04Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b04 { return override }
					return UIColor(red: 0.0, green: 0.6039216, blue: 0.8901961, alpha: 1.0)
				}

			//MARK: b06 
			override public func b06Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b06 { return override }
					return UIColor(red: 0.0, green: 0.3764706, blue: 0.6666667, alpha: 1.0)
				}

			//MARK: b14 
			override public func b14Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b14 { return override }
					return UIColor(red: 0.8862745, green: 0.8862745, blue: 0.9647059, alpha: 1.0)
				}

			//MARK: b02 
			override public func b02Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b02 { return override }
					return UIColor(red: 0.0, green: 0.6039216, blue: 0.8901961, alpha: 1.0)
				}

			//MARK: b08 
			override public func b08Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b08 { return override }
					return UIColor(red: 0.54509807, green: 0.54901963, blue: 0.78039217, alpha: 1.0)
				}

			//MARK: b12 
			override public func b12Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b12 { return override }
					return UIColor(red: 0.7411765, green: 0.7411765, blue: 0.9019608, alpha: 1.0)
				}

			//MARK: b16 
			override public func b16Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b16 { return override }
					return UIColor(red: 0.95686275, green: 0.95686275, blue: 0.9882353, alpha: 1.0)
				}

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _normal { return override }
					return UIColor(red: 0.0, green: 0.47058824, blue: 0.83137256, alpha: 1.0)
				}
		}


		//MARK: - SkypeStylegreenColor
		override public func greenStyle() -> TeamsStyle.ColorAppearanceProxy.greenAppearanceProxy {
			if let override = _green { return override }
				return SkypeStylegreenColorAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStylegreenColorAppearanceProxy: TeamsStyle.ColorAppearanceProxy.greenAppearanceProxy {
		}


		//MARK: - SkypeStylegrayColor
		override public func grayStyle() -> TeamsStyle.ColorAppearanceProxy.grayAppearanceProxy {
			if let override = _gray { return override }
				return SkypeStylegrayColorAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStylegrayColorAppearanceProxy: TeamsStyle.ColorAppearanceProxy.grayAppearanceProxy {
		}


		//MARK: - SkypeStyleredColor
		override public func redStyle() -> TeamsStyle.ColorAppearanceProxy.redAppearanceProxy {
			if let override = _red { return override }
				return SkypeStyleredColorAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStyleredColorAppearanceProxy: TeamsStyle.ColorAppearanceProxy.redAppearanceProxy {
		}


		//MARK: - SkypeStyleblackColor
		override public func blackStyle() -> TeamsStyle.ColorAppearanceProxy.blackAppearanceProxy {
			if let override = _black { return override }
				return SkypeStyleblackColorAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStyleblackColorAppearanceProxy: TeamsStyle.ColorAppearanceProxy.blackAppearanceProxy {
		}

	}
	//MARK: - SkypeStyleTypography
	override public func TypographyStyle() -> TeamsStyle.TypographyAppearanceProxy {
		if let override = _Typography { return override }
			return SkypeStyleTypographyAppearanceProxy(proxy: { return SkypeStyle.shared() })
		}
	public class SkypeStyleTypographyAppearanceProxy: TeamsStyle.TypographyAppearanceProxy {

		//MARK: - SkypeStyletextStylesTypography
		override public func textStylesStyle() -> TeamsStyle.TypographyAppearanceProxy.textStylesAppearanceProxy {
			if let override = _textStyles { return override }
				return SkypeStyletextStylesTypographyAppearanceProxy(proxy: mainProxy)
			}
		public class SkypeStyletextStylesTypographyAppearanceProxy: TeamsStyle.TypographyAppearanceProxy.textStylesAppearanceProxy {
		}

	}
	//MARK: - SkypeStyleTimingFunctions
	override public func TimingFunctionsStyle() -> TeamsStyle.TimingFunctionsAppearanceProxy {
		if let override = _TimingFunctions { return override }
			return SkypeStyleTimingFunctionsAppearanceProxy(proxy: { return SkypeStyle.shared() })
		}
	public class SkypeStyleTimingFunctionsAppearanceProxy: TeamsStyle.TimingFunctionsAppearanceProxy {
	}
	//MARK: - Animator
	override public func AnimatorAnimator() -> TeamsStyle.AnimatorAnimatorProxy {
		if let override = _Animator { return override }
			return SkypeStyleAnimatorAnimatorProxy()
		}
	public class SkypeStyleAnimatorAnimatorProxy: TeamsStyle.AnimatorAnimatorProxy {

		//MARK: - SkypeStylerotate
		override public func rotateStyle() -> TeamsStyle.AnimatorAnimatorProxy.rotateAppearanceProxy {
			if let override = _rotate { return override }
				return SkypeStylerotateAppearanceProxy(proxy: { return SkypeStyle.shared() })
			}
		public class SkypeStylerotateAppearanceProxy: TeamsStyle.AnimatorAnimatorProxy.rotateAppearanceProxy {

		//MARK: curve 
		override public func curveProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationCurveType {
			if let override = _curve { return override }
			return mainProxy().TimingFunctions.easeInProperty(traitCollection)
			}

		//MARK: repeatCount 
		override public func repeatCountProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationRepeatCount {
			if let override = _repeatCount { return override }
			return AnimationRepeatCount.count(0)
			}

		//MARK: duration 
		override public func durationProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _duration { return override }
			return mainProxy().Duration.interval.longProperty(traitCollection)
			}

		//MARK: keyFrames 
		override public func keyFramesProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> [KeyFrame] {
			if let override = _keyFrames { return override }
			return [
			KeyFrame(relativeStartTime: 0.0, relativeDuration: nil, values: 
			[
			.rotate(from: 
			CGFloat(0.0), to: 
			CGFloat(360.0))])]
			}

		//MARK: delay 
		override public func delayProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _delay { return override }
			return CGFloat(0.0)
			}
		}
	

}
}