//
//  SimplifiedDocumentData.swift
//  Runner
//
//  Created by Nguyễn Hiếu on 14/4/25.
//

public struct SimplifiedDocumentData: Encodable {
    let typeDocument: String?
    let businessName: String?
    let representativeModel: RepresentativeData?
    let textType: String?
    let address: String?
    let placeOfIssue: String?
    let signer: String?
    let taxcode: String?
    let phoneNumber: String?

    struct RepresentativeData: Encodable {
        let nationality: String?
        let ethnicity: String?
        let gender: String?
        let name: String?
        let position: String?
        let permanentResidence: String?
        let id: String?
        let dob: String?
        let idType: String?
        let address: String?
        let documentPlaceOfIssue: String?
        let documentIssueDate: String?
    }
}
