import xverifysdk

struct EncodableMRZInfo: Encodable {
    let mrzInfo: MRZInfo

    private enum CodingKeys: String, CodingKey {
        case dateOfBirth
        case dateOfExpiry
        case documentNumber
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mrzInfo.documentNumber, forKey: .documentNumber)
        try container.encode(mrzInfo.dateOfBirth, forKey: .dateOfBirth)
        try container.encode(mrzInfo.dateOfExpiry, forKey: .dateOfExpiry)
    }
}

