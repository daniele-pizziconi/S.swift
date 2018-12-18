/// Autogenerated file

// swiftlint:disable all
import UIKit

fileprivate extension UserDefaults {
	subscript<T>(key: String) -> T? {
		get { return value(forKey: key) as? T }
		set { set(newValue, forKey: key) }
	}

	subscript<T: RawRepresentable>(key: String) -> T? {
		get {
			if let rawValue = value(forKey: key) as? T.RawValue {
				return T(rawValue: rawValue)
			}
			return nil
		}
		set { self[key] = newValue?.rawValue }
	}
}

public enum Theme: Int {
	case teams
	case skype

	public var stylesheet: TeamsStyle {
		switch self {
		case .teams: return TeamsStyle.shared()
		case .skype: return SkypeStyle.shared()
		}
	}
}

public extension Notification.Name {
	static let didChangeTheme = Notification.Name("stylesheet.theme")
}

public class StylesheetManager {
	@objc dynamic public class func stylesheet(_ stylesheet: TeamsStyle) -> TeamsStyle {
		return StylesheetManager.default.theme.stylesheet
	}

	private struct DefaultKeys {
		static let theme = "theme"
	}

	public static let `default` = StylesheetManager()
	public static var S: TeamsStyle {
		return StylesheetManager.default.theme.stylesheet
	}

	public var theme: Theme {
		didSet {
			NotificationCenter.default.post(name: .didChangeTheme, object: theme)
			UserDefaults.standard[DefaultKeys.theme] = theme
		}
	}

