import Foundation

//MARK: Rhs

enum RhsError: Error {
  case malformedRhsValue(error: String)
  case malformedCondition(error: String)
  case `internal`
}

enum RhsValue {

  /// A scalar float value.
  case scalar(float: Float)

  /// A CGPoint.
  case point(x: Float, y: Float)

  /// A CGPoint.
  case size(width: Float, height: Float)

  /// A CGRect value.
  case rect(x: Float, y: Float, width: Float, height: Float)

  /// A UIEdgeInsets value.
  case edgeInset(top: Float, left: Float, bottom: Float, right: Float)

  /// A boolean value.
  case boolean(bool: Bool)

  /// A font value.
  case font(font: Rhs.Font)

  /// A color value.
  case color(color: Rhs.Color)

  /// A image.
  case image(image: String)

  /// A redirection to another value.
  case redirect(redirection: RhsRedirectValue)

  /// A map between cocndition and a rhs.
  case hash(hash: [Condition: RhsValue])

  /// An enum.
  case `enum`(type: String, name: String)
  
  /// An animation curve
  case timingFunction(function: Rhs.TimingFunction)
  
  /// A KeyFrame.
  case keyFrame(keyFrame: Rhs.KeyFrame)
  
  /// A KeyFrameValue.
  case keyFrameValue(value: Rhs.AnimationValue)
  
  /// An array of RhsValue
  case array(values: [RhsValue])
    
  /// A call to the super stylesheet.
  case call(call: String, type: String)

  fileprivate var isHash: Bool {
    switch self {
    case .hash: return true
    default: return false
    }
  }

  fileprivate var isRedirect: Bool {
    switch self {
//    case .keyFrame(let keyFrame): return keyFrame.timing?.isRedirect ?? false
    case .redirect: return true
    default: return false
    }
  }

  fileprivate var redirection: String? {
    switch self {
    case .redirect(let r): return r.redirection
//    case .keyFrame(let keyFrame):
//      guard let timing = keyFrame.timing, case let .redirect(r) = timing else { return nil }
//      return r.redirection
    default: return nil
    }
  }
  
  fileprivate func applyRedirection(_ redirectValue: RhsRedirectValue) -> RhsValue {
    switch self {
    case .redirect(_): return .redirect(redirection: redirectValue)
//    case .keyFrame(let keyFrame):
//      guard let timing = keyFrame.timing, timing.isRedirect else { return self }
//      return .keyFrame(keyFrame: keyFrame)
    default: return self
    }
  }

  static func valueFrom(_ scalar: Float) -> RhsValue  {
    return .scalar(float: Float(scalar))
  }

  static func valueFrom(_ boolean: Bool) -> RhsValue  {
    return .boolean(bool: boolean)
  }
    
  static func valueFrom(_ array: [Yaml]) throws -> RhsValue  {
    var values = [RhsValue]()
    for item in array {
      do {
        var rhsValue: RhsValue? = nil
        switch item {
        case .dictionary(let dictionary): rhsValue = try valueFrom(dictionary)
        case .bool(let boolean): rhsValue = valueFrom(boolean)
        case .double(let double): rhsValue = valueFrom(Float(double))
        case .int(let integer): rhsValue = valueFrom(Float(integer))
        case .string(let string): rhsValue = try valueFrom(string)
        default:
          throw RhsError.internal
        }
        values.append(rhsValue!)
      } catch {
        throw RhsError.internal
      }
    }
    return .array(values: values)
  }

  static func valueFrom(_ hash: [Yaml: Yaml]) throws -> RhsValue  {
    var conditions = [Condition: RhsValue]()
    for (k, value) in hash {
      guard let key = k.string else { continue }
      do {
        switch value {
        case .int(let integer):
          try conditions[Condition(rawString: key)] = RhsValue.valueFrom(Float(integer))
        case .double(let double):
          try conditions[Condition(rawString: key)] = RhsValue.valueFrom(Float(double))
        case .string(let string):
          try conditions[Condition(rawString: key)] = RhsValue.valueFrom(string)
        case .bool(let boolean):
          try conditions[Condition(rawString: key)] = RhsValue.valueFrom(boolean)
        default:
          assert(false, "k.string: \(key), value: \(value)")
          throw RhsError.internal
        }
      } catch {
        assert(false, "altro errore k.string: \(key), value: \(value)")
        throw RhsError.malformedCondition(error: "\(conditions) is not well formed")
      }
    }
    return .hash(hash: conditions)
  }

