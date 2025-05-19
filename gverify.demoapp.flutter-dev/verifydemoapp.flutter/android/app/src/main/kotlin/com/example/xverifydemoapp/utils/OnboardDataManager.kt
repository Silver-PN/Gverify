package com.example.xverifydemoapp.utils

import org.jmrtd.lds.icao.MRZInfo
import vn.jth.xverifysdk.data.BasicInformation
import vn.jth.xverifysdk.data.Eid

import vn.jth.xverifysdk.network.models.request.VerifyIdResquestModel
import vn.jth.xverifysdk.vision.core.StepFace

val ONBOARDDATAMANAGER = OnboardDataManager.shared

class OnboardDataManager {

    var deviceId:String?=null

    //DG1
    var mrzInfo:MRZInfo?=null
    var eid: Eid? = null
    var basicInformation:BasicInformation?=null

    var businessType: BusinessType? = null
    var verifyIdRequestModel: VerifyIdResquestModel? = null
    /**
     * Image path of CCCD
     */
    var referenceFaceImagePath: String? = null
    var onboardingFaceImagePath : String? = null

    var isFaceMatch = false
    var isValidIdCard = false
    var isOTPVerified = false


    //LIVENESS
    var isRandomActions = true
    var steps:ArrayList<StepFace>?=null
    var isVerifySpoof = false

    companion object {
        @get:Synchronized
        var shared: OnboardDataManager = OnboardDataManager()
    }


}