import Foundation

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
    var firstLowercased: String {
        guard let first = first else { return "" }
        return String(first).lowercased() + dropFirst()
    }
}

extension String {
    func indices(of string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
}

/// Returns the arguments strings from a rule string
/// e.g. font("Comic Sans", 12) -> ["Comic Sans", "12"]
func argumentsFromString(_ key: String, string: String) -> [String]? {
    let input = string.replacingOccurrences(of: key.firstCapitalized, with: key);
    if !input.hasPrefix(key) {
        return nil
    }
    // Remove the parenthesis.
    var parsableString = input.replacingOccurrences(of: "\(key)(", with: "")
    if let index = parsableString.lastIndex(of: ")") {
        parsableString.remove(at: index)
    }
//    parsableString = parsableString.replacingOccurrences(of: ")", with: "")
    return parsableString.components(separatedBy: ",")
}

func escape(_ key: String, string: String) -> String {
    var input = string.trimmingCharacters(in: CharacterSet.whitespaces)
    input = input.replacingOccurrences(of: " ", with: "")
    return input.replacingOccurrences(of: "\(key):", with: "")
}

func argumentFromArray(_ key: String, string: String) -> String? {
    let input = string.replacingOccurrences(of: key.firstCapitalized, with: key);
    if !input.hasPrefix(key) {
        return nil
    }
    // Remove the parenthesis.
    var parsableString = input.replacingOccurrences(of: "\(key)(", with: "")
    if let index = parsableString.lastIndex(of: ")") {
        parsableString.remove(at: index)
    }
    return parsableString
}

/// Parse a number from a string.
func parseNumber(_ string: String) -> Float {
    var input = string.trimmingCharacters(in: CharacterSet.whitespaces)
    input = (input as NSString).replacingOccurrences(of: "\"", with: "")
    
    input = input.replacingOccurrences(of: "-", with: "")
    input = input.replacingOccurrences(of: "\"", with: "")
    let scanner = Scanner(string: input)
    let sign: Float = string.contains("-") ? -1 : 1
    var numberBuffer: Float = 0
    if scanner.scanFloat(&numberBuffer) {
        return numberBuffer * sign;
    }
    return 0
}

/// Additional preprocessing for the string.
func preprocessInput(_ string: String) -> String {
    var result = string.replacingOccurrences(of: "#", with: "color(");
    result = result.replacingOccurrences(of: "$", with: "redirect(");
    
    var pattern = "animationValues:\\s+(.*?)\\}]"
    var formatter = try! NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
    var matches = formatter.matches(in: result, options: [], range: NSRange(location: 0, length: result.count))
    var formattedResult = result
    for match in matches {
        let template = "animationValues: $1}]"
        let replacement = formatter.replacementString(for: match, in: result, offset: 0, template: template)
        var newReplacement = replacement.replacingOccurrences(of: "{", with: "animationValue(")
        newReplacement = newReplacement.replacingOccurrences(of: "}", with: ")")
        formattedResult = formattedResult.replacingOccurrences(of: replacement, with: newReplacement)
    }
    result = formattedResult
    
    pattern = "keyFrames:\\s+(.*?)]\n"
    formatter = try! NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
    matches = formatter.matches(in: result, options: [], range: NSRange(location: 0, length: result.count))
    formattedResult = result
    for match in matches {
        let template = "keyFrames: $1]\n"
//        let template = "keyFrames: $1\n"
        let replacement = formatter.replacementString(for: match, in: result, offset: 0, template: template)
        var newReplacement = replacement.replacingOccurrences(of: "{", with: "\"keyFrame(")
        newReplacement = newReplacement.replacingOccurrences(of: "}", with: ")\"")
        formattedResult = formattedResult.replacingOccurrences(of: replacement, with: newReplacement)
    }
    return formattedResult
}

