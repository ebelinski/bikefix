import SwiftyBeaver

let log: SwiftyBeaver.Type = {
  let log = SwiftyBeaver.self
  let consoleDestination = ConsoleDestination()
  consoleDestination.levelColor.verbose = "📄 "
  consoleDestination.levelColor.debug = "👁 "
  consoleDestination.levelColor.info = "ℹ️ "
  consoleDestination.levelColor.warning = "⚠️ "
  consoleDestination.levelColor.error = "🚨 "
  log.addDestination(consoleDestination)
  return log
}()
