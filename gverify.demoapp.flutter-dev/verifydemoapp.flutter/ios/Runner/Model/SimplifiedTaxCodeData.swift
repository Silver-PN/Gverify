//
//  SimplifiedTaxCodeData.swift
//  Runner
//
//  Created by Nguyễn Hiếu on 14/4/25.
//

public struct SimplifiedTaxCodeData: Encodable {
    let status: String?
    let isTaxCodeValid: Bool
    let taxCode: String?
    let phoneNumber: String?
    let name: String?
    let businessStatus: String?
    let companyAddress: String?
    let companyRepresentative: String?
    let companyRepresentativeId: String?
}
