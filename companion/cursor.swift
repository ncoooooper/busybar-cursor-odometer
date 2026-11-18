import Foundation
import CoreGraphics

// Sample cursor coordinates in memory. Store only total screen millimeters by day.
guard CommandLine.arguments.count >= 2 else {
    fputs("usage: swift cursor.swift TOTALS.json [calibrated_mm_per_point]\n", stderr)
    exit(2)
}
let file = URL(fileURLWithPath: NSString(string: CommandLine.arguments[1]).expandingTildeInPath)
let override = CommandLine.arguments.count > 2 ? Double(CommandLine.arguments[2]) : nil
if let scale = override, !(scale > 0 && scale < 10) { exit(2) }
let formatter = DateFormatter()
formatter.calendar = Calendar(identifier: .gregorian)
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = .current
formatter.dateFormat = "yyyy-MM-dd"
var totals = ((try? Data(contentsOf: file)).flatMap { try? JSONDecoder().decode([String:Double].self, from: $0) }) ?? [:]
var previous: (point:CGPoint, id:CGDirectDisplayID, time:TimeInterval, day:String)?
var lastSave = Date.distantPast
func save() {
    if let data = try? JSONEncoder().encode(totals) {
        do { try data.write(to: file,options:.atomic) }
        catch { fputs("Cannot write daily totals\n",stderr) }
    }
}
let timer = Timer.scheduledTimer(withTimeInterval:0.1,repeats:true) { _ in
    guard let point=CGEvent(source:nil)?.location else {previous=nil; return}
    var id=CGDirectDisplayID(0), found=UInt32(0)
    guard CGGetDisplaysWithPoint(point,1,&id,&found) == .success,found == 1 else {previous=nil;return}
    let now=Date(), day=formatter.string(from:now), time=ProcessInfo.processInfo.systemUptime
    if let old=previous, old.id==id,old.day==day,time-old.time < 0.5 {
        let box=CGDisplayBounds(id), physical=CGDisplayScreenSize(id)
        let sx=override ?? (physical.width/max(1,box.width)), sy=override ?? (physical.height/max(1,box.height))
        if sx>0 && sy>0 {
            totals[day,default:0] += hypot((point.x-old.point.x)*sx,(point.y-old.point.y)*sy)
        }
    }
    previous=(point,id,time,day)
    if now.timeIntervalSince(lastSave)>=2 {save();lastSave=now}
}
RunLoop.current.run()