  static func valueFrom(_ string: String) throws  -> RhsValue  {

    if let components = argumentsFromString("font", string: string) {
      assert(components.count == 2, "Not a valid font. Format: Font(\"FontName\", size)")
      return .font(font: Rhs.Font(name: components[0], size:Float(parseNumber(components[1]))))

    } else if let components = argumentsFromString("color", string: string) {
      assert(components.count == 1, "Not a valid color. Format: \"#rrggbb\" or \"#rrggbbaa\"")
      return .color(color: Rhs.Color(rgba: "#\(components[0])"))

    } else if let components = argumentsFromString("image", string: string) {
      assert(components.count == 1, "Not a valid redirect. Format: Image(\"ImageName\")")
      return .image(image: components[0])

    } else if let components = argumentsFromString("redirect", string: string) {
      let error = "Not a valid redirect. Format $Style.Property"
      assert(components.count == 1, error)
      return .redirect(redirection: RhsRedirectValue(redirection: components[0], type: "Any"))

    } else if let components = argumentsFromString("point", string: string) {
      assert(components.count == 2, "Not a valid point. Format: Point(x, y)")
      let x = parseNumber(components[0])
      let y = parseNumber(components[1])
      return .point(x: x, y: y)

    } else if let components = argumentsFromString("size", string: string) {
      assert(components.count == 2, "Not a valid size. Format: Size(width, height)")
      let w = parseNumber(components[0])
      let h = parseNumber(components[1])
      return .size(width: w, height: h)

    } else if let components = argumentsFromString("rect", string: string) {
      assert(components.count == 4, "Not a valid rect. Format: Rect(x, y, width, height)")
      let x = parseNumber(components[0])
      let y = parseNumber(components[1])
      let w = parseNumber(components[2])
      let h = parseNumber(components[3])
      return .rect(x: x, y: y, width: w, height: h)

    } else if let components = argumentsFromString("edgeInsets", string: string) {
      assert(components.count == 4, "Not a valid edge inset. Format: EdgeInset(top, left, bottom, right)")
      let top = parseNumber(components[0])
      let left = parseNumber(components[1])
      let bottom = parseNumber(components[2])
      let right = parseNumber(components[3])
      return .edgeInset(top: top, left: left, bottom: bottom, right: right)

    } else if let components = argumentsFromString("insets", string: string) {
      assert(components.count == 4, "Not a valid edge inset. Format: EdgeInset(top, left, bottom, right)")
      let top = parseNumber(components[0])
      let left = parseNumber(components[1])
      let bottom = parseNumber(components[2])
      let right = parseNumber(components[3])
      return .edgeInset(top: top, left: left, bottom: bottom, right: right)

    } else if let components = argumentsFromString("timingFunction", string: string) {
      assert(components.count == 4 || components.count == 1, "Not a valid timing function. Format: TimingFunction(c1, c2, c3, c4) or TimingFunction(easeIn)")
      if components.count == 4 {
        let c1 = parseNumber(components[0])
        let c2 = parseNumber(components[1])
        let c3 = parseNumber(components[2])
        let c4 = parseNumber(components[3])
        return .timingFunction(function: Rhs.TimingFunction(c1: c1, c2: c2, c3: c3, c4: c4))
      } else {
        return .timingFunction(function: Rhs.TimingFunction(name: components[0]))
      }
      
    } else if let components = argumentsFromString(Rhs.AnimationValue.Props.animationValueKey, string: string) {
      assert(components.count == 2 || components.count == 3)
      var type: String?
      var from: RhsValue?
      var to: RhsValue?
      
      for component in components {
        if component.hasPrefix(Rhs.AnimationValue.Props.typeKey) {
          type = escape(Rhs.AnimationValue.Props.typeKey, string: component)
        } else if component.hasPrefix(Rhs.AnimationValue.Props.fromKey) {
          from = valueFrom(parseNumber(argumentsFromString(Rhs.AnimationValue.Props.fromKey, string: component)!.first!))
        } else if component.hasPrefix(Rhs.AnimationValue.Props.toKey) {
          to = valueFrom(parseNumber(argumentsFromString(Rhs.AnimationValue.Props.toKey, string: component)!.first!))
        }
      }
      return .keyFrameValue(value: Rhs.AnimationValue(type: type!, from: from, to: to!))
      
    } else if let components = argumentsFromString(Rhs.KeyFrame.Props.keyFrameKey, string: string) {
      var relativeStartTime: Float?
      var relativeDuration: Float?
      var values: RhsValue?
      
      for var component in components {
        component = component.trimmingCharacters(in: CharacterSet.whitespaces)
        if component.hasPrefix(Rhs.KeyFrame.Props.relativeStartTimeKey) {
          relativeStartTime = parseNumber(component.replacingOccurrences(of: "\(Rhs.KeyFrame.Props.relativeStartTimeKey): ", with: ""))
        } else if component.hasPrefix(Rhs.KeyFrame.Props.relativeDurationKey) {
          relativeDuration = parseNumber(component.replacingOccurrences(of: "\(Rhs.KeyFrame.Props.relativeDurationKey): ", with: ""))
        } else if component.hasPrefix(Rhs.KeyFrame.Props.animationValuesKey) {
          var function = components.filter({ !$0.hasPrefix(Rhs.KeyFrame.Props.relativeStartTimeKey) && !$0.hasPrefix(Rhs.KeyFrame.Props.relativeDurationKey) }).joined(separator: ",")
          function = function.trimmingCharacters(in: CharacterSet.whitespaces)
          function = function.replacingOccurrences(of: " ", with: "")
          function = function.replacingOccurrences(of: "\(Rhs.KeyFrame.Props.animationValuesKey):", with: "")
          function = function.replacingOccurrences(of: "\(Rhs.AnimationValue.Props.animationValueKey)", with: "\"\(Rhs.AnimationValue.Props.animationValueKey)")
          function = function.replacingOccurrences(of: ")", with: ")\"")
          if let yaml = try? Yaml.load(function), case let .array(a) = yaml {
            values = try? valueFrom(a)
          }
        }
      }
      return .keyFrame(keyFrame: Rhs.KeyFrame(relativeStartTime: relativeStartTime, relativeDuration: relativeDuration, values: values))
      
    } else if let components = argumentsFromString("enum", string: string) {
      assert(components.count == 1, "Not a valid enum. Format: enum(Type.Value)")
      let enumComponents = components.first!.components(separatedBy: ".")
      assert(enumComponents.count == 2 || enumComponents.count == 3, "An enum should be expressed in the form Type.Value")
      let type = enumComponents.count == 2 ? enumComponents[0] : "\(enumComponents[0]).\(enumComponents[1])"
      let name = enumComponents.count == 2 ? enumComponents[1] : enumComponents[2]
      return .enum(type: type, name: name)

    } else if let components = argumentsFromString("call", string: string) {
      assert(components.count == 2, "Not a valid enum. Format: enum(Type.Value)")
      let call = components[0].trimmingCharacters(in: CharacterSet.whitespaces)
      let type = components[1].trimmingCharacters(in: CharacterSet.whitespaces)
      return .call(call: call, type: type)
    }

    throw RhsError.malformedRhsValue(error: "Unable to parse rhs value, string:\(string)")
  }

  func returnValue() -> String {
    switch self {
    case .scalar(_): return "CGFloat"
    case .boolean(_): return "Bool"
    case .font(_): return Configuration.targetOsx ? "NSFont" : "UIFont"
    case .color(_): return Configuration.targetOsx ? "NSColor" : "UIColor"
    case .image(_): return Configuration.targetOsx ? "NSImage" : "UIImage"
    case .enum(let type, _): return type
    case .redirect(let r): return r.type
    case .point(_, _): return "CGPoint"
    case .size(_, _): return "CGSize"
    case .rect(_, _, _, _): return "CGRect"
    case .edgeInset(_, _, _, _): return  Configuration.targetOsx ? "NSEdgeInsets" : "UIEdgeInsets"
    case .timingFunction(let function): return function.controlPoints != nil ? "UITimingCurveProvider" : "UIView.AnimationCurve"
    case .keyFrame(_): return "KeyFrame"
    case .keyFrameValue(_): return "AnimationableProp"
    case .hash(let hash): for (_, rhs) in hash { return rhs.returnValue() }
    case .call(_, let type): return type
    case .array(let values):
      guard let returnTypes = Optional(values.flatMap({ $0.returnValue() })), let first = returnTypes.first, returnTypes.filter({ $0 == first }).count == returnTypes.count else { return "[Any]" }
      return "[\(first)]"
    }
    return "Any"
  }
}

class RhsRedirectValue {
  fileprivate var redirection: String
  fileprivate var type: String
  init(redirection: String, type: String) {
    self.redirection = redirection
    self.type = type
  }
}

//MARK: Generator

extension RhsValue: Generatable {

    func generate(_ isNested: Bool = false) -> String {
    let indentationNested = isNested ? "\t\t" : ""
    let indentation = "\n\(indentationNested)\t\t\t"
    let prefix = "\(indentation)return "
    switch self {
    case .scalar(let float):
      return generateScalar(prefix, float: float)

    case .boolean(let boolean):
      return generateBool(prefix, boolean: boolean)

    case .font(let font):
      return generateFont(prefix, font: font)

    case .color(let color):
      return generateColor(prefix, color: color)

    case .image(let image):
      return generateImage(prefix, image: image)

    case .redirect(let redirection):
      return generateRedirection(prefix, redirection: redirection)

    case .enum(let type, let name):
      return generateEnum(prefix, type: type, name: name)

    case .point(let x, let y):
      return generatePoint(prefix, x: x, y: y)

    case .size(let w, let h):
      return generateSize(prefix, width: w, height: h)

    case .rect(let x, let y, let w, let h):
      return generateRect(prefix, x: x, y: y, width: w, height: h)

    case .edgeInset(let top, let left, let bottom, let right):
      return generateEdgeInset(prefix, top: top, left: left, bottom: bottom, right: right)
      
    case .timingFunction(let function):
      return generateTimingFunction(prefix, function: function)
      
    case .keyFrame(let keyFrame):
      return generateKeyFrame(prefix, keyFrame: keyFrame)
      
    case .keyFrameValue(let keyFrameValue):
      return generateKeyFrameValue(prefix, keyFrameValue: keyFrameValue)

    case .call(let call, _):
      return generateCall(prefix, string: call)
      
    case .array(let values):
      return generateArray(prefix, values: values)

    case .hash(let hash):
      var string = ""
      for (condition, rhs) in hash {
        if !condition.isDefault() {
          string += "\(indentation)if \(condition.generate()) { \(rhs.generate())\(indentation)}"
        }
      }
      //default should be the last condition
      for (condition, rhs) in hash {
        if condition.isDefault() {
          string += "\(indentation)\(rhs.generate())"
        }
      }
      return string
    }

  }

