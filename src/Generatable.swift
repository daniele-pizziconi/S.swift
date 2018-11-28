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

  /// UIEdgeInsets value.
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
    case .redirect: return true
    default: return false
    }
  }

  fileprivate var redirection: String? {
    switch self {
    case .redirect(let r): return r.redirection
    default: return nil
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
    return  .boolean(bool: true)
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
          throw RhsError.internal
        }
      } catch {
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

    } else if let components = argumentsFromString("enum", string: string) {
      assert(components.count == 1, "Not a valid enum. Format: enum(Type.Value)")
      let enumComponents = components.first!.components(separatedBy: ".")
      assert(enumComponents.count == 2, "An enum should be expressed in the form Type.Value")
      return .enum(type: enumComponents[0], name: enumComponents[1])

    } else if let components = argumentsFromString("call", string: string) {
      assert(components.count == 2, "Not a valid enum. Format: enum(Type.Value)")
      let call = components[0].trimmingCharacters(in: CharacterSet.whitespaces)
      let type = components[1].trimmingCharacters(in: CharacterSet.whitespaces)
      return .call(call: call, type: type)
    }

    throw RhsError.malformedRhsValue(error: "Unable to parse rhs value")
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
    case .hash(let hash): for (_, rhs) in hash { return rhs.returnValue() }
    case .call(_, let type): return type
    }
    return "AnyObject"
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

    case .call(let call, _):
      return generateCall(prefix, string: call)

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
    if font.isSystemBoldFont || font.isSystemFont {
      let function = font.isSystemFont ? "systemFont" : "boldSystemFont"
      let weight = font.hasWeight ? ", weight: \(font.weight!)" : ""
      return "\(prefix)\(fontClass).\(function)(ofSize: \(font.fontSize)\(weight))"
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

//MARK: Style

class Style {
  var name: String
  var superclassName: String? = nil
  let properties: [Property]
  var isExtension = false
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
    
    let indentation = isNested ? "\t\t" : "\t"
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
      
      if styleClass == "PrimaryButtoncolorAppearanceProxy" {
//        assert(false, "isNestedOverride: \(isNestedOverride), nestedOverrideName:\(nestedOverrideName), isNestedOverridable: \(isNestedOverridable), nestedSuperclassName: \(nestedSuperclassName)")
        //isNestedOverride: true, nestedOverrideName:Optional("PrimaryButtoncolor"), isNestedOverridable: true, nestedSuperclassName: Optional("ButtonAppearanceProxy.color")
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
  let superclassName: String?

  init(name: String, styles: [Style], superclassName: String? = nil) {

    self.name = name
    self.styles = styles
    self.superclassName = superclassName
  }
  
  fileprivate func prepareGenerator() {
    // Resolve the type for the redirected values.
    styles.forEach({ resolveRedirection($0) })
    // Mark the overrides.
    styles.forEach({ markOverrides($0, superclassName: $0.superclassName) })
    // Mark the overridables.
    let nestedStyles = styles.flatMap{ $0.properties }.flatMap{ $0.style }
    let duplicates = Dictionary(grouping: nestedStyles, by: { $0.name })
      .filter { $1.count > 1 }                 // filter down to only those with multiple contacts
      .sorted { $0.1.count > $1.1.count }
      .flatMap { $0.value }
    for style in duplicates where !style.isNestedOverride {
      style.isNestedOverridable = true
    }
    
    if (superclassName == nil && Generator.Stylesheets.filter { (stylesheet) -> Bool in
      guard let superclassName = stylesheet.superclassName, superclassName == name else { return false }
      return true
      }.count > 0) {
      for style in styles {
        style.isNestedOverridable = true
        style.properties.flatMap({ $0.style }).forEach({ $0.isNestedOverridable = true })
        style.properties.flatMap({ $0.style }).flatMap({ $0.properties }).forEach({ $0.isOverridable = true })
        style.properties.forEach({ $0.isOverridable = true })
      }
    }
  }
  
  fileprivate func resolveRedirection(_ style: Style) {
    for property in style.properties {
      if let rhs = property.rhs, rhs.isRedirect {
        var redirection = rhs.redirection!
        let type = resolveRedirectedType(redirection)
        if Configuration.runtimeSwappable {
          let components = redirection.components(separatedBy: ".")
          var name: String? = nil
          if let _ = styles.filter({ return $0.name == components[0] }).first {
            name = self.name
          } else if let baseStylesheet = Generator.Stylesheets.filter({ $0.name == superclassName }).first {
            name = baseStylesheet.name
          }
          
          if let name = name {
            redirection = "\(name).default.\(redirection)"
          }
        }
        property.rhs = RhsValue.redirect(redirection:
          RhsRedirectValue(redirection: redirection, type: type))
      }
      
      if let nestedStyle = property.style {
        resolveRedirection(nestedStyle)
      }
    }
  }
  
  fileprivate func markOverridables(_ style: Style) {
    guard superclassName != nil else { return }
    
    if let _ = Generator.Stylesheets.filter({ $0.superclassName == nil }).flatMap({ $0.styles }).filter({ $0.name == style.name }).first {
      style.isNestedOverridable = true
      style.properties.forEach({ $0.isOverridable = true })
    }
  }
  
  fileprivate func markOverrides(_ style: Style, superclassName: String?) {

    //check if the style is an override from a generic base stylesheet
    if let baseSuperclassName = self.superclassName, let baseStylesheet = Generator.Stylesheets.filter({ return $0.name == baseSuperclassName }).first {
      if let superStyle = baseStylesheet.styles.filter({ return $0.name == style.name }).first {
        style.isNestedOverride = true
        style.nestedSuperclassName = "\(baseStylesheet.name).\(superStyle.name)"
        style.nestedOverrideName = "\(name)\(style.name)"
        
        for nestedStyle in style.properties.flatMap({ $0.style }) {
          if let superNestedStyle = superStyle.properties.flatMap({ $0.style }).filter({ $0.name == nestedStyle.name }).first {
            nestedStyle.isNestedOverride = true
            nestedStyle.nestedSuperclassName = "\(baseStylesheet.name).\(superStyle.name)AppearanceProxy.\(superNestedStyle.name)"
            nestedStyle.nestedOverrideName = "\(name)\(style.name)"
          }
        }
      }
    }
    
    for property in style.properties {
      if let nestedStyle = property.style {
        let (isOverride, superclassName, styleName) = styleIsOverride(nestedStyle, superStyle: style)
        if let styleName = styleName, let superclassName = superclassName, isOverride, !nestedStyle.isNestedOverride {
          nestedStyle.isNestedOverride = isOverride
          nestedStyle.nestedSuperclassName = superclassName
          nestedStyle.nestedOverrideName = styleName
        }
        markOverrides(nestedStyle, superclassName: nestedStyle.nestedSuperclassName)
      }
      
      property.isOverride = propertyIsOverride(property.key, superclass: superclassName, nestedSuperclassName: style.nestedSuperclassName)
    }
  }
  
  fileprivate func styleIsOverride(_ style: Style, superStyle: Style) -> (isOverride: Bool, superclassName: String?, styleName: String?) {
    guard let _ = superStyle.superclassName else { return (false, nil, nil) }
    let nestedStyles = styles.flatMap{ $0.properties }.filter{
      guard let nestedStyle = $0.style, nestedStyle.name == style.name else { return false }
      return true
    };
    
    for st in styles {
      for property in st.properties {
        if let nestedStyle = property.style, nestedStyle.name == style.name, let superclassName = st.superclassName, nestedStyles.count > 1 {
          return (true, "\(superclassName)AppearanceProxy.\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
        }
      }
    }
    return (false, nil, nil)
  }
  
  // Determines if this property is an override or not.
  fileprivate func propertyIsOverride(_ property: String, superclass: String?, nestedSuperclassName: String?) -> Bool {
    
    if let nestedSuperclassName = nestedSuperclassName, let components = Optional(nestedSuperclassName.components(separatedBy: ".")), components.count > 1, let baseStylesheet = Generator.Stylesheets.filter({ $0.name == components.first }).first {
      if components.count == 2 {
        if let _ = baseStylesheet.styles.filter({ $0.name == components.last }).first?.properties.filter({ return $0.key == property }).first {
          return true
        }
      } else {
        let style = components[1].replacingOccurrences(of: "AppearanceProxy", with: "");
        let nestedStyle = components[2].replacingOccurrences(of: "AppearanceProxy", with: "");
        if let _ = baseStylesheet.styles.filter({ $0.name == style }).first?.properties.flatMap({ $0.style }).filter({ $0.name == nestedStyle }).first?.properties.filter({ return $0.key == property }).first {
          return true
        }
      }
    }
    guard let superclass = superclass else { return false }
    guard let style = self.styles.filter({ return $0.name == superclass }).first else {
      if let components = Optional(superclass.components(separatedBy: ".")), components.count == 2 {
        return true
      }
      return false
    }

    if let _ = style.properties.filter({ return $0.key == property }).first {
      return true
    } else {
      return propertyIsOverride(property, superclass: style.superclassName, nestedSuperclassName: style.nestedSuperclassName)
    }
  }

  // Recursively resolves the return type for this redirected property.
  fileprivate func resolveRedirectedType(_ redirection: String) -> String {

    let components = redirection.components(separatedBy: ".")
    assert(components.count == 2 || components.count == 3, "Redirect \(redirection) invalid")
  
    var style = styles.filter({ return $0.name == components[0] }).first
    if style == nil {
      style = Generator.Stylesheets.filter({ $0.name == superclassName }).first?.styles.filter({ return $0.name == components[0] }).first
    }
    var property: Property
    if components.count == 2 {
      property = style!.properties.filter() { return $0.key == components[1] }.first!
    } else {
      let nestedStyleProperty = style!.properties.filter() { return $0.style?.name == components[1] }.first!.style!
      property = nestedStyleProperty.properties.filter() { return $0.key == components[2] }.first!
    }
    
    if let rhs = property.rhs, rhs.isRedirect {
      return resolveRedirectedType(property.rhs!.redirection!)
    } else {
      return property.rhs!.returnValue()
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
    }
    
    stylesheet += "/// Entry point for the app stylesheet\n"
    stylesheet += "\(objc)public class \(self.name)\(superclass) {\n\n"
    
    if Configuration.runtimeSwappable && isBaseStylesheet {
      stylesheet += "public static let `default` = \(self.name)()\n\n"
    }
    for style in self.styles {
      stylesheet += style.generate()
    }
    stylesheet += "\n}"
    if Configuration.extensionsEnabled {
      stylesheet += self.generateExtensions()
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
    header += "public enum Theme: Int {\n"
    cases.forEach({ header += "\tcase \($1)\n" })
    header += "\n"
    header += "\tpublic var stylesheet: \(baseStyleName.name) {\n"
    header += "\t\tswitch self {\n"
    cases.forEach({ header += "\t\tcase .\($1): return \($0).default\n" })
    header += "\t\t}\n"
    header += "\t}\n"
    header += "}\n"
    
    header += "\n"
  
    header += "public class StylesheetManager {\n"
    header +=
    "\t@objc dynamic public class func stylesheet(_ stylesheet: \(baseStyleName.name)) -> \(baseStyleName.name) {\n"
    header += "\t\treturn StylesheetManager.default.theme.stylesheet\n"
    header += "\t}\n\n"
    header += "\tprivate struct DefaultKeys {\n"
    header += "\t\tstatic let theme = \"theme\"\n"
    header += "\t}\n\n"
    header += "\tpublic static let `default` = StylesheetManager()\n\n"
    header += "\tpublic var theme: Theme {\n"
    header += "\t\tdidSet { UserDefaults.standard[DefaultKeys.theme] = theme }\n"
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
    var header = ""
    header += "\(visibility) var __ApperanceProxyHandle: UInt8 = 0\n\n"
    header += "/// Your view should conform to 'AppearaceProxyComponent'.\n"
    header += "public protocol AppearaceProxyComponent: class {\n"
    header += "\tassociatedtype ApperanceProxyType\n"
    header += "\tvar appearanceProxy: ApperanceProxyType { get }\n"
    header += "\tfunc didChangeAppearanceProxy()"
    header += "\n}\n\n"
    return header
  }

  func generateExtensions() -> String {
    var extensions = ""
    let stylesheetName = Configuration.runtimeSwappable ? "StylesheetManager.stylesheet(\(name).default)" : name
    for style in styles.filter({ $0.isExtension }) {
      
      if let superclassName = superclassName, let _ = Generator.Stylesheets.filter({ $0.name == superclassName }).first?.styles.filter({ $0.name == style.name }).first {
        continue
      }
      let visibility = Configuration.publicExtensions ? "public" : ""

      extensions += "\nextension \(style.name): AppearaceProxyComponent {\n\n"
      extensions +=
        "\t\(visibility) typealias ApperanceProxyType = "
        + "\(name).\(style.name)AppearanceProxy\n"
      extensions += "\t\(visibility) var appearanceProxy: ApperanceProxyType {\n"
      extensions += "\t\tget {\n"
      extensions +=
        "\t\t\tguard let proxy = objc_getAssociatedObject(self, &__ApperanceProxyHandle) "
        + "as? ApperanceProxyType else { return \(stylesheetName).\(style.name) }\n"
      extensions += "\t\t\treturn proxy\n"
      extensions += "\t\t}\n"
      extensions += "\t\tset {\n"
      extensions +=
        "\t\t\tobjc_setAssociatedObject(self, &__ApperanceProxyHandle, newValue,"
        + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
      extensions += "\t\t\tdidChangeAppearanceProxy()\n"
      extensions += "\t\t}\n"
      extensions += "\t}\n"
      extensions += "}\n"
    }
    return extensions
  }
}


