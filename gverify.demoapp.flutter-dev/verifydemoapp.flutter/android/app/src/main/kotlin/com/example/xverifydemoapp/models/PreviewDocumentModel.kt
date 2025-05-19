package com.example.xverifydemoapp.models

import com.google.gson.annotations.SerializedName
import vn.jth.xverifysdk.data.DocumentType
import java.io.Serializable

class PreviewDocumentModel : Serializable{
    var typeDocument:String?=null
    var businessName:String?=null
    var representativeModel:RepresentativeModel?=null
    var textType:String?=null
    var address:String?=null
    var placeOfIssue:String?=null
    var signer:String?=null
    var taxcode:String?=null
    var phoneNumber:String ?=null

    override fun toString(): String {
        return "PreviewDocumentModel(typeDocument=$typeDocument, businessName=$businessName, representativeModel=$representativeModel, textType=$textType, address=$address, placeOfIssue=$placeOfIssue, signer=$signer, taxcode=$taxcode)"
    }


}

class RepresentativeModel : Serializable{
    var eId:String?=null
    var fullName:String?=null
    var dateOfBirth:String?=null
    var dateOfIssue:String?=null
    var address:String?=null
    var nationality:String?=null
    var ethnicity:String?=null
    var gender:String?=null

    override fun toString(): String {
        return "RepresentativeModel(eId=$eId, fullName=$fullName, dateOfBirth=$dateOfBirth, dateOfIssue=$dateOfIssue, address=$address, nationality=$nationality, ethnicity=$ethnicity)"
    }
}