  func generateScalar(_ prefix: String, float: Float) -> String {
    return "\(prefix)CGFloat(\(float))"
  }

  func generateBool(_ prefix: String, boolean: Bool) -> String {
    return "\(prefix)\(boolean)"
  }

  func generateFont(_ prefix: String, font: Rhs.Font) -> String {
    let fontClass = Configuration.targetOsx ? "NSFont" : "UIFont"

    //system font
    if font.isSystemFont || font.isSystemBoldFont || font.isSystemItalicFont {
      var function: String? = nil
      if font.isSystemFont {
        function = "systemFont"
      } else if font.isSystemBoldFont {
        function = "boldSystemFont"
      } else if font.isSystemItalicFont {
        function = "italicSystemFont"
      }
      let weight = font.hasWeight ? ", weight: \(font.weight!)" : ""
      return "\(prefix)\(fontClass).\(function!)(ofSize: \(font.fontSize)\(weight))"
    }

    //font with name
    return "\(prefix)\(fontClass)(name: \"\(font.fontName)\", size: \(font.fontSize))!"
  }
  
  func generateColor(_ prefix: String, color: Rhs.Color) -> String {
    let colorClass = Configuration.targetOsx ? "NSColor" : "UIColor"
    return
      "\(prefix)\(colorClass)"
      + "(red: \(color.red), green: \(color.green), blue: \(color.blue), alpha: \(color.alpha))"
  }
  
  func generateTimingFunction(_ prefix: String, function: Rhs.TimingFunction) -> String {
    
    //control points font
    if let controlPoints = function.controlPoints {
      return "\(prefix)UICubicTimingParameters(controlPoint1: CGPoint(x: \(controlPoints.c1), y: \(controlPoints.c2)), controlPoint2: CGPoint(x: \(controlPoints.c3), y: \(controlPoints.c4)))"
    } else {
      return "\(prefix)\(function.name!)"
    }
  }
  
  func generateKeyFrame(_ prefix: String, keyFrame: Rhs.KeyFrame) -> String {
//    let time = keyFrame.time ?? 0.0
//    let timing = keyFrame.timing?.generate() ?? "nil"
    let relativeStartTime = keyFrame.relativeStartTime ?? 0.0
    let relativeDuration = keyFrame.relativeDuration ?? 0.0
    let values = keyFrame.values?.generate() ?? "nil"
    return "\(prefix)KeyFrame(relativeStartTime: \(relativeStartTime), relativeDuration: \(relativeDuration), values: \(values))"
  }
  
  func generateKeyFrameValue(_ prefix: String, keyFrameValue: Rhs.AnimationValue) -> String {
    return "\(prefix)\(keyFrameValue.enumType)"
  }
    
  func generateImage(_ prefix: String, image: String) -> String {
    let colorClass = Configuration.targetOsx ? "NSImage" : "UImage"
    return "\(prefix)\(colorClass)(named: \"\(image)\")!"
  }

  func generateRedirection(_ prefix: String, redirection: RhsRedirectValue) -> String {
    if Configuration.targetOsx {
      return "\(prefix)\(redirection.redirection)Property()"
    } else {
      return "\(prefix)\(redirection.redirection)Property(traitCollection)"
    }
  }

  func generateEnum(_ prefix: String, type: String, name: String) -> String {
    return "\(prefix)\(type).\(name)"
  }

  func generatePoint(_ prefix: String, x: Float, y: Float) -> String {
    return "\(prefix)CGPoint(x: \(x), y: \(y))"
  }

  func generateSize(_ prefix: String, width: Float, height: Float) -> String {
    return "\(prefix)CGSize(width: \(width), height: \(height))"
  }

  func generateRect(_ prefix: String, x: Float, y: Float, width: Float, height: Float) -> String {
    return "\(prefix)CGRect(x: \(x), y: \(y), width: \(width), height: \(height))"
  }

  func generateEdgeInset(_ prefix: String,
                         top: Float,
                         left: Float,
                         bottom: Float,
                         right: Float) -> String {
    return
      "\(prefix)\(Configuration.targetOsx ? "NS" : "UI")EdgeInsets(top: \(top), left: \(left), "
      + "bottom: \(bottom), right: \(right))"
  }

  func generateCall(_ prefix: String, string: String) -> String {
    return "\(prefix)\(string)"
  }
  
  func generateArray(_ prefix: String, values: [RhsValue]) -> String {
    var string = prefix
    for (index, value) in values.enumerated() {
      if index == 0 {
        string.append("[")
      }
      string.append(value.generate().replacingOccurrences(of: "return ", with: ""))
      if index != values.count - 1 {
        string.append(", ")
      } else {
        string.append("]")
      }
    }
    return string
  }
}

//MARK: Property

class Property {
  var style: Style?
  var rhs: RhsValue?
  let key: String
  var isOverride: Bool = false
  var isOverridable: Bool = false

    init(key: String, rhs: RhsValue?, style: Style?) {
      self.style = style
      self.rhs = rhs
      self.key = key.replacingOccurrences(of: ".", with: "_")
  }
}

extension Property: Generatable {

 func generate(_ isNested: Bool = false) -> String {
    var generated = ""
    if let style = self.style {
        generated = style.generate(true)
    } else if let rhs = self.rhs {
        
        var method = ""
        let indentation = isNested ? "\t\t\t" : "\t\t"
        method += "\n\n\(indentation)//MARK: \(self.key) "
        
        if !isOverride {
            let visibility = isOverridable ? "public" : "fileprivate"
            method += "\n\(indentation)\(visibility) var _\(key): \(rhs.returnValue())?"
        }
        
        // Options.
        let objc = Configuration.objcGeneration ? "@objc " : ""
        let screen = Configuration.targetOsx
            ? "NSApplication.sharedApplication().mainWindow?"
            : "UIScreen.main"
        let methodArgs =  Configuration.targetOsx
            ? "" : "_ traitCollection: UITraitCollection? = \(screen).traitCollection"
        let override = isOverride ? "override " : ""
        let visibility = isOverridable ? "open" : "public"
        
        method +=
        "\n\(indentation)\(override)\(visibility) func \(key)Property(\(methodArgs)) -> \(rhs.returnValue()) {"
        method += "\n\(indentation)\tif let override = _\(key) { return override }"
        method += "\(rhs.generate(isNested))"
        method += "\n\(indentation)\t}"
        
        if !isOverride {
            method += "\n\(indentation)\(objc)public var \(key): \(rhs.returnValue()) {"
            method += "\n\(indentation)\tget { return self.\(key)Property() }"
            method += "\n\(indentation)\tset { _\(key) = newValue }"
            method += "\n\(indentation)}"
        }
        generated = method
    }
    return generated
  }
}

//MARK: Animatio

//class Animation: Style {
//  let keyFrames: [Property]
//  
//  init(name: String, properties: [Property]) {
//    
//  }
//}


//MARK: Style

class Style {
  var name: String
  var superclassName: String? = nil
  let properties: [Property]
  var isExtension = false
  var isAnimation = false
  var isOverridable = false
  var isApplicable = false
  var isNestedOverride = false
  var isNestedOverridable = false
  var nestedOverrideName: String?
  var nestedSuperclassName: String? = nil
  var viewClass: String = "UIView"

