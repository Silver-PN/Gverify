import xverifysdk

class RequestBioOtpConfirmService {
    func RequestBioOtpConfirm() {
        BIOFACADE.requestBioOtpConfirm(idCard: ONBOARDDATAMANAGER.eid?.personOptionalDetails?.eidNumber ?? "", deviceUUID: Utils.sampleDeviceUUID) { otpResult in
            if let status = otpResult.onboardingState {
                ONBOARDDATAMANAGER.onboardStatus = status
                MethodChannel.shared.invoke(event: .onBioVerifyOtpSuccess(true))
            }
        } onError: { error in
            MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
        }
    }
}
