package com.example.xverifydemoapp.utils

enum class BusinessType(val type: Int) {
    VERIFY_EID(0),
    VERIFY_EID_ACTIVE_EKYC(1),
    VERIFY_EID_SIMPLE_EKYC(5),
    VERIFY_EID_PASSIVE_EKYC(6),
    VERIFY_BANK_TRANSFER(2),
    VERIFY_OCR(3),
    VERIFY_EKYB(7);


    companion object {
        fun fromString(name: String): BusinessType? {
            return enumValues<BusinessType>().find { it.name == name }
        }
    }
}