/// Autogenerated file

// swiftlint:disable all
import UIKit

public enum Theme: Int {
	case callingBase
	case callingTeams

	public var stylesheet: CallingBaseStyle {
		switch self {
		case .callingBase: return CallingBaseStyle.shared()
		case .callingTeams: return CallingTeamsStyle.shared()
		}
	}
}

public class StylesheetManager {
	@objc dynamic public class func stylesheet(_ stylesheet: CallingBaseStyle) -> CallingBaseStyle {
		return StylesheetManager.default.theme.stylesheet
	}

	public static let `default` = StylesheetManager()
	public static var S: CallingBaseStyle {
		return StylesheetManager.default.theme.stylesheet
	}

	public var theme: Theme {
		switch CallingStylesheetManager.default.theme {
		case .base: return .callingBase
		case .teams: return .callingTeams
		}
	}

}

public class Application {
	@objc dynamic public class func preferredContentSizeCategory() -> UIContentSizeCategory {
		return .large
	}
}

fileprivate var __ApperanceProxyHandle: UInt8 = 0
fileprivate var __ThemeAwareHandle: UInt8 = 0
fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0

/// Your view should conform to 'AppearaceProxyComponent'.
public protocol AppearaceProxyComponent: class {
	associatedtype ApperanceProxyType
	var appearanceProxy: ApperanceProxyType { get }
	var themeAware: Bool { get set }
	func didChangeAppearanceProxy()
}

public extension AppearaceProxyComponent {
	public func initAppearanceProxy(themeAware: Bool = true) {
		self.themeAware = themeAware
		didChangeAppearanceProxy()
	}
}

#if os(iOS)
private let defaultSizes: [UIFont.TextStyle: CGFloat] = {
	var sizes: [UIFont.TextStyle: CGFloat] = [.caption2: 11,
	.caption1: 12,
	.footnote: 13,
	.subheadline: 15,
	.callout: 16,
	.body: 17,
	.headline: 17,
	.title3: 20,
	.title2: 22,
	.title1: 28]
	if #available(iOS 11.0, *) {
		sizes[.largeTitle] = 34
	}
	return sizes
}()
#elseif os(tvOS)
private let defaultSizes: [UIFont.TextStyle: CGFloat] =
	[.caption2: 23,
		.caption1: 25,
		.footnote: 29,
		.subheadline: 29,
		.body: 29,
		.callout: 31,
		.headline: 38,
		.title3: 48,
		.title2: 57,
		.title1: 76]
#elseif os(watchOS)
private let defaultSizes: [UIFont.TextStyle: CGFloat] = {
	if #available(watchOS 5.0, *) {
		switch WKInterfaceDevice.current().preferredContentSizeCategory {
		case "UICTContentSizeCategoryS":
			return [.footnote: 12,
				.caption2: 13,
				.caption1: 14,
				.body: 15,
				.headline: 15,
				.title3: 18,
				.title2: 26,
				.title1: 30,
				.largeTitle: 32]
		case "UICTContentSizeCategoryL":
			return [.footnote: 13,
				.caption2: 14,
				.caption1: 15,
				.body: 16,
				.headline: 16,
				.title3: 19,
				.title2: 27,
				.title1: 34,
				.largeTitle: 36]
		case "UICTContentSizeCategoryXL":
			return [.footnote: 14,
				.caption2: 15,
				.caption1: 16,
				.body: 17,
				.headline: 17,
				.title3: 20,
				.title2: 30,
				.title1: 38,
				.largeTitle: 40]
		default:
			return [:]
		}
	} else {
		/// No `largeTitle` before watchOS 5
		switch WKInterfaceDevice.current().preferredContentSizeCategory {
		case "UICTContentSizeCategoryS":
			return [.footnote: 12,
					.caption2: 13,
					.caption1: 14,
					.body: 15,
					.headline: 15,
					.title3: 18,
					.title2: 26,
					.title1: 30]
		case "UICTContentSizeCategoryL":
			return [.footnote: 13,
					.caption2: 14,
					.caption1: 15,
					.body: 16,
					.headline: 16,
					.title3: 19,
					.title2: 27,
					.title1: 34]
		default:
			return [:]
		}
	}
}()
#endif