	public init() {
		self.theme = UserDefaults.standard[DefaultKeys.theme] ?? .teams
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

fileprivate var __AnimatorProxyHandle: UInt8 = 0
fileprivate var __AnimatorRepeatCountHandle: UInt8 = 0
fileprivate var __AnimatorIdentifierHandle: UInt8 = 0

/// Your view should conform to 'AnimatorProxyComponent'.
public protocol AnimatorProxyComponent: class {
	associatedtype AnimatorProxyType
	var animator: AnimatorProxyType { get }

}


public struct KeyFrame {
	var relativeStartTime: CGFloat
	var relativeDuration: CGFloat?
	var values: [AnimatableProp]
}

public enum AnimationState {
	case start
	case pause
	case stop
}

public struct AnimationConfigOptions {
	let repeatCount: AnimationRepeatCount?
	let delay: CGFloat?
	let duration: TimeInterval?

	public init(duration: TimeInterval? = nil, delay: CGFloat? = nil, repeatCount: AnimationRepeatCount? = nil) {
		self.duration = duration
		self.delay = delay
		self.repeatCount = repeatCount
	}
}

public enum AnimationRepeatCount {
	case infinite
	case count(Int)
}

public enum AnimationCurveType {
	case native(UIView.AnimationCurve)
	case timingParameters(UITimingCurveProvider)
}

public enum AnimationType {
	case basic
}

public enum AnimatableProp: Equatable {
	case opacity(from: CGFloat?, to: CGFloat)
	case frame(from: CGRect?, to: CGRect)
	case size(from: CGSize?, to: CGSize)
	case width(from: CGFloat?, to: CGFloat)
	case height(from: CGFloat?, to: CGFloat)
	case left(from: CGFloat?, to: CGFloat)
	case rotate(from: CGFloat?, to: CGFloat)
}


public extension AnimatableProp {
	func applyFrom(to view: UIView) {
		switch self {
		case .opacity(let from, _):	if let from = from { view.alpha = from }
		case .frame(let from, _):	if let from = from { view.frame = from }
		case .size(let from, _):	if let from = from { view.bounds.size = from }
		case .width(let from, _):	if let from = from { view.bounds.size.width = from }
		case .height(let from, _):	if let from = from { view.bounds.size.height = from }
		case .left(let from, _):	if let from = from { view.frame.origin.x = from }
		case .rotate(let from, _):	if let from = from { view.transform = view.transform.rotated(by: (from * .pi / 180.0)) }
		}
	}

	func applyTo(to view: UIView) {
		switch self {
		case .opacity(_, let to):	view.alpha = to
		case .frame(_, let to):		view.frame = to
		case .size(_, let to):		view.bounds.size = to
		case .width(_, let to):		view.bounds.size.width = to
		case .height(_, let to):	view.bounds.size.height = to
		case .left(_, let to):		view.frame.origin.x = to
		case .rotate(_, let to):	view.transform = view.transform.rotated(by: (to * .pi / 180.0))
		}
	}

}

/// Entry point for the app stylesheet
public class TeamsStyle: NSObject {

	public class func shared() -> TeamsStyle {
		 struct __ { static let _sharedInstance = TeamsStyle() }
		return __._sharedInstance
	}
	//MARK: - TimingFunctions
	public var _TimingFunctions: TimingFunctionsAppearanceProxy?
	open func TimingFunctionsStyle() -> TimingFunctionsAppearanceProxy {
		if let override = _TimingFunctions { return override }
			return TimingFunctionsAppearanceProxy()
		}
	public var TimingFunctions: TimingFunctionsAppearanceProxy {
		get { return self.TimingFunctionsStyle() }
		set { _TimingFunctions = newValue }
	}
	public class TimingFunctionsAppearanceProxy {

		//MARK: easeIn 
		public var _easeIn: AnimationCurveType?
		open func easeInProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationCurveType {
			if let override = _easeIn { return override }
			return .timingParameters(UICubicTimingParameters(controlPoint1: CGPoint(x: 1.0, y: 0.0), controlPoint2: CGPoint(x: 0.78, y: 1.0)))
			}
		public var easeIn: AnimationCurveType {
			get { return self.easeInProperty() }
			set { _easeIn = newValue }
		}
	}
	//MARK: - Metric
	public var _Metric: MetricAppearanceProxy?
	open func MetricStyle() -> MetricAppearanceProxy {
		if let override = _Metric { return override }
			return MetricAppearanceProxy()
		}
	public var Metric: MetricAppearanceProxy {
		get { return self.MetricStyle() }
		set { _Metric = newValue }
	}
	public class MetricAppearanceProxy {

		//MARK: test 
		public var _test: CGFloat?
		open func testProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _test { return override }
			return CGFloat(10.0)
			}
		public var test: CGFloat {
			get { return self.testProperty() }
			set { _test = newValue }
		}
	}
	//MARK: - Color
	public var _Color: ColorAppearanceProxy?
	open func ColorStyle() -> ColorAppearanceProxy {
		if let override = _Color { return override }
			return ColorAppearanceProxy()
		}
	public var Color: ColorAppearanceProxy {
		get { return self.ColorStyle() }
		set { _Color = newValue }
	}
	public class ColorAppearanceProxy {

		//MARK: yellow 
		public var _yellow: UIColor?
		open func yellowProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
			if let override = _yellow { return override }
			return UIColor(red: 0.0, green: 0.47058824, blue: 0.83137256, alpha: 1.0)
			}
		public var yellow: UIColor {
			get { return self.yellowProperty() }
			set { _yellow = newValue }
		}
	}
	//MARK: - Animator
	public typealias AnimationCompletion = () -> Void

	public final class AnimationContext: NSObject {
		private(set) public var viewTag: String
		private(set) public var type: AnimationType

		public init(viewTag: String, type: AnimationType) {
			self.viewTag = viewTag
			self.type = type
		}

		public var completion: AnimationCompletion?

		public func animation(of type: AnimationType) -> UIViewPropertyAnimator {
			return animations.last!
		}

		public func add(_ animator: UIViewPropertyAnimator) {
			animations.append(animator)
		}

		private var allAnimationsFinished: Bool = true
		private var animations = [UIViewPropertyAnimator]()
		private var lastAnimationStarted: Date?
		private var lastAnimationAborted: Date?

		struct Keys {
			static let animationContextUUID = "UUID"
		}
	}

		public struct AnimatorContext {
			static var animatorContexts = [AnimationContext]()
		}


	public var _Animator: AnimatorAnimatorProxy?
	open func AnimatorAnimator() -> AnimatorAnimatorProxy {
		if let override = _Animator { return override }
			return AnimatorAnimatorProxy()
		}
	public var Animator: AnimatorAnimatorProxy {
		get { return self.AnimatorAnimator() }
		set { _Animator = newValue }
	}
	open class AnimatorAnimatorProxy {
		public init() {}
		open func durationAnimation(of type: AnimationType, for view: UIView) -> CGFloat? {
			switch type {
			case .basic: return view.animator.basicStyle().durationProperty(view.traitCollection)
			}
		}

