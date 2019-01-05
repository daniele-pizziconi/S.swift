import Foundation

func search(basePath: String = ".", fileExtension: String) -> [String] {
  let args = [String](CommandLine.arguments)
  let task = Process()
  task.launchPath = "/usr/bin/find"
  task.arguments = ["\(args[1])", "\"*.\(fileExtension)\""]
  let pipe = Pipe()
  task.standardOutput = pipe
  task.standardError = nil
  task.launch()

  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output: String = String(data: data, encoding: String.Encoding.utf8)!
  let files = output.components(separatedBy: "\n").filter() {
    return $0.hasSuffix(".\(fileExtension)")
  }
  return files
}

func search(basePath: String = ".") -> [String] {
  return
      search(basePath: basePath, fileExtension: "yaml")
      + search(basePath: basePath, fileExtension: "yml")
}

func rm(file: String) {
  let task = Process()
  task.launchPath = "/bin/rm"
  task.arguments = [file]
  let pipe = Pipe()
  task.standardOutput = pipe;
  task.launch()
}

func touch(file: String) {
  let task = Process()
  task.launchPath = "/usr/bin/touch"
  task.arguments = [file]
  let pipe = Pipe()
  task.standardOutput = pipe;
  task.launch()
}

func destination(file: String) -> String {
  var c = file.components(separatedBy: "/")
  var fnc = (c.last!).components(separatedBy: ".")
  fnc.removeLast()
  fnc.append("generated")
  fnc.append("swift")
  let f = fnc.joined(separator: ".")
  c.removeLast()
  c.append(f)
  let p = c.joined(separator: "/")
  return p
}

func generate(files: [String]) {
  var urls = [URL]()
  for file in files {
    let url = URL(fileURLWithPath: file)
    if url.absoluteString.contains(".swiftlint.yml") || url.absoluteString.hasPrefix(".") {
      continue
    }
    urls.append(url)
  }
  
  let generator = try! Generator(urls: urls)
  let payloads = generator.generate()
  for i in 0..<payloads.count {
    let payload = payloads[i]
    let file = files[i]
    let dest = destination(file: file)
    rm(file: dest)
    //touch(dest)
    sleep(1)
    try! payload.write(toFile: dest, atomically: true, encoding: String.Encoding.utf8)
    print("\(dest) generated.")
  }
}

var args = [String](CommandLine.arguments)
if args.count == 1 {
  print("\n")
  print("usage: sgen PROJECT_PATH (--file FILENAME) --name STYLESHEET_NAME (--platform ios|osx) (--appearance_proxy internal|public) (--app_extension) (--objc) --import FRAMEWORKS (--runtime_swappable (STYLESHEET_MANAGER_MANE)")
  print("--file: If you're targetting one single file.")
  print("--name: The default is S.")
  print("--platform: use the **platform** argument to target the desired platform. The default one is **ios**")
  print("--appearance_proxy: Creates appearance proxy extensions for the views that have a style defined with the __appearance_proxy__ prefix.")
  print("--app_extensions: Generates a stylesheet with only apis allowed in the app extensions.")
  print("--objc: Generates **Swift** code that is interoperable with **Objective C**")
  print("\n")
  print("If you wish to **update** the generator, copy and paste this in your terminal:")
  print("curl \"https://raw.githubusercontent.com/alexdrone/S/master/sgen\" > sgen && mv sgen /usr/local/bin/sgen && chmod +x /usr/local/bin/sgen\n\n")
  exit(1)
}

// Configuration.
if args.contains("--objc") {
  Configuration.objcGeneration = true
}
if args.contains("--app_extension") {
  Configuration.appExtensionApiOnly = true
}
if args.contains("--appearance_proxy") {
  Configuration.extensionsEnabled = true
}
if args.contains("--public") {
  Configuration.publicExtensions = true
}
if args.contains("--platform") && args.contains("osx") {
  Configuration.targetOsx = true
}
if args.contains("--file") {
  if let idx = args.index(of: "--file") {
    Configuration.files = [args[idx+1]]
  }
}
if args.contains("--files") {
    if var idx = args.index(of: "--files") {
        while !args[idx+1].starts(with: "--") && idx < args.count {
            Configuration.files.append(args[idx+1])
            idx = idx.advanced(by: 1)
        }
    }
}
if args.contains("--name") {
  if let idx = args.index(of: "--name") {
    Configuration.stylesheetNames = [args[idx+1]]
  }
}
if args.contains("--names") {
    if var idx = args.index(of: "--names") {
        Configuration.stylesheetNames = []
        while !args[idx+1].starts(with: "--") && idx < args.count {
            Configuration.stylesheetNames.append(args[idx+1])
            idx = idx.advanced(by: 1)
        }
    }
}
if args.contains("--import") {
  if let idx = args.index(of: "--import") {
    Configuration.importFrameworks = args[idx+1]
  }
}

if args.contains("--importNames") {
  if var idx = args.index(of: "--importNames") {
    Configuration.importStylesheetNames = []
    while !args[idx+1].starts(with: "--") && idx < args.count {
      Configuration.importStylesheetNames.append(args[idx+1])
      idx = idx.advanced(by: 1)
    }
  }
}

if args.contains("--runtime_swappable") {
  if let idx = args.index(of: "--runtime_swappable") {
    Configuration.runtimeSwappable = true
    Configuration.stylesheetManagerName = args[idx+1]
  }
}

if args.contains("--importManager") {
  if let idx = args.index(of: "--importManager") {
    Configuration.importStylesheetManagerName = args[idx+1]
  }
}

let path = args[1]
let files = search(basePath: path)
var filesToGenerate = [String]()

if Configuration.files.count == 0 {
  for file in files {
    filesToGenerate.append(file)
  }
} else {
  for target in Configuration.files {
    if let file = files.filter({ $0.hasSuffix(target) }).first {
      filesToGenerate.append(file)
    }
  }
}
generate(files: filesToGenerate)