  init(name: String, properties: [Property]) {
    var styleName = name.trimmingCharacters(in: CharacterSet.whitespaces)

    // Check if this could generate an extension.
    let extensionPrefix = "__appearance_proxy"
    if styleName.contains(extensionPrefix) {
      styleName = styleName.replacingOccurrences(of: extensionPrefix, with: "")
      isExtension = true
    }
    let openPrefix = "__open"
    if styleName.contains(openPrefix) {
      styleName = styleName.replacingOccurrences(of: openPrefix, with: "")
      isOverridable = true
    }
    let protocolPrefix = "__style"
    if styleName.contains(protocolPrefix) {
      styleName = styleName.replacingOccurrences(of: protocolPrefix, with: "")
    }
    let applicableSelfPrefix = "for Self"
    if styleName.contains(applicableSelfPrefix) {
      styleName = styleName.replacingOccurrences(of: applicableSelfPrefix, with: "")
      isApplicable = true
    }
    // Trims spaces
    styleName = styleName.replacingOccurrences(of: " ", with: "")

    // Superclass defined.
    if let components = Optional(styleName.components(separatedBy: "for")), components.count == 2 {
      styleName = components[0].replacingOccurrences(of: " ", with: "")
      viewClass = components[1].replacingOccurrences(of: " ", with: "")
      isApplicable = true
    }

    // Superclass defined.
    if let components = Optional(styleName.components(separatedBy: "extends")), components.count == 2 {
      styleName = components[0].replacingOccurrences(of: " ", with: "")
      superclassName = components[1].replacingOccurrences(of: " ", with: "")
    }
    if isOverridable {
      properties.forEach({ $0.isOverridable = true })
    }

    self.name = styleName
    self.properties = properties
  }
}

extension Style: Generatable {

  public func generate(_ isNested: Bool = false) -> String {

    var indentation = isNested ? "\t\t" : "\t"
    if isAnimation {
        indentation.append("\t")
    }
    var wrapper = isNested ? "\n\n" + indentation : indentation
    if let nestedOverrideName = nestedOverrideName {
      wrapper += "//MARK: - \(nestedOverrideName)"
    } else {
      wrapper += "//MARK: - \(name)"
    }
    
    let objc = Configuration.objcGeneration ? "@objc " : ""
    var superclass = Configuration.objcGeneration ? ": NSObject" : ""
    var nestedSuperclass = Configuration.objcGeneration ? ": NSObject" : ""
    
    if let s = superclassName { superclass = ": \(s)AppearanceProxy" }
    if let s = nestedSuperclassName { nestedSuperclass = ": \(s)AppearanceProxy" }
    let visibility = isOverridable ? "open" : "public"
    let staticModifier = isNested ? "" : " static"
    let variableVisibility = !isNested ? "public" : visibility
    let styleClass = isNestedOverride ? "\(nestedOverrideName!)AppearanceProxy" : "\(name)AppearanceProxy"
    
    if isNestedOverride || isNestedOverridable {
      let visibility = isNestedOverridable ? "open" : "public"
      let override = isNestedOverride ? "override " : ""
      let returnClass = isNestedOverride ? String(nestedSuperclass[nestedSuperclass.index(nestedSuperclass.startIndex, offsetBy: 2)...]) : styleClass
      
      if isNestedOverridable && !isNestedOverride {
        wrapper += "\n\(indentation)public var _\(name): \(styleClass)?"
      }
      
      wrapper +=
      "\n\(indentation)\(override)\(visibility) func \(name)Style() -> \(returnClass) {"
      wrapper += "\n\(indentation)\tif let override = _\(name) { return override }"
      wrapper += "\n\(indentation)\t\treturn \(styleClass)()"
      wrapper += "\n\(indentation)\t}"
      
      if isNestedOverridable && !isNestedOverride {
        wrapper += "\n\(indentation)\(objc)public var \(name): \(styleClass) {"
        wrapper += "\n\(indentation)\tget { return self.\(name)Style() }"
        wrapper += "\n\(indentation)\tset { _\(name) = newValue }"
        wrapper += "\n\(indentation)}"
      }
    } else {
      wrapper += "\n\(indentation)\(objc)\(variableVisibility)\(staticModifier) let \(name) = \(name)AppearanceProxy()"
    }
    let superclassDeclaration = isNestedOverride ? nestedSuperclass : superclass
    wrapper += "\n\(indentation)\(objc)\(visibility) class \(styleClass)\(superclassDeclaration) {"
    
    if isOverridable {
      wrapper += "\n\(indentation)\tpublic init() {}"
    }
    for property in properties {
      wrapper += property.generate(isNested)
    }
    
    if isApplicable {
      wrapper += "\n\(indentation)\tpublic func apply(view: \(isExtension ? self.name : self.viewClass)) {"
      for property in properties {
        wrapper +=
          "\n\(indentation)\t\tview.\(property.key.replacingOccurrences(of: "_", with: "."))"
          + " = self.\(property.key)"
      }
      wrapper += "\n\(indentation)\t}\n"
    }
    wrapper += "\n\(indentation)}\n"
    return wrapper
  }
}

//MARK: Stylesheet

class Stylesheet {

  let name: String
  let styles: [Style]
  let animations: [Style]
  let superclassName: String?
  let animatorName: String?

  init(name: String, styles: [Style], animations: [Style], superclassName: String? = nil, animatorName: String? = nil) {

    self.name = name
    self.styles = styles
    self.animations = animations
    self.superclassName = superclassName
    self.animatorName = animatorName
  }
  
  fileprivate func prepareGenerator() {
    [styles, animations].forEach { generatableArray in
      // Resolve the type for the redirected values.
      generatableArray.forEach({ resolveRedirection($0) })
      // Mark the overrides.
      generatableArray.forEach({ markOverrides($0, superclassName: $0.superclassName) })
      // Mark the overridables.
      let nestedStyles = generatableArray.flatMap{ $0.properties }.flatMap{ $0.style }
      let duplicates = Dictionary(grouping: nestedStyles, by: { $0.name })
        .filter { $1.count > 1 }
        .sorted { $0.1.count > $1.1.count }
        .flatMap { $0.value }
      for style in duplicates where !style.isNestedOverride {
        style.isNestedOverridable = true
      }
      
      if (superclassName == nil && Generator.Stylesheets.filter { (stylesheet) -> Bool in
        guard let superclassName = stylesheet.superclassName, superclassName == name else { return false }
        return true
        }.count > 0) {
        for style in generatableArray {
          style.isNestedOverridable = true
          style.properties.flatMap({ $0.style }).forEach({ $0.isNestedOverridable = true })
          style.properties.flatMap({ $0.style }).flatMap({ $0.properties }).forEach({ $0.isOverridable = true })
          style.properties.forEach({ $0.isOverridable = true })
        }
      }
    }
  }
  
  fileprivate func resolveRedirection(rhs: RhsValue) -> RhsValue? {
    if rhs.isRedirect == false { return nil }
    
    var redirection = rhs.redirection!
    let type = resolveRedirectedType(redirection)
    
    if Configuration.runtimeSwappable {
      var name: String? = nil
      let components = redirection.components(separatedBy: ".")
      if let _ = styles.filter({ return $0.name == components[0] }).first {
        name = self.name
      } else if let baseStylesheet = Generator.Stylesheets.filter({ $0.name == superclassName }).first {
        name = baseStylesheet.name
      }
      
      if let name = name {
        let stylesheet = Generator.Stylesheets.filter({ $0.superclassName != nil }).count > 0 ? "\(name).shared()." : "\(name).shared()."
        redirection = "\(stylesheet)\(redirection)"
      }
    }
    return rhs.applyRedirection(RhsRedirectValue(redirection: redirection, type: type))
  }
  