		open func curveAnimation(of type: AnimationType, for view: UIView) -> AnimationCurveType? {
			switch type {
			case .basic: return view.animator.basicStyle().curveProperty(view.traitCollection)
			}
		}

		open func keyFramesAnimation(of type: AnimationType, for view: UIView) -> [KeyFrame]? {
			switch type {
			case .basic: return view.animator.basicStyle().keyFramesProperty(view.traitCollection)
			}
		}

		open func repeatCountAnimation(of type: AnimationType, for view: UIView) -> AnimationRepeatCount? {
			switch type {
			case .basic: return view.animator.basicStyle().repeatCountProperty(view.traitCollection)
			}
		}

		open func delayAnimation(of type: AnimationType, for view: UIView) -> CGFloat? {
			switch type {
			case .basic: return view.animator.basicStyle().delayProperty(view.traitCollection)
			}
		}

		open func animator(type: AnimationType, for view: UIView, options: AnimationConfigOptions?) -> UIViewPropertyAnimator {
			let duration = options?.duration ?? TimeInterval(durationAnimation(of: type, for: view)!)
			let curve = curveAnimation(of: type, for: view)!
			let repeatCount = options?.repeatCount ?? repeatCountAnimation(of: type, for: view)
			let propertyAnimator: UIViewPropertyAnimator
			switch curve {
				case let .native(curve):
					propertyAnimator = UIViewPropertyAnimator(duration: duration, curve: curve)
				case let .timingParameters(curve):
					propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: curve)
			}
			propertyAnimator.repeatCount = repeatCount
			propertyAnimator.addAnimations({ [weak self] in
				UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
					guard let `self` = self else { return }
					var keyFrames = self.keyFramesAnimation(of: type, for: view)!
					let onlyRotateValues: (AnimatableProp) -> Bool = { (value) in
						switch value {
						case let .rotate(_, to): return to > 180
						default: return false
						}
					}
					var normalizedKeyFrames = [KeyFrame]()
					for var keyFrame in keyFrames {
						keyFrame.values.forEach({ (value) in
							switch value {
							case let .rotate(from, to):
								if to > 180 {
									let split = 3
									let relativeDuration = keyFrame.relativeDuration ?? 1.0
									let relativeStartTime = keyFrame.relativeStartTime
									for i in 0 ..< split {
										let normalizedStartTime = relativeStartTime + (CGFloat(i) / CGFloat(split)) * (relativeDuration - relativeStartTime)
										normalizedKeyFrames.append(KeyFrame(relativeStartTime: normalizedStartTime, relativeDuration: relativeDuration/CGFloat(split), values: [.rotate(from: from, to: to/CGFloat(split))]))
									}
								}
							default: return
							}
						})
						keyFrame.values = keyFrame.values.filter({ onlyRotateValues($0) == false })
					}
					keyFrames = keyFrames + normalizedKeyFrames

					for keyFrame in keyFrames {
						let relativeStartTime = Double(keyFrame.relativeStartTime)
						let relativeDuration = Double(keyFrame.relativeDuration ?? 1.0)
						keyFrame.values.forEach({ $0.applyFrom(to: view) })
						UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration) {
							keyFrame.values.forEach({ $0.applyTo(to: view) })
						}
					}
				})
			})
			if let repeatCount = propertyAnimator.repeatCount, case let .count(count) = repeatCount, count == 0 { return propertyAnimator }
			propertyAnimator.addCompletion({ _ in
				let currentContext = AnimatorContext.animatorContexts.filter({ $0.type == type && $0.viewTag == view.animatorIdentifier }).first

				if let repeatCount = currentContext?.animation(of: type).repeatCount {
					let nextAnimation = self.animator(type: type, for: view, options: options)
					if case let .count(count) = repeatCount {
						let nextCount = count - 1
						nextAnimation.repeatCount = nextCount > 0 ? .count(nextCount) : nil
					}
					if let repeatCount = nextAnimation.repeatCount, case let .count(count) = repeatCount, count == 0 { return }
					nextAnimation.startAnimation()
					currentContext!.add(nextAnimation)
				}
			})
			return propertyAnimator
		}

		open func animate(view: UIView, type: AnimationType, state: AnimationState = .start, options: AnimationConfigOptions?) {
			let currentContext = AnimatorContext.animatorContexts.filter({ $0.type == type && $0.viewTag == view.animatorIdentifier }).first
			if currentContext != nil && state == .start { return }

			switch state {
			case .start:
				view.animatorIdentifier = UUID().uuidString
				let context = AnimationContext(viewTag: view.animatorIdentifier!, type: type)
				let animation = view.animator.animator(type: type, for: view, options: options)
				let delay = options?.delay ?? (delayAnimation(of: type, for: view) ?? 0.0)
				animation.startAnimation(afterDelay: TimeInterval(delay))
				context.add(animation)
				AnimatorContext.animatorContexts.append(context)
			default: return
			}
		}

		//MARK: - basic
		public var _basic: basicAppearanceProxy?
		open func basicStyle() -> basicAppearanceProxy {
			if let override = _basic { return override }
				return basicAppearanceProxy()
			}
		public var basic: basicAppearanceProxy {
			get { return self.basicStyle() }
			set { _basic = newValue }
		}
		public class basicAppearanceProxy {

		//MARK: keyFrames 
		public var _keyFrames: [KeyFrame]?
		open func keyFramesProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> [KeyFrame] {
			if let override = _keyFrames { return override }
			return [
			KeyFrame(relativeStartTime: 0.0, relativeDuration: nil, values: 
			[
			.rotate(from: 
			CGFloat(0.0), to: 
			CGFloat(180.0))])]
			}
		public var keyFrames: [KeyFrame] {
			get { return self.keyFramesProperty() }
			set { _keyFrames = newValue }
		}

		//MARK: repeatCount 
		public var _repeatCount: AnimationRepeatCount?
		open func repeatCountProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationRepeatCount {
			if let override = _repeatCount { return override }
			return AnimationRepeatCount.infinite
			}
		public var repeatCount: AnimationRepeatCount {
			get { return self.repeatCountProperty() }
			set { _repeatCount = newValue }
		}

		//MARK: curve 
		public var _curve: AnimationCurveType?
		open func curveProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> AnimationCurveType {
			if let override = _curve { return override }
			return TeamsStyle.shared().TimingFunctions.easeInProperty(traitCollection)
			}
		public var curve: AnimationCurveType {
			get { return self.curveProperty() }
			set { _curve = newValue }
		}

		//MARK: delay 
		public var _delay: CGFloat?
		open func delayProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _delay { return override }
			return CGFloat(0.0)
			}
		public var delay: CGFloat {
			get { return self.delayProperty() }
			set { _delay = newValue }
		}

		//MARK: duration 
		public var _duration: CGFloat?
		open func durationProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> CGFloat {
			if let override = _duration { return override }
			return CGFloat(2.0)
			}
		public var duration: CGFloat {
			get { return self.durationProperty() }
			set { _duration = newValue }
		}
		}
	

}
}
extension UIViewPropertyAnimator {

	public var repeatCount: AnimationRepeatCount? {
		get {
			guard let count = objc_getAssociatedObject(self, &__AnimatorRepeatCountHandle) as? AnimationRepeatCount else { return nil }
			return count
		}
		set { objc_setAssociatedObject(self, &__AnimatorRepeatCountHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
}

extension UIView: AnimatorProxyComponent {

	public var animatorIdentifier: String? {
		get {
			guard let identifier = objc_getAssociatedObject(self, &__AnimatorIdentifierHandle) as? String else { return nil }
			return identifier
		}
		set { objc_setAssociatedObject(self, &__AnimatorIdentifierHandle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
	}

	public typealias AnimatorProxyType = TeamsStyle.AnimatorAnimatorProxy
	public var animator: AnimatorProxyType {
		get {
			guard let a = objc_getAssociatedObject(self, &__AnimatorProxyHandle) as? AnimatorProxyType else { return StylesheetManager.stylesheet(TeamsStyle.shared()).Animator }
			return a
		}
		set { objc_setAssociatedObject(self, &__AnimatorProxyHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}

	public func basic(state: AnimationState = .start, options: AnimationConfigOptions? = nil) {
		animator.animate(view: self, type: .basic, state: state, options: options)
	}

}
