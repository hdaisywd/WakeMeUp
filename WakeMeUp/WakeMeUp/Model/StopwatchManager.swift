import Foundation

class stopwatchData {
    static let shared = stopwatchData()
    
    private let userdata = UserDefaults.standard
    var firstRunning = false
    var isRunning = false
    
    var startTime: Date?
    var startLap: Date?
    
    var durationTime:TimeInterval?
    var lapDurationTime:TimeInterval?
    
    var lapInts: [Int] = []
    var lapCounter: Int = 1
    
    var timeInt = 0
    var lapInt = 0
    
    private init() {}
    
    // MARK: - SETUP DATA
    
    func saveLaps() {
        userdata.set(self.lapInts, forKey: "lapInts")
        userdata.set(self.lapCounter, forKey: "lapCounter")
    }
    
    func readLaps() {
        guard let ints = userdata.array(forKey: "lapInts") as? [Int] else { return }
        self.lapInts = ints
        self.lapCounter = userdata.integer(forKey: "lapCounter")
    }
    
    func saveData() {
        userdata.set(self.firstRunning, forKey: "firstRunning")
        userdata.set(self.isRunning, forKey: "isRunning")
        userdata.set(self.startTime, forKey: "startTime")
        userdata.set(self.startLap, forKey: "startLap")
        userdata.set(self.durationTime, forKey: "durationTime")
        userdata.set(self.lapDurationTime, forKey: "lapDurationTime")
        userdata.set(self.timeInt, forKey: "timeInt")
        userdata.set(self.lapInt, forKey: "lapInt")
    }
    
    func readData() {
        self.firstRunning = userdata.bool(forKey: "firstRunning")
        self.isRunning = userdata.bool(forKey: "isRunning")
        self.startTime = userdata.object(forKey: "startTime") as? Date
        self.startLap = userdata.object(forKey: "startLap") as? Date
        self.durationTime = userdata.double(forKey: "durationTime")
        self.lapDurationTime = userdata.double(forKey: "lapDurationTime")
        self.timeInt = userdata.integer(forKey: "timeInt")
        self.lapInt = userdata.integer(forKey: "lapInt")
    }
    
    func resetData() {
        self.firstRunning = false
        self.durationTime = nil
        self.lapDurationTime = nil
        self.lapInts = []
        self.lapCounter = 1
    }
}