  fileprivate func resolveRedirection(_ style: Style) {
    for property in style.properties {
      if let rhs = property.rhs {
        if let redirect = resolveRedirection(rhs: rhs) {
          property.rhs = redirect
        } else if case let .array(values) = rhs {
//          assert(false, "values: \(values)")
          var newValues = [RhsValue]()
          for value in values {
            if let redirect = resolveRedirection(rhs: value) {
              newValues.append(redirect)
            } else {
              newValues.append(value)
            }
          }
          property.rhs = .array(values: newValues)
        }
      }

      if let nestedStyle = property.style {
        resolveRedirection(nestedStyle)
      }
    }
  }
  
  fileprivate func markOverridables(_ style: Style) {
    guard superclassName != nil else { return }
    
    if let _ = Generator.Stylesheets.filter({ $0.superclassName == nil }).flatMap({ style.isAnimation ? $0.animations : $0.styles }).filter({ $0.name == style.name }).first {
      style.isNestedOverridable = true
      style.properties.forEach({ $0.isOverridable = true })
    }
  }
  
  fileprivate func markOverrides(_ style: Style, superclassName: String?) {
    let searchInStyles = style.isAnimation == false
    let nestedSuperclassPrefix = searchInStyles ? "" : "\(animatorName!)AnimatorProxy."
    
    //check if the style is an override from a generic base stylesheet
    if let baseSuperclassName = self.superclassName, let baseStylesheet = Generator.Stylesheets.filter({ return $0.name == baseSuperclassName }).first {
      let stylesBase = searchInStyles ? baseStylesheet.styles : baseStylesheet.animations
      if let superStyle = stylesBase.filter({ return $0.name == style.name }).first {
        style.isNestedOverride = true
        style.nestedSuperclassName = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)"
        style.nestedOverrideName = "\(name)\(style.name)"
        
        for nestedStyle in style.properties.flatMap({ $0.style }) {
          if let superNestedStyle = superStyle.properties.flatMap({ $0.style }).filter({ $0.name == nestedStyle.name }).first {
            nestedStyle.isNestedOverride = true
            nestedStyle.nestedSuperclassName = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superNestedStyle.name)"
            nestedStyle.nestedOverrideName = "\(name)\(superNestedStyle.name)\(style.name)"
          }
          markOverrides(nestedStyle, superclassName: nestedStyle.nestedSuperclassName)
        }
      }
    }
    
    for property in style.properties {
      if let nestedStyle = property.style {
        let (isOverride, superclassName, styleName) = styleIsOverride(nestedStyle, superStyle: style)
        if let styleName = styleName, let superclassName = superclassName, isOverride, !nestedStyle.isNestedOverride {
          nestedStyle.isNestedOverride = isOverride
          nestedStyle.nestedSuperclassName = nestedSuperclassPrefix+superclassName
          nestedStyle.nestedOverrideName = styleName
        }
        markOverrides(nestedStyle, superclassName: nestedStyle.nestedSuperclassName)
      }
      
      property.isOverride = propertyIsOverride(property.key, superclass: superclassName, nestedSuperclassName: style.nestedSuperclassName, isStyleProperty: searchInStyles)
    }
  }
  
  fileprivate func styleIsOverride(_ style: Style, superStyle: Style) -> (isOverride: Bool, superclassName: String?, styleName: String?) {
    guard let _ = superStyle.superclassName else { return (false, nil, nil) }
    let stylesBase = style.isAnimation ? animations : styles
    
    let nestedStyles = stylesBase.flatMap{ $0.properties }.filter{
      guard let nestedStyle = $0.style, nestedStyle.name == style.name else { return false }
      return true
    };
    
    for st in stylesBase {
      for property in st.properties {
        if let nestedStyle = property.style, nestedStyle.name == style.name, let superclassName = st.superclassName, nestedStyles.count > 1 {
          return (true, "\(superclassName)AppearanceProxy.\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
        }
      }
    }
    return (false, nil, nil)
  }
  
  // Determines if this property is an override or not.
  fileprivate func propertyIsOverride(_ property: String, superclass: String?, nestedSuperclassName: String?, isStyleProperty: Bool) -> Bool {
    
    if let nestedSuperclassName = nestedSuperclassName, let components = Optional(nestedSuperclassName.components(separatedBy: ".")), components.count > 1, let baseStylesheet = Generator.Stylesheets.filter({ $0.name == components.first }).first {
      let stylesBase = isStyleProperty ? baseStylesheet.styles : baseStylesheet.animations
      if components.count == 2 || (components.count == 3 && isStyleProperty == false) {
        if let _ = stylesBase.filter({ $0.name == components.last }).first?.properties.filter({ return $0.key == property }).first {
          return true
        }
      } else {
        let style = components[1].replacingOccurrences(of: "AppearanceProxy", with: "");
        let nestedStyle = components[2].replacingOccurrences(of: "AppearanceProxy", with: "");
        if let _ = stylesBase.filter({ $0.name == style }).first?.properties.flatMap({ $0.style }).filter({ $0.name == nestedStyle }).first?.properties.filter({ return $0.key == property }).first {
          return true
        }
      }
    }
    guard let superclass = superclass else { return false }
    let stylesBase = isStyleProperty ? styles : animations
    guard let style = stylesBase.filter({ return $0.name == superclass }).first else {
      if let components = Optional(superclass.components(separatedBy: ".")), components.count == 2 {
        return true
      }
      return false
    }

    if let _ = style.properties.filter({ return $0.key == property }).first {
      return true
    } else {
      return propertyIsOverride(property, superclass: style.superclassName, nestedSuperclassName: style.nestedSuperclassName, isStyleProperty: isStyleProperty)
    }
  }

  // Recursively resolves the return type for this redirected property.
  fileprivate func resolveRedirectedType(_ redirection: String) -> String {

//    assert(false, "redirection \(redirection)")
    
    let components = redirection.components(separatedBy: ".")
    assert(components.count == 2 || components.count == 3, "Redirect \(redirection) invalid")
  
    var property: Property? = nil
    //first search in its own styles and animation
//    let stylesBase = styles : animations
    let stylesBase = styles
    let style = stylesBase.filter({ return $0.name == components[0] }).first
    if style != nil {
      if components.count == 2, let prop = style!.properties.filter({ return $0.key == components[1] }).first {
        property = prop
      } else if components.count == 3, let nestedStyleProperty = style!.properties.filter({ return $0.style?.name == components[1] }).first?.style, let prop = nestedStyleProperty.properties.filter({ return $0.key == components[2] }).first {
        property = prop
      }
    }
    
    //search in basestylesheet
    if property == nil {
      let stylesheet = Generator.Stylesheets.filter({ $0.name == superclassName }).first
//      let sourceStyles = inStyle ? stylesheet?.styles : stylesheet?.animations
      let sourceStyles = stylesheet?.styles
      
      if let style = sourceStyles?.filter({ return $0.name == components[0] }).first {
        if components.count == 2, let prop = style.properties.filter({ return $0.key == components[1] }).first {
          property = prop
        } else if components.count == 3, let nestedStyleProperty = style.properties.filter({ return $0.style?.name == components[1] }).first?.style, let prop = nestedStyleProperty.properties.filter({ return $0.key == components[2] }).first {
          property = prop
        }
      }
    }
    
    if let rhs = property!.rhs, rhs.isRedirect {
      return resolveRedirectedType(property!.rhs!.redirection!)
    } else {
      return property!.rhs!.returnValue()
    }
  }
}

extension Stylesheet: Generatable {

