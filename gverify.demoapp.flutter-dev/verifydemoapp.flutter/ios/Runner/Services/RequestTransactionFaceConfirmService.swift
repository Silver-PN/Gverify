import xverifysdk

class RequestTransactionFaceConfirmService {
    func requestTransactionFaceConfirm(faceCenter: String) {
        let faceCenter = faceCenter.toPathFile()
        if let faceURlImage = URL(string: faceCenter), let eid = ONBOARDDATAMANAGER.eid {
            do {
                let imageData = try Data(contentsOf: faceURlImage)
                let image = UIImage(data: imageData) ?? UIImage()
                BIOFACADE.requestTransactionFaceConfirm(idCard: eid.personOptionalDetails?.eidNumber ?? "", captureImage: image, deviceUUID: Utils.sampleDeviceUUID, transcationType: .TypeC) { result in
                    if result.transactionStatus == .BIOMETRIC_VERIFIED {
                        ONBOARDDATAMANAGER.currentOnboardFace = faceCenter
                        MethodChannel.shared.invoke(event: .onBioVerifyFaceMatchingSuccess(true))
                    } else {
                        MethodChannel.shared.invoke(event: .onBioVerifyFaceMatchingSuccess(false))
                    }
                } onError: { error in
                    MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
                }
            } catch {
                MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
            }
        }
    }
}
