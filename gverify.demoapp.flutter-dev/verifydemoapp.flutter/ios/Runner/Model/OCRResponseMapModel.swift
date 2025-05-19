import Foundation
import xverifysdk

public struct OCRResponseMapModel: Codable {
    public let transactionCode: String
    public let fullName: String
    public let surName: String
    public let givenName: String
    public let personNumber: String
    public let dateOfExpiry: String
    public let gender: String
    public let placeOfResidence: String
    public let issuedDate: String
    public let nationality: String
    public let dateOfBirth: String
    public let frontType: CardType
    public let frontValid: Bool
    public let backType: CardType
    public let backValid: Bool
    public let identificationSign: String
    public let issuedAt: String
    public let passportNumber: String
    
    public init(from model: OCRResponseModel) {
        transactionCode = model.transactionCode
        fullName = model.fullName
        surName = model.surName
        givenName = model.givenName
        personNumber = model.personNumber
        dateOfExpiry = model.dateOfExpiry
        gender = model.gender
        placeOfResidence = model.placeOfResidence
        issuedDate = model.dateOfIssue
        nationality = model.nationality
        dateOfBirth = model.dateOfBirth
        frontType = model.frontType
        frontValid = model.frontValid
        backType = model.backType
        backValid = model.backValid
        identificationSign = model.identificationSign
        issuedAt = model.issuedAt
        passportNumber = model.passportNumber
    }
}