fileprivate var __ScalableHandle: UInt8 = 0
public extension UIFont {
	static func scaledFont(name: String, textStyle: UIFont.TextStyle, traitCollection: UITraitCollection? = nil) -> UIFont {
		if #available(iOS 11.0, *) {
			guard let defaultSize = defaultSizes[textStyle], let customFont = UIFont(name: name, size: defaultSize) else {
				fatalError("Failed to load the \(name) font.")
			}
			return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont, compatibleWith: traitCollection)
		} else {
			let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle, compatibleWith: traitCollection)
			guard let customFont = UIFont(name: name, size: fontDescriptor.pointSize) else {
				fatalError("Failed to load the \(name) font.")
			}
			return customFont
		}
	}

	public func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
		let descriptor = fontDescriptor.withSymbolicTraits(traits)
		return UIFont(descriptor: descriptor!, size: 0)
	}

	public class func preferredFont(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?, scalable: Bool) -> UIFont {
		let font = UIFont.preferredFont(forTextStyle: style, compatibleWith: traitCollection)
		font.isScalable = true
		return font
	}

	public convenience init?(name: String, scalable: Bool) {
		self.init(name: name, size: 4)
		self.isScalable = scalable
	}

	public var isScalable: Bool {
		get { return objc_getAssociatedObject(self, &__ScalableHandle) as? Bool ?? false }
		set { objc_setAssociatedObject(self, &__ScalableHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}

}

/// Entry point for the app stylesheet
public class CallingBaseStyle: NSObject {

	public class func shared() -> CallingBaseStyle {
		 struct __ { static let _sharedInstance = CallingBaseStyle() }
		return __._sharedInstance
	}
	//MARK: - ColorAncoraNuovo
	public var _ColorAncoraNuovo: ColorAncoraNuovoAppearanceProxy?
	open func ColorAncoraNuovoStyle() -> ColorAncoraNuovoAppearanceProxy {
		if let override = _ColorAncoraNuovo { return override }
			return ColorAncoraNuovoAppearanceProxy(proxy: { return CallingBaseStyle.shared() })
		}
	public var ColorAncoraNuovo: ColorAncoraNuovoAppearanceProxy {
		get { return self.ColorAncoraNuovoStyle() }
		set { _ColorAncoraNuovo = newValue }
	}
	open class ColorAncoraNuovoAppearanceProxy: ButtonAppearanceProxy {

		//MARK: - ColorAncoraNuovotextColor
		override open func textColorStyle() -> ButtonAppearanceProxy.textColorAppearanceProxy {
			if let override = _textColor { return override }
				return ColorAncoraNuovotextColorAppearanceProxy(proxy: mainProxy)
			}
		open class ColorAncoraNuovotextColorAppearanceProxy: ButtonAppearanceProxy.textColorAppearanceProxy {

			//MARK: normal 
			override open func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIFont {
				if let override = _normal { return override }
					return CallingStylesheetManager.S.Typography.textStyles.callout
				}
		}

	}
	//MARK: - Button
	public var _Button: ButtonAppearanceProxy?
	open func ButtonStyle() -> ButtonAppearanceProxy {
		if let override = _Button { return override }
			return ButtonAppearanceProxy(proxy: { return CallingBaseStyle.shared() })
		}
	public var Button: ButtonAppearanceProxy {
		get { return self.ButtonStyle() }
		set { _Button = newValue }
	}
	open class ButtonAppearanceProxy {
		public let mainProxy: () -> CallingBaseStyle
		public init(proxy: @escaping () -> CallingBaseStyle) {
			self.mainProxy = proxy
		}

		//MARK: - textColor
		public var _textColor: textColorAppearanceProxy?
		open func textColorStyle() -> textColorAppearanceProxy {
			if let override = _textColor { return override }
				return textColorAppearanceProxy(proxy: mainProxy)
			}
		public var textColor: textColorAppearanceProxy {
			get { return self.textColorStyle() }
			set { _textColor = newValue }
		}
		open class textColorAppearanceProxy {
			public let mainProxy: () -> CallingBaseStyle
			public init(proxy: @escaping () -> CallingBaseStyle) {
				self.mainProxy = proxy
			}

			//MARK: normal 
			public var _normal: UIFont?
			open func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIFont {
				if let override = _normal { return override }
					return CallingStylesheetManager.S.Typography.textStyles.callout
				}
			public var normal: UIFont {
				get { return self.normalProperty() }
				set { _normal = newValue }
			}
		}


		//MARK: mask 
		public var _mask: UIView.AutoresizingMask?
		open func maskProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIView.AutoresizingMask {
			if let override = _mask { return override }
			return [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin]
			}
		public var mask: UIView.AutoresizingMask {
			get { return self.maskProperty() }
			set { _mask = newValue }
		}
	}
	//MARK: - ColorExtended
	public var _ColorExtended: ColorExtendedAppearanceProxy?
	open func ColorExtendedStyle() -> ColorExtendedAppearanceProxy {
		if let override = _ColorExtended { return override }
			return ColorExtendedAppearanceProxy(proxy: { return CallingBaseStyle.shared() })
		}
	public var ColorExtended: ColorExtendedAppearanceProxy {
		get { return self.ColorExtendedStyle() }
		set { _ColorExtended = newValue }
	}
	open class ColorExtendedAppearanceProxy: ButtonAppearanceProxy {

		//MARK: - ColorExtendedtextColor
		override open func textColorStyle() -> ButtonAppearanceProxy.textColorAppearanceProxy {
			if let override = _textColor { return override }
				return ColorExtendedtextColorAppearanceProxy(proxy: mainProxy)
			}
		open class ColorExtendedtextColorAppearanceProxy: ButtonAppearanceProxy.textColorAppearanceProxy {

			//MARK: normal 
			override open func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIFont {
				if let override = _normal { return override }
					return CallingStylesheetManager.S.Typography.textStyles.callout
				}
		}

	}
	//MARK: - ColorNuovo
	public var _ColorNuovo: ColorNuovoAppearanceProxy?
	open func ColorNuovoStyle() -> ColorNuovoAppearanceProxy {
		if let override = _ColorNuovo { return override }
			return ColorNuovoAppearanceProxy(proxy: { return CallingBaseStyle.shared() })
		}
	public var ColorNuovo: ColorNuovoAppearanceProxy {
		get { return self.ColorNuovoStyle() }
		set { _ColorNuovo = newValue }
	}
	open class ColorNuovoAppearanceProxy: ButtonAppearanceProxy {

		//MARK: - ColorNuovotextColor
		override open func textColorStyle() -> ButtonAppearanceProxy.textColorAppearanceProxy {
			if let override = _textColor { return override }
				return ColorNuovotextColorAppearanceProxy(proxy: mainProxy)
			}
		open class ColorNuovotextColorAppearanceProxy: ButtonAppearanceProxy.textColorAppearanceProxy {

			//MARK: normal 
			override open func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIFont {
				if let override = _normal { return override }
					return CallingStylesheetManager.S.Typography.textStyles.callout
				}
		}

	}

}
extension Button: AppearaceProxyComponent {

	public typealias ApperanceProxyType = CallingBaseStyle.ButtonAppearanceProxy
	public var appearanceProxy: ApperanceProxyType {
		get {
			if let proxy = objc_getAssociatedObject(self, &__ApperanceProxyHandle) as? ApperanceProxyType {
				if !themeAware { return proxy }

				if proxy is CallingBaseStyle.ColorAncoraNuovoAppearanceProxy {
					return StylesheetManager.stylesheet(CallingBaseStyle.shared()).ColorAncoraNuovo
				} else if proxy is CallingBaseStyle.ColorExtendedAppearanceProxy {
					return StylesheetManager.stylesheet(CallingBaseStyle.shared()).ColorExtended
				} else if proxy is CallingBaseStyle.ColorNuovoAppearanceProxy {
					return StylesheetManager.stylesheet(CallingBaseStyle.shared()).ColorNuovo
				}
				return proxy
			}

			return StylesheetManager.stylesheet(CallingBaseStyle.shared()).Button
		}
		set {
			objc_setAssociatedObject(self, &__ApperanceProxyHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			didChangeAppearanceProxy()
		}
	}

	public var themeAware: Bool {
		get {
			guard let proxy = objc_getAssociatedObject(self, &__ThemeAwareHandle) as? Bool else { return true }
			return proxy
		}
		set {
			objc_setAssociatedObject(self, &__ThemeAwareHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			isObservingDidChangeTheme = newValue
		}
	}

	fileprivate var isObservingDidChangeTheme: Bool {
		get {
			guard let observing = objc_getAssociatedObject(self, &__ObservingDidChangeThemeHandle) as? Bool else { return false }
			return observing
		}
		set {
			if newValue == isObservingDidChangeTheme { return }
			if newValue {
				NotificationCenter.default.addObserver(self, selector: #selector(didChangeAppearanceProxy), name: Notification.Name.didChangeTheme, object: nil)
			} else {
				NotificationCenter.default.removeObserver(self, name: Notification.Name.didChangeTheme, object: nil)
			}
			objc_setAssociatedObject(self, &__ObservingDidChangeThemeHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
