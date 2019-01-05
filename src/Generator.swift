import Foundation

public struct Configuration {
  public static var objcGeneration = false
  public static var extensionsEnabled: Bool = false
  public static var publicExtensions: Bool = true
  public static var appExtensionApiOnly = false
  public static var targetOsx = false
  public static var runtimeSwappable = false
  public static var files: [String] = []
  public static var importFrameworks: String?
  public static var stylesheetNames: [String] = ["S"]
  public static var stylesheetManagerName: String?
  public static var importStylesheetManagerName: String?
  public static var importStylesheetNames: [String] = ["S"]
}

public enum GeneratorError: Error {
  case fileDoesNotExist(error: String)
  case malformedYaml(error: String)
  case illegalYamlScalarValue(error: String)
}

public protocol Generatable {
    func generate(_ isNested: Bool) -> String
    func generate() -> [String]
}

extension Generatable {
  public func generate(_ isNested: Bool) -> String {
    return ""
  }
  public func generate() -> [String] {
    return []
  }
}

public struct Generator: Generatable  {

  static var Stylesheets = [Stylesheet]()
  
  /// Initialise the Generator with some YAML payload.
  public init(urls: [URL]) throws {

    for i in 0..<urls.count {
      let url = urls[i]
      // Attemps to load the file at the given url.
      var string = ""
      do {
        string = try String(contentsOf: url)
        string = string.replacingOccurrences(of: "@", with: "__")
      } catch {
        throw GeneratorError.fileDoesNotExist(error: "File \(url) not found.")
      }
      string = preprocessInput(string)
      guard let yaml = try? Yaml.load(string) else {
        throw GeneratorError.malformedYaml(error: "Unable to load Yaml file. \(string)")
      }
      // All of the styles define in the file.
      var styles = [Style]()
      if case .null = yaml {
        throw GeneratorError.malformedYaml(error: "Null root object.")
      }
      
      guard case let .dictionary(main) = yaml else {
        throw GeneratorError.malformedYaml(error: "The root object is not a dictionary.")
      }
      
      var name = Configuration.stylesheetNames[i]
      var superclassName: String? = nil
      let components = name.components(separatedBy: ":")
      if components.count == 2 {
        name = components[0]
        superclassName = components[1]
      }
      
      //filter the styles from the animations
      let mainStyles = main.filter({ !($0.key.string?.hasPrefix("__animator") ?? false) })
      for (key, values) in mainStyles {
        guard let valuesDictionary = values.dictionary, let keyString = key.string else {
          throw GeneratorError.malformedYaml(error: "Malformed style definition: \(key).")
        }
        let properties = try createProperties(valuesDictionary)
        for property in properties where property.style != nil {
          property.style?.belongsToStylesheetName = name
        }
        let style = Style(name: keyString, properties: properties)
        style.belongsToStylesheetName = name
        styles.append(style)
      }
      
      // All of the styles define in the file.
      var animations = [Style]()
      
      //filter the animations from the styles
      let animatorDict = main.filter({ $0.key.string?.hasPrefix("__animator") ?? false }).first
      let animatorName = animatorDict?.key.string?.replacingOccurrences(of: "__animator", with: "").trimmingCharacters(in: CharacterSet.whitespaces)
      if let animator = animatorDict?.value {
        guard case let .dictionary(mainAnimations) = animator else {
          throw GeneratorError.malformedYaml(error: "The root object is not a dictionary.")
        }
        for (key, values) in mainAnimations {
          guard let valuesDictionary = values.dictionary, let keyString = key.string else {
            throw GeneratorError.malformedYaml(error: "Malformed animation definition: \(key). Animator: \(animator), animatorDict: \(String(describing: animatorDict)), mainStyles: \(mainStyles), yaml: \(yaml)")
          }
          let style = Style(name: keyString, properties: try createProperties(valuesDictionary))
          style.belongsToStylesheetName = name
          style.isAnimation = true
          animations.append(style)
        }
      }

      Generator.Stylesheets.append(Stylesheet(name: name, styles: styles, animations: animations, superclassName: superclassName, animatorName: animatorName))
    }
  }

  /// Returns the swift code for this item.
  func generate(_ nested: Bool = false) -> [String] {
    var generatedStrings = [String]()
    for stylesheet in Generator.Stylesheets {
      generatedStrings.append(stylesheet.generate())
    }
    return generatedStrings
  }
  
  private func createProperties(_ dictionary: [Yaml: Yaml]) throws -> [Property] {
    var properties = [Property]()
    
    for (yamlKey, yamlValue) in dictionary {
      if let key = yamlKey.string {
        properties.append(try property(with: key, yamlValue: yamlValue))
      }
    }
    return properties
  }
  
  
  private func property(with key: String, yamlValue: Yaml) throws -> Property {
    do {
      var style: Style? = nil
      var rhsValue: RhsValue? = nil
      switch yamlValue {
      case .array(let array):
        
        let flattenedDictionary = array.map({ (value) -> [Yaml: Yaml]? in
          return value.dictionary
        }).reduce([Yaml: Yaml](), { (dict, tuple) -> [Yaml: Yaml] in
          var nextDict = dict
          if let tuple = tuple {
            for (key,value) in tuple {
              nextDict.updateValue(value, forKey:key)
            }
          }
          return nextDict
        })
        if flattenedDictionary.count > 0 {
          style = Style(name: key, properties: try createProperties(flattenedDictionary))
        } else {
          rhsValue = try RhsValue.valueFrom(array)
        }
      case .dictionary(let dictionary): rhsValue = try RhsValue.valueFrom(dictionary)
      case .bool(let boolean): rhsValue = RhsValue.valueFrom(boolean)
      case .double(let double): rhsValue = RhsValue.valueFrom(Float(double))
      case .int(let integer): rhsValue = RhsValue.valueFrom(Float(integer))
      case .string(let string): rhsValue = try RhsValue.valueFrom(string)
      default:
        throw GeneratorError.illegalYamlScalarValue(
          error: "\(yamlValue) not supported as right-hand side value")
      }
      let property = Property(key: key, rhs: rhsValue, style: style)
      return property
    } catch {
      throw GeneratorError.illegalYamlScalarValue(error: "\(yamlValue) is not parsable")
    }
  }
  
}
