package com.example.xverifydemoapp.models

import java.io.Serializable

class VerifyTaxCode : Serializable {
    var status:String?=null
    var isTaxCodeValid:Boolean = false
    var taxCode:String?=null
    var phoneNumber:String?=null
    var name:String?=null
    var businessStatus:String?=null
    var companyAddress:String?=null
    var companyRepresentativeId:String?=null
    var companyRepresentative:String?=null
    override fun toString(): String {
        return "VerifyTaxCode(taxCode=$taxCode, phoneNumber=$phoneNumber, name=$name, businessStatus=$businessStatus, companyAddress=$companyAddress, companyRepresentativeId=$companyRepresentativeId, companyRepresentative=$companyRepresentative)"
    }

}