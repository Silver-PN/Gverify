package com.example.xverifydemoapp.extentions

import android.graphics.Bitmap
import com.example.xverifydemoapp.utils.ONBOARDDATAMANAGER
import com.google.gson.Gson

import vn.jth.xverifysdk.data.PersonOptionalDetails
import vn.jth.xverifysdk.jmrtd.VerificationStatus
import java.io.ByteArrayOutputStream


fun PersonOptionalDetails.toMap(): Map<String, Any?> {
    return mapOf(
        "eidNumber" to eidNumber,
        "fullName" to fullName,
        "dateOfBirth" to dateOfBirth,
        "gender" to gender,
        "nationality" to nationality,
        "ethnicity" to ethnicity,
        "religion" to religion,
        "placeOfOrigin" to placeOfOrigin,
        "placeOfResidence" to placeOfResidence,
        "personalIdentification" to personalIdentification,
        "dateOfIssue" to dateOfIssue,
        "dateOfExpiry" to dateOfExpiry,
        "fatherName" to fatherName,
        "motherName" to motherName,
        "spouseName" to spouseName,
        "oldEidNumber" to oldEidNumber,
        "unkIdNumber" to unkIdNumber,
        "unkInfo" to unkInfo,
    )
}

fun getResultVerifyBioWithRar():Map<String,Any>{
    return mapOf(
        "personOptionalDetails" to getPersonOptionalDetails(),
        "verificationStatus" to getVerificationStatus(),
        "faceImage" to ONBOARDDATAMANAGER.referenceFaceImagePath.toString()
    )
}

fun getResultVerifyEid(): Map<String, Any> {
    val personDetails = getPersonOptionalDetails() ?: ""
    val cardType = ONBOARDDATAMANAGER.eid?.getCardType().toString() ?: ""
    val verificationStatus = getVerificationStatus() ?: ""
    val faceImage = ONBOARDDATAMANAGER.referenceFaceImagePath?.toString() ?: ""

    return mapOf(
        "personOptionalDetails" to personDetails,
        "cardType" to cardType,
        "verificationStatus" to verificationStatus,
        "faceImage" to faceImage
    )
}


fun getResultEkyc():Map<String, Any>{
    return mapOf(
        "personOptionalDetails" to getPersonOptionalDetails(),
        "verificationStatus" to getVerificationStatus(),
        "faceImage" to ONBOARDDATAMANAGER.referenceFaceImagePath.toString(),
        "liveFace" to ONBOARDDATAMANAGER.onboardingFaceImagePath.toString()
    )
}


private fun convertFaceToByte(face: Bitmap?):ByteArray{
    val byteArrayOutputStream = ByteArrayOutputStream()
    face?.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream)
    val bytes = byteArrayOutputStream.toByteArray()
    return bytes;
}

fun getPersonOptionalDetails():String{
    val dg13 = ONBOARDDATAMANAGER.eid?.personOptionalDetails
    return Gson().toJson(dg13)
}

private fun getVerificationStatus():String{
    val map = mutableMapOf<String,Boolean>()
    map["chipAuthenticationStatus"] = ONBOARDDATAMANAGER.eid?.chipAuthenticationStatus == VerificationStatus.Verdict.SUCCEEDED
    map["passiveAuthenticationStatus"] = ONBOARDDATAMANAGER.eid?.passiveAuthenticationStatus == VerificationStatus.Verdict.SUCCEEDED
    map["activeAuthenticationStatus"] = ONBOARDDATAMANAGER.eid?.activeAuthenticationStatus == VerificationStatus.Verdict.SUCCEEDED
    map["isValidIdCard"] = ONBOARDDATAMANAGER.isValidIdCard

    return Gson().toJson(map)
}
