/// Autogenerated file

// swiftlint:disable all
import UIKit

/// Entry point for the app stylesheet
public class CallingTeamsStyle: CallingBaseStyle {

	public override class func shared() -> CallingTeamsStyle {
		 struct __ { static let _sharedInstance = CallingTeamsStyle() }
		return __._sharedInstance
	}
	//MARK: - Color
	public static let Color = ColorAppearanceProxy()
	open class ColorAppearanceProxy {
		public let mainProxy: () -> CallingBaseStyle
		public init(proxy: @escaping () -> CallingBaseStyle) {
			self.mainProxy = proxy
		}

		//MARK: white 
		public var _white: CGFloat?
		open func whiteProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _white { return override }
			return CGFloat(0.0)
			}
		public var white: CGFloat {
			get { return self.whiteProperty() }
			set { _white = newValue }
		}
	}
	//MARK: - CallingTeamsStyleButton
	override open func ButtonStyle() -> CallingBaseStyle.ButtonAppearanceProxy {
		if let override = _Button { return override }
			return CallingTeamsStyleButtonAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleButtonAppearanceProxy: CallingBaseStyle.ButtonAppearanceProxy {
	}
	//MARK: - CallingTeamsStyleEnums
	override open func EnumsStyle() -> CallingBaseStyle.EnumsAppearanceProxy {
		if let override = _Enums { return override }
			return CallingTeamsStyleEnumsAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleEnumsAppearanceProxy: CallingBaseStyle.EnumsAppearanceProxy {
	}
	//MARK: - CallingTeamsStyleOptions
	override open func OptionsStyle() -> CallingBaseStyle.OptionsAppearanceProxy {
		if let override = _Options { return override }
			return CallingTeamsStyleOptionsAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleOptionsAppearanceProxy: CallingBaseStyle.OptionsAppearanceProxy {
	}
	//MARK: - CallingTeamsStyleDuration
	override open func DurationStyle() -> CallingBaseStyle.DurationAppearanceProxy {
		if let override = _Duration { return override }
			return CallingTeamsStyleDurationAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleDurationAppearanceProxy: CallingBaseStyle.DurationAppearanceProxy {

		//MARK: - CallingTeamsStyleintervalDuration
		override open func intervalStyle() -> CallingBaseStyle.DurationAppearanceProxy.intervalAppearanceProxy {
			if let override = _interval { return override }
				return CallingTeamsStyleintervalDurationAppearanceProxy(proxy: mainProxy)
			}
		open class CallingTeamsStyleintervalDurationAppearanceProxy: CallingBaseStyle.DurationAppearanceProxy.intervalAppearanceProxy {
		}

	}
	//MARK: - CallingTeamsStyleTimingFunctions
	override open func TimingFunctionsStyle() -> CallingBaseStyle.TimingFunctionsAppearanceProxy {
		if let override = _TimingFunctions { return override }
			return CallingTeamsStyleTimingFunctionsAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleTimingFunctionsAppearanceProxy: CallingBaseStyle.TimingFunctionsAppearanceProxy {
	}
	//MARK: - CallingTeamsStyleColorButton
	override open func ColorButtonStyle() -> CallingBaseStyle.ColorButtonAppearanceProxy {
		if let override = _ColorButton { return override }
			return CallingTeamsStyleColorButtonAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleColorButtonAppearanceProxy: CallingBaseStyle.ColorButtonAppearanceProxy {
	}

}