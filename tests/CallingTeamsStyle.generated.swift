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
	//MARK: - CallingTeamsStyleCallDefaultButton
	override open func CallDefaultButtonStyle() -> CallingBaseStyle.CallDefaultButtonAppearanceProxy {
		if let override = _CallDefaultButton { return override }
			return CallingTeamsStyleCallDefaultButtonAppearanceProxy(proxy: { return CallingTeamsStyle.shared() })
		}
	open class CallingTeamsStyleCallDefaultButtonAppearanceProxy: CallingBaseStyle.CallDefaultButtonAppearanceProxy {

		//MARK: - CallingTeamsStylecolorCallDefaultButton
		override open func colorStyle() -> CallingBaseStyle.CallDefaultButtonAppearanceProxy.colorAppearanceProxy {
			if let override = _color { return override }
				return CallingTeamsStylecolorCallDefaultButtonAppearanceProxy(proxy: mainProxy)
			}
		open class CallingTeamsStylecolorCallDefaultButtonAppearanceProxy: CallingBaseStyle.CallDefaultButtonAppearanceProxy.colorAppearanceProxy {
		}

	}

}