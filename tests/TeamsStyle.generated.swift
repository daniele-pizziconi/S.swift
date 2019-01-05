/// Autogenerated file

// swiftlint:disable all
import UIKit

/// Entry point for the app stylesheet
public class TeamsStyle: BaseStyle {

	public override class func shared() -> TeamsStyle {
		 struct __ { static let _sharedInstance = TeamsStyle() }
		return __._sharedInstance
	}
	//MARK: - TeamsStyleButton
	override public func ButtonStyle() -> BaseStyle.ButtonAppearanceProxy {
		if let override = _Button { return override }
			return TeamsStyleButtonAppearanceProxy(proxy: { return TeamsStyle.shared() })
		}
	public class TeamsStyleButtonAppearanceProxy: BaseStyle.ButtonAppearanceProxy {

		//MARK: - TeamsStylecolorButton
		override public func colorStyle() -> BaseStyle.ButtonAppearanceProxy.colorAppearanceProxy {
			if let override = _color { return override }
				return TeamsStylecolorButtonAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStylecolorButtonAppearanceProxy: BaseStyle.ButtonAppearanceProxy.colorAppearanceProxy {

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _normal { return override }
					return mainProxy().Color.black.normalProperty(traitCollection)
				}

			//MARK: disabled 
			override public func disabledProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _disabled { return override }
					return mainProxy().Color.gray.g06Property(traitCollection)
				}

			//MARK: hover 
			override public func hoverProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _hover { return override }
					return mainProxy().Color.black.normalProperty(traitCollection)
				}