  public func generate(_ nested: Bool = false) -> String {
    prepareGenerator()
    
    var stylesheet = ""
    let objc = Configuration.objcGeneration ? "@objc " : ""
    var superclass = Configuration.objcGeneration || Configuration.runtimeSwappable ? ": NSObject" : ""
    let importDef = Configuration.targetOsx ? "Cocoa" : "UIKit"
    let isBaseStylesheet = superclassName == nil
    
    if let s = superclassName { superclass = ": \(s)" }

    stylesheet += "/// Autogenerated file\n"
    stylesheet += "\n// swiftlint:disable all\n"
    stylesheet += "import \(importDef)\n\n"
    if let namespace = Configuration.importFrameworks {
      stylesheet += "import \(namespace)\n\n"
    }
    
    if isBaseStylesheet {
      if Configuration.runtimeSwappable {
        if Generator.Stylesheets.filter({ $0.superclassName == name }).count > 0 {
          stylesheet += generateStylesheetManager()
        } else {
          stylesheet += generateRuntimeSwappableHeader()
        }
      }
      if Configuration.appExtensionApiOnly {
        stylesheet += generateAppExtensionApplicationHeader()
      }
      if Configuration.extensionsEnabled {
        stylesheet += generateExtensionsHeader()
      }
      if animatorName != nil {
        stylesheet += generateAnimatorHeader()
      }
    }
    
    stylesheet += "/// Entry point for the app stylesheet\n"
    stylesheet += "\(objc)public class \(self.name)\(superclass) {\n\n"
    
    if Configuration.runtimeSwappable {
      let override = superclassName != nil ? "override " : ""
      stylesheet += "\tpublic \(override)class func shared() -> \(self.name) {\n"
      stylesheet += "\t\t struct __ { static let _sharedInstance = \(self.name)() }\n"
      stylesheet += "\t\treturn __._sharedInstance\n"
      stylesheet += "\t}\n"
    }
    for style in styles {
      stylesheet += style.generate()
    }
    if animatorName != nil {
      stylesheet += generateAnimator()
      for animation in animations {
        stylesheet += animation.generate()
      }
      stylesheet += "\t\n\n}"
    }
    stylesheet += "\n}"
    if Configuration.extensionsEnabled {
      stylesheet += generateExtensions()
    }
    if isBaseStylesheet && animatorName != nil {
      stylesheet += generateAnimatorExtension()
    }
    return stylesheet
  }
  
  func generateStylesheetManager() -> String {
    let baseStyleName = Generator.Stylesheets.filter({ $0.superclassName == nil }).first!
    var baseEnumCase = baseStyleName.name.replacingOccurrences(of: "Style", with: "")
    baseEnumCase = baseEnumCase.prefix(1).lowercased() + baseEnumCase.dropFirst()

    var cases = [String: String]()
    for i in 0..<Configuration.stylesheetNames.count {
      var name = Configuration.stylesheetNames[i]
      var enumCase = name.replacingOccurrences(of: "Style", with: "")
      enumCase = enumCase.prefix(1).lowercased() + enumCase.dropFirst()
      if let components = Optional(enumCase.components(separatedBy: ":")), components.count > 1 {
        enumCase = components.first!
        name = name.components(separatedBy: ":").first!
      }
      cases[name] = enumCase
    }
    
    var header = ""
    header += "fileprivate extension UserDefaults {\n"
    header += "\tsubscript<T>(key: String) -> T? {\n"
    header += "\t\tget { return value(forKey: key) as? T }\n"
    header += "\t\tset { set(newValue, forKey: key) }\n"
    header += "\t}\n\n"
    header += "\tsubscript<T: RawRepresentable>(key: String) -> T? {\n"
    header += "\t\tget {\n"
    header += "\t\t\tif let rawValue = value(forKey: key) as? T.RawValue {\n"
    header += "\t\t\t\treturn T(rawValue: rawValue)\n"
    header += "\t\t\t}\n"
    header += "\t\t\treturn nil\n"
    header += "\t\t}\n"
    header += "\t\tset { self[key] = newValue?.rawValue }\n"
    header += "\t}\n"
    header += "}\n\n"
    
    header += "public enum Theme: Int {\n"
    cases.forEach({ header += "\tcase \($1)\n" })
    header += "\n"
    header += "\tpublic var stylesheet: \(baseStyleName.name) {\n"
    header += "\t\tswitch self {\n"
    cases.forEach({ header += "\t\tcase .\($1): return \($0).shared()\n" })
    header += "\t\t}\n"
    header += "\t}\n"
    header += "}\n\n"
    
    header += "public extension Notification.Name {\n"
    header += "\tstatic let didChangeTheme = Notification.Name(\"stylesheet.theme\")\n"
    header += "}\n\n"
  
    header += "public class StylesheetManager {\n"
    header +=
    "\t@objc dynamic public class func stylesheet(_ stylesheet: \(baseStyleName.name)) -> \(baseStyleName.name) {\n"
    header += "\t\treturn StylesheetManager.default.theme.stylesheet\n"
    header += "\t}\n\n"
    header += "\tprivate struct DefaultKeys {\n"
    header += "\t\tstatic let theme = \"theme\"\n"
    header += "\t}\n\n"
    header += "\tpublic static let `default` = StylesheetManager()\n"
    header += "\tpublic static var S: \(baseStyleName.name) {\n"
    header += "\t\treturn StylesheetManager.default.theme.stylesheet\n"
    header += "\t}\n\n"
    header += "\tpublic var theme: Theme {\n"
    header += "\t\tdidSet {\n"
    header += "\t\t\tNotificationCenter.default.post(name: .didChangeTheme, object: theme)\n"
    header += "\t\t\tUserDefaults.standard[DefaultKeys.theme] = theme\n"
    header += "\t\t}\n"
    header += "\t}\n\n"
    header += "\tpublic init() {\n"
    header += "\t\tself.theme = UserDefaults.standard[DefaultKeys.theme] ?? .\(baseEnumCase)\n"
    header += "\t}\n"
    header += "}\n\n"
    return header
  }

  func generateAppExtensionApplicationHeader() -> String {
    var header = ""
    header += "public class Application {\n"
    header +=
      "\t@objc dynamic public class func preferredContentSizeCategory() -> UIContentSizeCategory {\n"
    header += "\t\treturn .large\n"
    header += "\t}\n"
    header += "}\n\n"
    return header
  }
  
  func generateRuntimeSwappableHeader() -> String {
    var header = ""
    header += "public class StylesheetManager {\n"
    header +=
    "\t@objc dynamic public class func stylesheet(_ stylesheet: \(name)) -> \(name) {\n"
    header += "\t\treturn stylesheet\n"
    header += "\t}\n"
    header += "}\n\n"
    return header
  }

  func generateExtensionsHeader() -> String {
    let visibility = "fileprivate"
    let themeHandler = Configuration.runtimeSwappable && Generator.Stylesheets.filter({ $0.superclassName == name }).count > 0
    var header = ""
    header += "\(visibility) var __ApperanceProxyHandle: UInt8 = 0\n"
    if themeHandler {
      header += "\(visibility) var __ThemeAwareHandle: UInt8 = 0\n"
      header += "\(visibility) var __ObservingDidChangeThemeHandle: UInt8 = 0\n\n"
    } else {
      header += "\n"
    }
    header += "/// Your view should conform to 'AppearaceProxyComponent'.\n"
    header += "public protocol AppearaceProxyComponent: class {\n"
    header += "\tassociatedtype ApperanceProxyType\n"
    header += "\tvar appearanceProxy: ApperanceProxyType { get }\n"
    if themeHandler {
      header += "\tvar themeAware: Bool { get set }\n"
    }
    header += "\tfunc didChangeAppearanceProxy()"
    header += "\n}\n\n"
    
    if themeHandler {
      header += "public extension AppearaceProxyComponent {\n"
      header += "\tpublic func initAppearanceProxy(themeAware: Bool = true) {\n"
      header += "\t\tself.themeAware = themeAware\n"
      header += "\t\tdidChangeAppearanceProxy()\n"
      header += "\t}\n"
      header += "}\n\n"
    }
    
    return header
  }
  
