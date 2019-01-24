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
		public var _white: UIColor?
		open func whiteProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _white { return override }
			return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
			}
		public var white: UIColor {
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

		//MARK: - CallingTeamsStyletextFontButton
		override open func textFontStyle() -> CallingBaseStyle.ButtonAppearanceProxy.textFontAppearanceProxy {
			if let override = _textFont { return override }
				return CallingTeamsStyletextFontButtonAppearanceProxy(proxy: mainProxy)
			}
		open class CallingTeamsStyletextFontButtonAppearanceProxy: CallingBaseStyle.ButtonAppearanceProxy.textFontAppearanceProxy {
		}

	}
	//MARK: - CallingTeamsStyleColorExtended
	override open func ColorExtendedStyle() -> CallingBaseStyle.ColorExtendedAppearanceProxy {
		if let override = _ColorExtended { return override }
			return CallingTeamsStyleColorExtendedAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleColorExtendedAppearanceProxy: CallingBaseStyle.ColorExtendedAppearanceProxy {

		//MARK: - CallingTeamsStyletextFontColorExtended
		override open func textFontStyle() -> CallingBaseStyle.ColorExtendedAppearanceProxy.textFontAppearanceProxy {
			if let override = _textFont { return override }
				return CallingTeamsStyletextFontColorExtendedAppearanceProxy(proxy: mainProxy)
			}
		open class CallingTeamsStyletextFontColorExtendedAppearanceProxy: CallingBaseStyle.ColorExtendedAppearanceProxy.textFontAppearanceProxy {
		}

	}
	//MARK: - CallingTeamsStyleTextView
	override open func TextViewStyle() -> CallingBaseStyle.TextViewAppearanceProxy {
		if let override = _TextView { return override }
			return CallingTeamsStyleTextViewAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleTextViewAppearanceProxy: CallingBaseStyle.TextViewAppearanceProxy {

		//MARK: - CallingTeamsStyletextFontTextView
		override open func textFontStyle() -> CallingBaseStyle.TextViewAppearanceProxy.textFontAppearanceProxy {
			if let override = _textFont { return override }
				return CallingTeamsStyletextFontTextViewAppearanceProxy(proxy: mainProxy)
			}
		open class CallingTeamsStyletextFontTextViewAppearanceProxy: CallingBaseStyle.TextViewAppearanceProxy.textFontAppearanceProxy {
		}

	}

}