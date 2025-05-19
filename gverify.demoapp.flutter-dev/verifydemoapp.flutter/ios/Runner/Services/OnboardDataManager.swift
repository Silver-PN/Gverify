import xverifysdk

let ONBOARDDATAMANAGER = OnboardDataManager.shared

class OnboardDataManager: NSObject {
    var mrzKey: String = ""
    var mrzInfo: MRZInfo?
    var eid: Eid?
    var businessType: BusinessType?
    var basicInfomation: BasicInformation? = nil
    var eidFacePath: String = ""
    var cecaVerifyRequest: CecaRequestModel?
    
    var onboardStatus: OnboardStatus = .UNKNOWN
    var currentOnboardFace: String = ""
    
    var faceId = "t"
    var ekycFront = ""
    
    class var shared: OnboardDataManager {
        struct Static {
            static let instance = OnboardDataManager()
        }
        return Static.instance
    }
    
    override init() {
        
    }
    
    func clear() {
        mrzKey = ""
        mrzInfo = nil
        eid = nil
        eidFacePath = ""
        cecaVerifyRequest = nil
        businessType = nil
        //face cccd
        //face center ekyc success
        faceId = ""
        ekycFront = ""
    }
}

enum BusinessType: Int {
    case VERIFY_EID = 0
    case VERIFY_EID_ACTIVE_EKYC = 1
    case VERIFY_EID_SIMPLE_EKYC = 5
    case VERIFY_EID_PASSIVE_EKYC = 6
    case VERIFY_BANK_TRANSFER = 2
    case VERIFY_OCR = 3
    case VERIFY_EKYB = 4

    static func fromString(_ name: String) -> BusinessType? {
        return BusinessType.allCases.first { "\($0)" == name }
    }
}

extension BusinessType: CaseIterable {}