  func generateAnimatorHeader() -> String {
    let visibility = "fileprivate"
    var header = ""
    header += "\(visibility) var __AnimatorProxyHandle: UInt8 = 0\n\n"
    header += "/// Your view should conform to 'AnimatorProxyComponent'.\n"
    header += "public protocol AnimatorProxyComponent: class {\n"
    header += "\tassociatedtype AnimatorProxyType\n"
    header += "\tvar \(animatorName!.firstLowercased): AnimatorProxyType { get }\n"
    header += "\n}\n\n"
    
    if superclassName == nil {
      header += "\npublic struct KeyFrame {"
      header += "\n\tvar relativeStartTime: CGFloat?"
      header += "\n\tvar relativeDuration: CGFloat?"
      header += "\n\tvar values: [AnimatableProp]?"
      header += "\n}\n\n"
      
      header += "\npublic enum AnimatableProp {"
      header += "\n\tcase opacity(from: CGFloat?, to: CGFloat)"
      header += "\n\tcase frame(from: CGRect?, to: CGRect)"
      header += "\n\tcase size(from: CGSize?, to: CGSize)"
      header += "\n\tcase width(from: CGFloat?, to: CGFloat)"
      header += "\n\tcase height(from: CGFloat?, to: CGFloat)"
      header += "\n\tcase left(from: CGFloat?, to: CGFloat)"
      header += "\n}\n\n"
      
      header += "\npublic extension AnimatableProp {"
      header += "\n\tfunc applyFrom(to view: UIView) {"
      header += "\n\t\tswitch self {"
      header += "\n\t\tcase .opacity(let from, _):\tif let from = from { view.alpha = from }"
      header += "\n\t\tcase .frame(let from, _):\tif let from = from { view.frame = from }"
      header += "\n\t\tcase .size(let from, _):\tif let from = from { view.bounds.size = from }"
      header += "\n\t\tcase .width(let from, _):\tif let from = from { view.bounds.size.width = from }"
      header += "\n\t\tcase .height(let from, _):\tif let from = from { view.bounds.size.height = from }"
      header += "\n\t\tcase .left(let from, _):\tif let from = from { view.frame.origin.x = from }"
      header += "\n\t\t}"
      header += "\n\t}\n"
      
      header += "\n\tfunc applyTo(to view: UIView) {"
      header += "\n\t\tswitch self {"
      header += "\n\t\tcase .opacity(_, let to):\tview.alpha = to"
      header += "\n\t\tcase .frame(_, let to):\t\tview.frame = to"
      header += "\n\t\tcase .size(_, let to):\t\tview.bounds.size = to"
      header += "\n\t\tcase .width(_, let to):\t\tview.bounds.size.width = to"
      header += "\n\t\tcase .height(_, let to):\tview.bounds.size.height = to"
      header += "\n\t\tcase .left(_, let to):\t\tview.frame.origin.x = to"
      header += "\n\t\t}"
      header += "\n\t}\n"
      header += "\n}\n\n"
    }
    
    return header
  }
  
  func generateExtensions() -> String {
    var extensions = ""
    let themeHandler = Configuration.runtimeSwappable && Generator.Stylesheets.filter({ $0.superclassName == name }).count > 0
    
    for style in styles.filter({ $0.isExtension }) {
      
      if let superclassName = superclassName, let _ = Generator.Stylesheets.filter({ $0.name == superclassName }).first?.styles.filter({ $0.name == style.name }).first {
        continue
      }
      let stylesheetName = Configuration.runtimeSwappable && (style.isNestedOverride || style.isNestedOverridable) ? "StylesheetManager.stylesheet(\(name).shared())" : name
      let visibility = Configuration.publicExtensions ? "public" : ""

      let extendedStylesInBaseStylesheet = styles.filter({ $0.superclassName == style.name })
      var extendedStylesInExtendedStylesheets = [String: [Style]]()
      for extendedStylesheet in Generator.Stylesheets.filter({ $0.superclassName == name }) {
        if let styles = Optional(extendedStylesheet.styles.filter({ $0.superclassName == style.name })), styles.count > 0 {
          extendedStylesInExtendedStylesheets[extendedStylesheet.name] = styles
        }
      }
      
      var statements = [String: [String]]()
      for extendedStyle in extendedStylesInBaseStylesheet {
        var conditions = [String]()
        conditions.append("proxy is \(name).\(extendedStyle.name)AppearanceProxy")
        extendedStylesInExtendedStylesheets.forEach({
          if $1.filter({ $0.name == extendedStyle.name }).count > 0 {
            conditions.append("proxy is \($0).\($0)\(extendedStyle.name)AppearanceProxy")
          }
        })
        statements[extendedStyle.name] = conditions
      }
      
      extensions += "\nextension \(style.name): AppearaceProxyComponent {\n\n"
      extensions +=
        "\t\(visibility) typealias ApperanceProxyType = "
        + "\(name).\(style.name)AppearanceProxy\n"
      extensions += "\t\(visibility) var appearanceProxy: ApperanceProxyType {\n"
      extensions += "\t\tget {\n"
      
      if themeHandler {
        extensions += "\t\t\tif let proxy = objc_getAssociatedObject(self, &__ApperanceProxyHandle) as? ApperanceProxyType {\n"
        extensions += "\t\t\t\tif !themeAware { return proxy }\n\n"
        
        var index = 0
        for (key, value) in statements {
          let prefix = index == 0 ? "\t\t\t\tif " : " else if "
          let condition = value.joined(separator: " || ")
          extensions += "\(prefix)\(condition) {\n"
          extensions += "\t\t\t\t\treturn \(stylesheetName).\(key)\n\t\t\t\t}"
          index += 1
        }
        
        extensions += "\n\t\t\t\treturn proxy\n"
        extensions += "\t\t\t}\n\n"
        extensions += "\t\t\treturn \(stylesheetName).\(style.name)\n"
      } else {
        extensions +=
          "\t\t\tguard let proxy = objc_getAssociatedObject(self, &__ApperanceProxyHandle) "
          + "as? ApperanceProxyType else { return \(stylesheetName).\(style.name) }\n"
        extensions += "\t\t\treturn proxy\n"
      }
      
      extensions += "\t\t}\n"
      extensions += "\t\tset {\n"
      extensions +=
        "\t\t\tobjc_setAssociatedObject(self, &__ApperanceProxyHandle, newValue,"
        + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
      extensions += "\t\t\tdidChangeAppearanceProxy()\n"
      extensions += "\t\t}\n"
      extensions += "\t}\n"
      
      if themeHandler {
        extensions += "\n\t\(visibility) var themeAware: Bool {\n"
        extensions += "\t\tget {\n"
        extensions +=
          "\t\t\tguard let proxy = objc_getAssociatedObject(self, &__ThemeAwareHandle) "
          + "as? Bool else { return true }\n"
        extensions += "\t\t\treturn proxy\n"
        extensions += "\t\t}\n"
        extensions += "\t\tset {\n"
        extensions +=
          "\t\t\tobjc_setAssociatedObject(self, &__ThemeAwareHandle, newValue,"
          + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
        extensions += "\t\t\tisObservingDidChangeTheme = newValue\n"
        extensions += "\t\t}\n"
        extensions += "\t}\n\n"
        
        extensions += "\tfileprivate var isObservingDidChangeTheme: Bool {\n"
        extensions += "\t\tget {\n"
        extensions += "\t\t\tguard let observing = objc_getAssociatedObject(self, &__ObservingDidChangeThemeHandle) as? Bool else { return false }\n"
        extensions += "\t\t\treturn observing\n"
        extensions += "\t\t}\n"
        extensions += "\t\tset {\n"
        extensions += "\t\t\tif newValue == isObservingDidChangeTheme { return }\n"
        extensions += "\t\t\tif newValue {\n"
        extensions +=
          "\t\t\t\tNotificationCenter.default.addObserver(self, selector: #selector(didChangeAppearanceProxy),"
          + " name: Notification.Name.didChangeTheme, object: nil)\n"
        extensions += "\t\t\t} else {\n"
        extensions +=
          "\t\t\t\tNotificationCenter.default.removeObserver(self,"
          + " name: Notification.Name.didChangeTheme, object: nil)\n"
        extensions += "\t\t\t}\n"
        extensions +=
          "\t\t\tobjc_setAssociatedObject(self, &__ObservingDidChangeThemeHandle, newValue,"
          + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
        extensions += "\t\t}\n"
        extensions += "\t}\n"
      }
      extensions += "}\n"
    }
    return extensions
  }
  
