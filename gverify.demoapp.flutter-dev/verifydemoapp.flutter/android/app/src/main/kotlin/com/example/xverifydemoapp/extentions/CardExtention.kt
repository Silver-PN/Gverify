package com.example.xverifydemoapp.extentions

import org.jmrtd.lds.icao.MRZInfo
import vn.jth.xverifysdk.data.BasicInformation

fun MRZInfo.toMap(): Map<String, Any> {
    return mapOf(
        "documentNumber" to documentNumber,
        "dateOfBirth" to dateOfBirth,
        "dateOfExpiry" to dateOfExpiry
    )
}

fun BasicInformation.toMap(): Map<String, String?> {
    return mapOf(
        "eidNumber" to eidNumber,
        "oldEidNumber" to oldEidNumber,
        "fullName" to fullName,
        "dateOfBirth" to dateOfBirth,
        "gender" to gender,
        "placeOfResidence" to placeOfResidence,
        "dateOfIssue" to dateOfIssue,
        "fatherName" to fatherName,
        "motherName" to motherName,
    )
}