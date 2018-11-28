/// Autogenerated file

// swiftlint:disable all
import UIKit

/// Entry point for the app stylesheet
public class SkypeStyle: TeamsStyle {

	override class func shared() -> SkypeStyle {
		 struct __ { static let _sharedInstance = SkypeStyle() }
		return __._sharedInstance
	}
	//MARK: - SkypeStyleColor
	override public func ColorStyle() -> TeamsStyle.ColorAppearanceProxy {
		if let override = _Color { return override }
			return SkypeStyleColorAppearanceProxy()
		}
	public class SkypeStyleColorAppearanceProxy: TeamsStyle.ColorAppearanceProxy {

		//MARK: - gray
		public let gray = grayAppearanceProxy()
		public class grayAppearanceProxy {

			//MARK: b1 
			fileprivate var _b1: UIColor?
			public func b1Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _b1 { return override }
					return UIColor(red: 0.14509805, green: 0.14117648, blue: 0.13725491, alpha: 1.0)
				}
			public var b1: UIColor {
				get { return self.b1Property() }
				set { _b1 = newValue }
			}
		}

	}
	//MARK: - SkypeStylePrimaryButton
	override public func PrimaryButtonStyle() -> TeamsStyle.PrimaryButtonAppearanceProxy {
		if let override = _PrimaryButton { return override }
			return SkypeStylePrimaryButtonAppearanceProxy()
		}
	public class SkypeStylePrimaryButtonAppearanceProxy: TeamsStyle.PrimaryButtonAppearanceProxy {

		//MARK: - SkypeStylecolorPrimaryButton
		override public func colorStyle() -> TeamsStyle.PrimaryButtonAppearanceProxy.colorAppearanceProxy {
			if let override = _color { return override }
				return SkypeStylecolorPrimaryButtonAppearanceProxy()
			}
		public class SkypeStylecolorPrimaryButtonAppearanceProxy: TeamsStyle.PrimaryButtonAppearanceProxy.colorAppearanceProxy {

			//MARK: c1 
			override public func c1Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _c1 { return override }
					return StylesheetManager.stylesheet(SkypeStyle.shared()).Color.black.b1Property(traitCollection)
				}
		}

	}
	//MARK: - SkypeStyleButton
	override public func ButtonStyle() -> TeamsStyle.ButtonAppearanceProxy {
		if let override = _Button { return override }
			return SkypeStyleButtonAppearanceProxy()
		}
	public class SkypeStyleButtonAppearanceProxy: TeamsStyle.ButtonAppearanceProxy {

		//MARK: - SkypeStylecolorButton
		override public func colorStyle() -> TeamsStyle.ButtonAppearanceProxy.colorAppearanceProxy {
			if let override = _color { return override }
				return SkypeStylecolorButtonAppearanceProxy()
			}
		public class SkypeStylecolorButtonAppearanceProxy: TeamsStyle.ButtonAppearanceProxy.colorAppearanceProxy {

			//MARK: c1 
			override public func c1Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _c1 { return override }
					return StylesheetManager.stylesheet(SkypeStyle.shared()).Color.black.b1Property(traitCollection)
				}
		}


		//MARK: - SkypeStyleborderColorButton
		override public func borderColorStyle() -> TeamsStyle.ButtonAppearanceProxy.borderColorAppearanceProxy {
			if let override = _borderColor { return override }
				return SkypeStyleborderColorButtonAppearanceProxy()
			}
		public class SkypeStyleborderColorButtonAppearanceProxy: TeamsStyle.ButtonAppearanceProxy.borderColorAppearanceProxy {

			//MARK: c1 
			override public func c1Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _c1 { return override }
					return StylesheetManager.stylesheet(SkypeStyle.shared()).Color.black.b1Property(traitCollection)
				}
		}

	}
	//MARK: - SkypeStyleCircularButton
	override public func CircularButtonStyle() -> TeamsStyle.CircularButtonAppearanceProxy {
		if let override = _CircularButton { return override }
			return SkypeStyleCircularButtonAppearanceProxy()
		}
	public class SkypeStyleCircularButtonAppearanceProxy: TeamsStyle.CircularButtonAppearanceProxy {

		//MARK: - SkypeStylecolorCircularButton
		override public func colorStyle() -> TeamsStyle.CircularButtonAppearanceProxy.colorAppearanceProxy {
			if let override = _color { return override }
				return SkypeStylecolorCircularButtonAppearanceProxy()
			}
		public class SkypeStylecolorCircularButtonAppearanceProxy: TeamsStyle.CircularButtonAppearanceProxy.colorAppearanceProxy {

			//MARK: c1 
			override public func c1Property(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
				if let override = _c1 { return override }
					return StylesheetManager.stylesheet(SkypeStyle.shared()).Color.black.b1Property(traitCollection)
				}
		}

	}

}