  func generateAnimatorExtension() -> String {
    let viewClass = Configuration.targetOsx ? "NSView" : "UIView"
    let visibility = Configuration.publicExtensions ? "public" : ""
    
    let shouldAccessInstance = Configuration.runtimeSwappable && (superclassName == nil && Generator.Stylesheets.filter { (stylesheet) -> Bool in
      guard let superclassName = stylesheet.superclassName, superclassName == self.name, stylesheet.animatorName != nil else { return false }
      return true
      }.count > 0)
    let stylesheetName = shouldAccessInstance ? "StylesheetManager.stylesheet(\(name).shared())" : name
    var extensions = ""
    extensions += "\nextension \(viewClass): AnimatorProxyComponent {\n\n"
    extensions +=
      "\t\(visibility) typealias AnimatorProxyType = "
      + "\(name).\(animatorName!)AnimatorProxy\n"
    extensions += "\t\(visibility) var \(animatorName!.lowercased()): AnimatorProxyType {\n"
    extensions += "\t\tget {\n"
    
    extensions +=
      "\t\t\tguard let a = objc_getAssociatedObject(self, &__AnimatorProxyHandle) "
      + "as? AnimatorProxyType else { return \(stylesheetName).\(animatorName!) }\n"
    extensions += "\t\t\treturn a\n"
    
    extensions += "\t\t}\n"
    extensions += "\t\tset {\n"
    extensions +=
      "\t\t\tobjc_setAssociatedObject(self, &__AnimatorProxyHandle, newValue,"
      + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
    extensions += "\t\t}\n"
    extensions += "\t}\n\n"
    
    for animation in animations {
      let curveProperty = animation.properties.filter({ $0.key == "curve" }).first!
      let durationProperty = animation.properties.filter({ $0.key == "duration" }).first!
      let keyFramesProperty = animation.properties.filter({ $0.key == "keyFrames" }).first!
      let useTimingParameters = curveProperty.rhs!.returnValue().hasPrefix("UITimingCurveProvider")
      let animator = animatorName!.firstLowercased
      let animationReference = "\(animator).\(animation.name)"
      let duration = "\(animationReference).\(durationProperty.key)Property(traitCollection)"
      let curve = "\(animationReference).\(curveProperty.key)Property(traitCollection)"
      
      extensions += "\tpublic func animate\(animation.name.firstUppercased)(with completion: @escaping () -> Void) -> UIViewPropertyAnimator {\n"
      extensions += "\t\tlet duration = TimeInterval(\(duration))\n"
      if useTimingParameters {
        extensions += "\t\tlet propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: \(curve)) \n"
      } else {
        extensions += "\t\tlet propertyAnimator = UIViewPropertyAnimator(duration: duration, curve: \(curve))\n"
      }
      extensions += "\t\tpropertyAnimator.addAnimations { [weak self] in\n"
      extensions += "\t\t\tguard let `self` = self else { return }\n"
      extensions += "\t\t\tlet keyFrames = self.\(animationReference).\(keyFramesProperty.key)Property(self.traitCollection)\n"
      extensions += "\t\t\tfor keyFrame in keyFrames {\n"
      extensions += "\t\t\t\tlet relativeStartTime = Double(keyFrame.relativeStartTime ?? 0.0)\n"
      extensions += "\t\t\t\tlet relativeDuration = Double(keyFrame.relativeDuration ?? CGFloat(duration))\n"
      extensions += "\t\t\t\tkeyFrame.values?.forEach({ $0.applyFrom(to: self) })\n"
      extensions += "\t\t\t\tUIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration) {\n"
      extensions += "\t\t\t\t\tkeyFrame.values?.forEach({ $0.applyTo(to: self) })\n"
      extensions += "\t\t\t\t}\n"
      extensions += "\t\t\t}\n"
      extensions += "\t\t}\n"
      extensions += "\t\treturn propertyAnimator\n"
      extensions += "\t}\n\n"
    }
    
    
    extensions += "}\n"
    

    
    
    return extensions
  }
  
  func generateAnimator() -> String {
    let indentation = "\t"
    var wrapper = indentation
    wrapper += "//MARK: - \(animatorName!)"
    
    let objc = Configuration.objcGeneration ? "@objc " : ""
    let baseStylesheetName = Generator.Stylesheets.filter({ $0.superclassName == nil }).first!.name
    let isOverridable = (superclassName == nil && Generator.Stylesheets.filter { (stylesheet) -> Bool in
      guard let superclassName = stylesheet.superclassName, superclassName == self.name, stylesheet.animatorName != nil else { return false }
      return true
      }.count > 0)
    let isOverride = (superclassName != nil && Generator.Stylesheets.filter { $0.name == superclassName }.count > 0)
    let name = animatorName!
    
    let visibility = isOverridable ? "open" : "public"
    let staticModifier = " static"
    let variableVisibility = "public"
    let styleClass = isOverride ? "\(self.name)\(name)AnimatorProxy" : "\(name)AnimatorProxy"
    
    if isOverride || isOverridable {
      let visibility = isOverridable ? "open" : "public"
      let override = isOverride ? "override " : ""
      let returnClass = isOverride ? "\(baseStylesheetName).\(name)AnimatorProxy" : styleClass
      
      if isOverridable && !isOverride {
        wrapper += "\n\(indentation)public var _\(name): \(styleClass)?"
      }
      
      wrapper +=
      "\n\(indentation)\(override)\(visibility) func \(name)Animator() -> \(returnClass) {"
      wrapper += "\n\(indentation)\tif let override = _\(name) { return override }"
      wrapper += "\n\(indentation)\t\treturn \(styleClass)()"
      wrapper += "\n\(indentation)\t}"
      
      if isOverridable && !isOverride {
        wrapper += "\n\(indentation)\(objc)public var \(name): \(styleClass) {"
        wrapper += "\n\(indentation)\tget { return self.\(name)Animator() }"
        wrapper += "\n\(indentation)\tset { _\(name) = newValue }"
        wrapper += "\n\(indentation)}"
      }
    } else {
      wrapper += "\n\(indentation)\(objc)\(variableVisibility)\(staticModifier) let \(name) = \(name)AnimatorProxy()"
    }
    let superclassDeclaration = isOverride ? ": \(baseStylesheetName).\(name)AnimatorProxy" : ""
    wrapper += "\n\(indentation)\(objc)\(visibility) class \(styleClass)\(superclassDeclaration) {"
    
    if isOverridable {
      wrapper += "\n\(indentation)\tpublic init() {}"
    }
    wrapper += "\n\n"
    return wrapper
  }
}
