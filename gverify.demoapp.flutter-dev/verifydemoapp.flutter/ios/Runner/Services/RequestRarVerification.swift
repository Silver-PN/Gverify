import xverifysdk
class RequestRarVerification {
    //Step 1: Bio-2345 verify CCCD with RAR
    func requestRarVerification(eid: Eid, faceUrl: String) {
    MethodChannel.shared.invoke(event: .onVerifyingEidWithRar)

        //Init object: RarVerificationRequestModel

        BIOFACADE.requestRarVerification(eid: eid, deviceUUID: Utils.sampleDeviceUUID, deviceName: UIDevice.current.name) { rarResult in
            ONBOARDDATAMANAGER.onboardStatus = rarResult.onboardingState
            if rarResult.responds.result {
                MethodChannel.shared.invoke(event: .onVerifyEidSuccess(eid, faceUrl))
            }
        } onError: { error in
            MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
        }
    }
}
