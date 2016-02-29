///Autogenerated file

import Cocoa

///Entry point for the app stylesheet
public class S {

//MARK: - FooView
	public static let FooView = FooViewStyle()
	public class FooViewStyle {

		//MARK: background 
		private var __background: NSColor?
		private func backgroundIn() -> NSColor {
			if let override = __background { return override }
			return Color.redIn()
		}
		public var background: NSColor {
			get { return self.backgroundIn() }
			set { __background = newValue }
		}

		//MARK: font 
		private var __font: NSFont?
		private func fontIn() -> NSFont {
			if let override = __font { return override }
			return Typography.smallIn()
		}
		public var font: NSFont {
			get { return self.fontIn() }
			set { __font = newValue }
		}
	}
//MARK: - Color
	public static let Color = ColorStyle()
	public class ColorStyle {

		//MARK: blue 
		private var __blue: NSColor?
		private func blueIn() -> NSColor {
			if let override = __blue { return override }
			return NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
		}
		public var blue: NSColor {
			get { return self.blueIn() }
			set { __blue = newValue }
		}

		//MARK: red 
		private var __red: NSColor?
		public func redIn() -> NSColor {
			if let override = __red { return override }
			if NSApplication.sharedApplication().mainWindow?.frame.size.width < 300.0  { 
			return NSColor(red: 0.666667, green: 0.0, blue: 0.0, alpha: 1.0) }
			
			return NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
		}
		public var red: NSColor {
			get { return self.redIn() }
			set { __red = newValue }
		}
	}
//MARK: - Typography
	public static let Typography = TypographyStyle()
	public class TypographyStyle {

		//MARK: small 
		private var __small: NSFont?
		private func smallIn() -> NSFont {
			if let override = __small { return override }
			return NSFont(name: "Helvetica", size: 12.0)!
		}
		public var small: NSFont {
			get { return self.smallIn() }
			set { __small = newValue }
		}

		//MARK: medium 
		private var __medium: NSFont?
		private func mediumIn() -> NSFont {
			if let override = __medium { return override }
			return NSFont(name: "Helvetica", size: 18.0)!
		}
		public var medium: NSFont {
			get { return self.mediumIn() }
			set { __medium = newValue }
		}
	}

}