			//MARK: focus 
			override public func focusProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _focus { return override }
					return mainProxy().Color.black.normalProperty(traitCollection)
				}

			//MARK: active 
			override public func activeProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _active { return override }
					return mainProxy().Color.black.normalProperty(traitCollection)
				}

			//MARK: activeDisabled 
			override public func activeDisabledProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _activeDisabled { return override }
					return mainProxy().Color.black.normalProperty(traitCollection)
				}
		}

	}
	//MARK: - TeamsStyleDuration
	override public func DurationStyle() -> BaseStyle.DurationAppearanceProxy {
		if let override = _Duration { return override }
			return TeamsStyleDurationAppearanceProxy(proxy: { return TeamsStyle.shared() })
		}
	public class TeamsStyleDurationAppearanceProxy: BaseStyle.DurationAppearanceProxy {

		//MARK: - TeamsStyleintervalDuration
		override public func intervalStyle() -> BaseStyle.DurationAppearanceProxy.intervalAppearanceProxy {
			if let override = _interval { return override }
				return TeamsStyleintervalDurationAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStyleintervalDurationAppearanceProxy: BaseStyle.DurationAppearanceProxy.intervalAppearanceProxy {

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
				if let override = _normal { return override }
					return CGFloat(3.0)
				}

			//MARK: tiny 
			override public func tinyProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
				if let override = _tiny { return override }
					return CGFloat(1.5)
				}

			//MARK: debug 
			override public func debugProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
				if let override = _debug { return override }
					return CGFloat(10.0)
				}

			//MARK: short 
			override public func shortProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
				if let override = _short { return override }
					return CGFloat(2.34)
				}

			//MARK: long 
			override public func longProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
				if let override = _long { return override }
					return CGFloat(4.34)
				}
		}

	}
	//MARK: - TeamsStyleTimingFunctions
	override public func TimingFunctionsStyle() -> BaseStyle.TimingFunctionsAppearanceProxy {
		if let override = _TimingFunctions { return override }
			return TeamsStyleTimingFunctionsAppearanceProxy(proxy: { return TeamsStyle.shared() })
		}
	public class TeamsStyleTimingFunctionsAppearanceProxy: BaseStyle.TimingFunctionsAppearanceProxy {

		//MARK: easeIn 
		override public func easeInProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationCurveType {
			if let override = _easeIn { return override }
			return .timingParameters(UICubicTimingParameters(controlPoint1: CGPoint(x: 1.0, y: 0.0), controlPoint2: CGPoint(x: 0.78, y: 1.0)))
			}
	}
	//MARK: - TeamsStyleTypography
	override public func TypographyStyle() -> BaseStyle.TypographyAppearanceProxy {
		if let override = _Typography { return override }
			return TeamsStyleTypographyAppearanceProxy(proxy: { return TeamsStyle.shared() })
		}
	public class TeamsStyleTypographyAppearanceProxy: BaseStyle.TypographyAppearanceProxy {

		//MARK: - TeamsStyletextStylesTypography
		override public func textStylesStyle() -> BaseStyle.TypographyAppearanceProxy.textStylesAppearanceProxy {
			if let override = _textStyles { return override }
				return TeamsStyletextStylesTypographyAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStyletextStylesTypographyAppearanceProxy: BaseStyle.TypographyAppearanceProxy.textStylesAppearanceProxy {

			//MARK: title2 
			override public func title2Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIFont {
				if let override = _title2 { return override }
					return UIFont.scaledFont(name: "Menlo", textStyle: UIFont.TextStyle.body, traitCollection: traitCollection).with(traits: [UIFontDescriptor.SymbolicTraits.traitBold])
				}

			//MARK: title1 
			override public func title1Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIFont {
				if let override = _title1 { return override }
					return UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body, compatibleWith: traitCollection, scalable: true)
				}
		}

	}
	//MARK: - TeamsStyleColor
	override public func ColorStyle() -> BaseStyle.ColorAppearanceProxy {
		if let override = _Color { return override }
			return TeamsStyleColorAppearanceProxy(proxy: { return TeamsStyle.shared() })
		}
	public class TeamsStyleColorAppearanceProxy: BaseStyle.ColorAppearanceProxy {

		//MARK: - TeamsStylebrandColor
		override public func brandStyle() -> BaseStyle.ColorAppearanceProxy.brandAppearanceProxy {
			if let override = _brand { return override }
				return TeamsStylebrandColorAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStylebrandColorAppearanceProxy: BaseStyle.ColorAppearanceProxy.brandAppearanceProxy {

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _normal { return override }
					return UIColor(red: 0.38431373, green: 0.39215687, blue: 0.654902, alpha: 1.0)
				}

			//MARK: b14 
			override public func b14Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b14 { return override }
					return UIColor(red: 0.8862745, green: 0.8862745, blue: 0.9647059, alpha: 1.0)
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

			//MARK: b04 
			override public func b04Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b04 { return override }
					return UIColor(red: 0.27450982, green: 0.2784314, blue: 0.45882353, alpha: 1.0)
				}

			//MARK: b02 
			override public func b02Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b02 { return override }
					return UIColor(red: 0.2, green: 0.20392157, blue: 0.2901961, alpha: 1.0)
				}

			//MARK: b16 
			override public func b16Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b16 { return override }
					return UIColor(red: 0.95686275, green: 0.95686275, blue: 0.9882353, alpha: 1.0)
				}

			//MARK: b06 
			override public func b06Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b06 { return override }
					return UIColor(red: 0.38431373, green: 0.39215687, blue: 0.654902, alpha: 1.0)
				}
		}


		//MARK: - TeamsStyleredColor
		override public func redStyle() -> BaseStyle.ColorAppearanceProxy.redAppearanceProxy {
			if let override = _red { return override }
				return TeamsStyleredColorAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStyleredColorAppearanceProxy: BaseStyle.ColorAppearanceProxy.redAppearanceProxy {

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _normal { return override }
					return UIColor(red: 0.76862746, green: 0.19215687, blue: 0.29411766, alpha: 1.0)
				}

			//MARK: r08 
			override public func r08Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _r08 { return override }
					return UIColor(red: 0.9529412, green: 0.8392157, blue: 0.85882354, alpha: 1.0)
				}
		}


		//MARK: transparent 
		override public func transparentProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _transparent { return override }
			return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
			}

		//MARK: magenta 
		override public func magentaProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _magenta { return override }
			return UIColor(red: 0.69803923, green: 0.2784314, blue: 0.50980395, alpha: 1.0)
			}

		//MARK: - TeamsStylegrayColor
		override public func grayStyle() -> BaseStyle.ColorAppearanceProxy.grayAppearanceProxy {
			if let override = _gray { return override }
				return TeamsStylegrayColorAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStylegrayColorAppearanceProxy: BaseStyle.ColorAppearanceProxy.grayAppearanceProxy {

			//MARK: g06 
			override public func g06Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g06 { return override }
					return UIColor(red: 0.78431374, green: 0.7764706, blue: 0.76862746, alpha: 1.0)
				}

			//MARK: g02 
			override public func g02Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g02 { return override }
					return UIColor(red: 0.28235295, green: 0.27450982, blue: 0.26666668, alpha: 1.0)
				}

			//MARK: g14 
			override public func g14Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g14 { return override }
					return UIColor(red: 0.98039216, green: 0.9764706, blue: 0.972549, alpha: 1.0)
				}

			//MARK: g03 
			override public func g03Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g03 { return override }
					return UIColor(red: 0.3764706, green: 0.36862746, blue: 0.36078432, alpha: 1.0)
				}

			//MARK: g08 
			override public func g08Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g08 { return override }
					return UIColor(red: 0.88235295, green: 0.8745098, blue: 0.8666667, alpha: 1.0)
				}

			//MARK: g04 
			override public func g04Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g04 { return override }
					return UIColor(red: 0.5921569, green: 0.58431375, blue: 0.5764706, alpha: 1.0)
				}

			//MARK: g09 
			override public func g09Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g09 { return override }
					return UIColor(red: 0.92941177, green: 0.92156863, blue: 0.9137255, alpha: 1.0)
				}

			//MARK: g10 
			override public func g10Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g10 { return override }
					return UIColor(red: 0.9529412, green: 0.9490196, blue: 0.94509804, alpha: 1.0)
				}
		}


		//MARK: white 
		override public func whiteProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _white { return override }
			return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
			}

		//MARK: yellow 
		override public func yellowProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _yellow { return override }
			return UIColor(red: 0.972549, green: 0.8235294, blue: 0.16470589, alpha: 1.0)
			}

		//MARK: orchid 
		override public func orchidProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _orchid { return override }
			return UIColor(red: 0.5803922, green: 0.21176471, blue: 0.4392157, alpha: 1.0)
			}

		//MARK: orange04 
		override public func orange04Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _orange04 { return override }
			return UIColor(red: 0.8, green: 0.2901961, blue: 0.19215687, alpha: 1.0)
			}

		//MARK: - TeamsStylegreenColor
		override public func greenStyle() -> BaseStyle.ColorAppearanceProxy.greenAppearanceProxy {
			if let override = _green { return override }
				return TeamsStylegreenColorAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStylegreenColorAppearanceProxy: BaseStyle.ColorAppearanceProxy.greenAppearanceProxy {

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _normal { return override }
					return UIColor(red: 0.57254905, green: 0.7647059, blue: 0.3254902, alpha: 1.0)
				}

			//MARK: g04 
			override public func g04Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _g04 { return override }
					return UIColor(red: 0.13725491, green: 0.48235294, blue: 0.29411766, alpha: 1.0)
				}
		}


		//MARK: - TeamsStyleblackColor
		override public func blackStyle() -> BaseStyle.ColorAppearanceProxy.blackAppearanceProxy {
			if let override = _black { return override }
				return TeamsStyleblackColorAppearanceProxy(proxy: mainProxy)
			}
		public class TeamsStyleblackColorAppearanceProxy: BaseStyle.ColorAppearanceProxy.blackAppearanceProxy {

			//MARK: normal 
			override public func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _normal { return override }
					return UIColor(red: 0.14509805, green: 0.14117648, blue: 0.13725491, alpha: 1.0)
				}

			//MARK: overlayMid 
			override public func overlayMidProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _overlayMid { return override }
					return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3137255)
				}

			//MARK: border 
			override public func borderProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _border { return override }
					return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1254902)
				}

			//MARK: overlay 
			override public func overlayProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _overlay { return override }
					return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4392157)
				}

			//MARK: overlayLight 
			override public func overlayLightProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _overlayLight { return override }
					return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1882353)
				}
		}

	}
	//MARK: - Animator
	override public func AnimatorAnimator() -> BaseStyle.AnimatorAnimatorProxy {
		if let override = _Animator { return override }
			return TeamsStyleAnimatorAnimatorProxy()
		}
	public class TeamsStyleAnimatorAnimatorProxy: BaseStyle.AnimatorAnimatorProxy {

		//MARK: - TeamsStylerotate
		override public func rotateStyle() -> BaseStyle.AnimatorAnimatorProxy.rotateAppearanceProxy {
			if let override = _rotate { return override }
				return TeamsStylerotateAppearanceProxy(proxy: { return TeamsStyle.shared() })
			}
		public class TeamsStylerotateAppearanceProxy: BaseStyle.AnimatorAnimatorProxy.rotateAppearanceProxy {

		//MARK: repeatCount 
		override public func repeatCountProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationRepeatCount {
			if let override = _repeatCount { return override }
			return AnimationRepeatCount.count(0)
			}

		//MARK: delay 
		override public func delayProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _delay { return override }
			return CGFloat(0.0)
			}

		//MARK: duration 
		override public func durationProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _duration { return override }
			return mainProxy().Duration.interval.longProperty(traitCollection)
			}

		//MARK: curve 
		override public func curveProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationCurveType {
			if let override = _curve { return override }
			return mainProxy().TimingFunctions.easeInProperty(traitCollection)
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
		}
	

}
}