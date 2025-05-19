import xverifysdk

class RequestVerifyEidService {
    func requestVerifyEid(completionHandler: @escaping (_ error: (any Error)?) -> Void) {
        if let eid = ONBOARDDATAMANAGER.eid {
            MethodChannel.shared.invoke(event: .onVerifyingEidWithRar)
            ApiService.shared.verifyEid(path: "", idCard: eid.personOptionalDetails?.eidNumber ?? "", dsCert: eid.documentSigningCertificate?.certToPEM().toBase64() ?? "", deviceType: "mobile", province: eid.personOptionalDetails?.placeOfOrigin ?? "", code: Bundle.main.infoDictionary?["CUSTOMER_CODE"] as! String) { result in
                switch result{
                case .success(let eidVerifyModel):
                    let invalidModel = eidVerifyModel.isValidIdCard
                    if invalidModel {
                        ONBOARDDATAMANAGER.eid?.agencyVerified = invalidModel
                        let publicKeyUrl = Bundle.main.url(forResource: "public", withExtension: "pem") ?? URL(fileURLWithPath: "")
                        
                        if let verifiedEid = ONBOARDDATAMANAGER.eid?.verifyRsaSignature(publicKeyUrl: publicKeyUrl, plainText: eidVerifyModel.responds!, signature: eidVerifyModel.signature) {
                            ONBOARDDATAMANAGER.eid?.agencySignatureChecksum = verifiedEid
                            if let eidFaceImage = ONBOARDDATAMANAGER.eid?.faceImage {
                                let fileName = "ID_\(Date().millisecondsSince1970).jpg"
                                let path = Utils.saveFileToLocal(eidFaceImage, fileName: fileName)
                                ONBOARDDATAMANAGER.eidFacePath = path.absoluteString
                            }
                            if verifiedEid && invalidModel {
                                completionHandler(nil)
                            } else {
                                completionHandler(NSError(domain: "requestVerifyEid Something error", code: -1))
                            }
                        }
                    }
                    
                case .failure(_):
                    completionHandler(NSError(domain: "requestVerifyEid Something error", code: -1))
                    
                }
            
            }
        }
    }}
