//
//  EncodableQRCodeInfo.swift
//  Runner
//
//  Created by Nguyễn Hiếu on 22/11/24.
//

import xverifysdk

struct EncodableQRCodeInfo: Encodable {
    let basicInfomation: BasicInformation

    private enum CodingKeys: String, CodingKey {
        case eidNumber
        case oldEidNumber
        case fullName
        case dateOfBirth
        case gender
        case placeOfResidence
        case dateOfIssue
        case fatherName
        case motherName
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(basicInfomation.eidNumber, forKey: .eidNumber)
        try container.encode(basicInfomation.oldEidNumber, forKey: .oldEidNumber)
        try container.encode(basicInfomation.fullName, forKey: .fullName)
        try container.encode(basicInfomation.dateOfBirth, forKey: .dateOfBirth)
        try container.encode(basicInfomation.gender, forKey: .gender)
        try container.encode(basicInfomation.placeOfResidence, forKey: .placeOfResidence)
        try container.encode(basicInfomation.dateOfIssue, forKey: .dateOfIssue)
        try container.encode(basicInfomation.fatherName, forKey: .fatherName)
        try container.encode(basicInfomation.motherName, forKey: .motherName)
    }
}
