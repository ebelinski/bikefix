import UIKit

enum DeviceInfo {

  static let identifier: String = {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return (String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)),
                   encoding: .ascii) ?? "").trimmingCharacters(in: .controlCharacters)
  }()

  static let systemName = UIDevice.current.systemName

  static let systemVersion = UIDevice.current.systemVersion

  static let description = """
  Device model: \(identifier)
  \(systemName) version: \(systemVersion)
  """

}
