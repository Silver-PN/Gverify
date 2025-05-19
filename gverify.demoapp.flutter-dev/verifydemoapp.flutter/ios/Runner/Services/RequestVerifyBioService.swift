import xverifysdk

class RequestVerifyBioService {
     func requestVerifyBio(facePath: String) {
         let facePath = facePath.toPathFile()
         guard let faceURlImage = URL(string: facePath) else {
             MethodChannel.shared.invoke(event: .onErrorMessage("Error: Invalid URL from facePath"))
             return
         }
         guard let eid = ONBOARDDATAMANAGER.eid else {
             MethodChannel.shared.invoke(event: .onErrorMessage("Error: eid is nil"))
             return
         }
         do {
             let imageData = try Data(contentsOf: faceURlImage)
             guard let image = UIImage(data: imageData) else {
                 MethodChannel.shared.invoke(event: .onErrorMessage("Error: Unable to create UIImage from imageData"))
                 return
             }
             BIOFACADE.requestBioFaceVerification(idCard: eid.personOptionalDetails?.eidNumber ?? "", deviceUUID: Utils.sampleDeviceUUID, captureImage: image) { result in
                 if let status = result.onboardingState {
                     ONBOARDDATAMANAGER.onboardStatus = status
                 }
                 
                 if let isMatch = result.isMatching {
                     ONBOARDDATAMANAGER.ekycFront = facePath
                     MethodChannel.shared.invoke(event: .onBioVerifyFaceMatchingSuccess(isMatch))
                 }
             } onError: { error in
                 MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
             }
             
         } catch {
             MethodChannel.shared.invoke(event: .onErrorMessage("Error loading image: \(error)"))
         }
    }
}

