import Foundation
import xverifysdk

struct EncodablePersonOptionalDetails: Encodable {
    let detail: PersonOptionalDetails

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(detail.eidNumber, forKey: .eidNumber)
        try container.encode(detail.fullName, forKey: .fullName)
        try container.encode(detail.dateOfBirth, forKey: .dateOfBirth)
        try container.encode(detail.gender, forKey: .gender)
        try container.encode(detail.nationality, forKey: .nationality)
        try container.encode(detail.ethnicity, forKey: .ethnicity)
        try container.encode(detail.religion, forKey: .religion)
        try container.encode(detail.placeOfOrigin, forKey: .placeOfOrigin)
        try container.encode(detail.placeOfResidence, forKey: .placeOfResidence)
        try container.encode(detail.personalIdentification, forKey: .personalIdentification)
        try container.encode(detail.dateOfIssue, forKey: .dateOfIssue)
        try container.encode(detail.dateOfExpiry, forKey: .dateOfExpiry)
        try container.encode(detail.fatherName, forKey: .fatherName)
        try container.encode(detail.motherName, forKey: .motherName)
        try container.encode(detail.spouseName, forKey: .spouseName)
        try container.encode(detail.oldEidNumber, forKey: .oldEidNumber)
        try container.encode(detail.unkIdNumber, forKey: .unkIdNumber)
        try container.encode(detail.unkInfo, forKey: .unkInfo)
    }
    
    private enum CodingKeys: String, CodingKey {
        case eidNumber
        case fullName
        case dateOfBirth
        case gender
        case nationality
        case ethnicity
        case religion
        case placeOfOrigin
        case placeOfResidence
        case personalIdentification
        case dateOfIssue
        case dateOfExpiry
        case fatherName
        case motherName
        case spouseName
        case oldEidNumber
        case unkIdNumber
        case unkInfo
    }
}

struct EncodableVerificationStatuss: Encodable {
    let eid: Eid
    let isValidIdCard: Bool

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eid.chipAuthenticationStatus == .success, forKey: .chipAuthenticationStatus)
        try container.encode(eid.passiveAuthenticationStatus == .success, forKey: .passiveAuthenticationStatus)
        try container.encode(eid.activeAuthenticationStatus == .success, forKey: .activeAuthenticationStatus)
        try container.encode(isValidIdCard, forKey: .isValidIdCard)
    }
    
    private enum CodingKeys: String, CodingKey {
        case chipAuthenticationStatus
        case passiveAuthenticationStatus
        case activeAuthenticationStatus
        case isValidIdCard
    }
}
