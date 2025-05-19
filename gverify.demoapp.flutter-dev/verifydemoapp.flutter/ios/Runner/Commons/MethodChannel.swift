import Flutter
import xverifysdk

public enum VerifyDocumentType: String {
    case businessCertificate = "DKKD_DN"
    case branchRegistrationCertificate = "DKKD_CN"
    case businessHousehold = "DKKD_HKD"
}

class MethodChannel {
    static let shared = MethodChannel()
    
    var methodChannel: FlutterMethodChannel?
    
    private init() {}
    
    func invoke(event: EventMethodChannel, result: FlutterResult? = nil) {
        print("methodChannel invoke \(event.method) \(String(describing: event.arguments))" )
        methodChannel?.invokeMethod(event.method, arguments: event.arguments, result: result)
    }
    
    private func startNfcScan(method: String?, result: Any){
        guard let method = method else {return MethodChannel.shared.invoke(event: .onErrorMessage("Empty method or data"))}
        if method == "MRZ"{
            if let result = result as? [String: Any]{
                var mrzInfo = MRZInfo.createTD1MRZInfo(documentCode: "", issuingState: "", documentNumber: (result["documentNumber"] as? String)!, dateOfBirth: (result["dateOfBirth"] as? String)!, gender: "", dateOfExpiry: (result["dateOfExpiry"] as? String)!, nationality: "")
                ONBOARDDATAMANAGER.mrzKey = try! EIDFACADE.buildMrzKey(eidNumber: mrzInfo.documentNumber, dateOfBirth: mrzInfo.dateOfBirth, dateOfExpiry: mrzInfo.dateOfExpiry) ?? ""
            }
        }else{
            if let result = result as? [String: Any] {
                let basicInformation = BasicInformation(
                    eidNumber: result["eidNumber"] as? String,
                    oldEidNumber: result["oldEidNumber"] as? String,
                    fullName: result["fullName"] as? String,
                    dateOfBirth: result["dateOfBirth"] as? String,
                    gender: result["gender"] as? String,
                    placeOfResidence: result["placeOfResidence"] as? String,
                    dateOfIssue: result["dateOfIssue"] as? String,
                    fatherName: result["fatherName"] as? String,
                    motherName: result["motherName"] as? String
                )
                
                ONBOARDDATAMANAGER.basicInfomation = basicInformation
                ONBOARDDATAMANAGER.mrzKey = try! EIDFACADE.buildMrz(eidNumber: basicInformation.eidNumber, dateOfBirth: basicInformation.dateOfBirth, dateOfIssue: basicInformation.dateOfIssue) ?? ""
            }
        }
        MethodChannel.shared.invoke(event: .onStartSessionNFC)
        EIDFACADE.readChipNfc(mrzKey: ONBOARDDATAMANAGER.mrzKey, basicInformation: ONBOARDDATAMANAGER.basicInfomation) { eid in
            MethodChannel.shared.invoke(event: .onFinishNFC)
            NfcEidReadService().nfcEidRead(eid: eid)
            if ONBOARDDATAMANAGER.businessType == BusinessType.VERIFY_BANK_TRANSFER{
                RequestRarVerification().requestRarVerification(eid: eid, faceUrl: ONBOARDDATAMANAGER.eidFacePath)
            }else{
                RequestVerifyEidService().requestVerifyEid(completionHandler: { error in
                    if let error = error {
                        MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
                    } else if let url = URL(string: ONBOARDDATAMANAGER.eidFacePath) {
                        MethodChannel.shared.invoke(event: .onVerifyEidSuccess(eid, url.relativePath))
                    }
                })
            }
            
        } errorHandler: { error in
            MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
            print("VERIFY_EID_METHOD error \(error.localizedDescription)")
        }
    }
    
    
    private func setUpEnv(call: FlutterMethodCall, result: FlutterResult) {
        guard let envVariables = call.arguments as? [String: String] else {
            result(FlutterError(code: "1", message: "Missing env", details: nil))
            return
        }
        
        guard let apiBaseUrl = envVariables["API_BASE_URL"],
              let apiBioBaseUrl = envVariables["API_BIO2345_BASE_URL"],
              let apiKey = envVariables["API_KEY"],
              let customerCode = envVariables["CUSTOMER_CODE"] else {
            result(FlutterError(code: "2", message: "Invalid or missing parameters", details: nil))
            return
        }
        
        
        ApiConfig.API_BASE_URL = apiBaseUrl
        ApiConfig.API_BIO2345_BASE_URL = apiBioBaseUrl
        ApiConfig.API_KEY = apiKey
        ApiConfig.CUSTOMER_CODE = customerCode
        
        APISERVICE.initialize(apiKey: apiKey, apiBaseUrl: apiBaseUrl, customerCode: customerCode)
        BIOAPISERVICE.initialize(apiKey: apiKey, apiBaseUrl: apiBioBaseUrl, customerCode: customerCode)
        result("Config API success")
    }
    
    private func receiveBussinessType(call: FlutterMethodCall, result: FlutterResult){
        guard let envVariables = call.arguments as? [String: String] else {
            result(FlutterError(code: "1", message: "Missing env", details: nil))
            return
        }
        
        guard let businessType = envVariables["business"] else {
            result(FlutterError(code: "2", message: "Business type is null", details: nil))
            return
        }
        ONBOARDDATAMANAGER.businessType = BusinessType.fromString(businessType)
        print("BusinessType = \(ONBOARDDATAMANAGER.businessType)")
    }
    func handleEvent() {
        methodChannel?.setMethodCallHandler({ event, resultFlutter in
            print("methodChannel \(event.method)")
            switch event.method {
            case "SEND_ENV_METHOD":
                self.setUpEnv(call: event, result: resultFlutter)
            case "SEND_BUSINESS_TYPE":
                self.receiveBussinessType(call: event, result: resultFlutter)
            case "VERIFY_EID_METHOD":
                guard let args = event.arguments as? [String: Any] else { return }
                let methodScan = (args["method"] as? String)
                let data = (args["data"])
                
                self.startNfcScan(method: methodScan, result: data)
            case "SEND_DEVICE_ID":
                if let args = event.arguments as? [String: Any] {
                    let deviceId = (args["deviceId"] as? String) ?? UUID().uuidString
                    Utils.sampleDeviceUUID = deviceId
                }
                break
            case "GET_CARD_TYPE":
                var type = ONBOARDDATAMANAGER.eid?.getCardType().localized() ?? ""
                if type == "card_type_eid"{
                    type = "EID"
                }else if type == "card_type_new_eid"{
                    type = "NEW_EID"
                }else if type == "card_type_unknown"{
                    type = "UNKNOWN"
                }
                resultFlutter(type)
                break
            case "VERIFY_EKYC_METHOD":
                if let args = event.arguments as? [String: Any] {
                    let shouldRandomStepFace = (args["isRandom"] as? Bool) ?? true
                    let verifySpoof = (args["verifySpoof"] as? Bool) ?? false
                    let customStepFace = (args["actions"] as? Array<String>)?.map({ StepFace.init(from: $0) }) ?? []
                    let business = (args["business"] as? String)
                    let verificationMode: EkycVerificationMode
                    switch business {
                    case "VERIFY_EID_ACTIVE_EKYC":
                        ONBOARDDATAMANAGER.businessType = .VERIFY_EID_ACTIVE_EKYC
                        verificationMode = .verify_liveness_face_matching
                    case "VERIFY_EID_SIMPLE_EKYC":
                        ONBOARDDATAMANAGER.businessType = .VERIFY_EID_SIMPLE_EKYC
                        verificationMode = .liveness_face_matching
                    case "VERIFY_BANK_TRANSFER":
                        ONBOARDDATAMANAGER.businessType = .VERIFY_BANK_TRANSFER
                        verificationMode = .liveness
                    case "VERIFY_OCR":
                        ONBOARDDATAMANAGER.businessType = .VERIFY_OCR
                        verificationMode = .liveness_face_matching
                    case "VERIFY_EKYB":
                        ONBOARDDATAMANAGER.businessType = .VERIFY_EKYB
                        verificationMode = .liveness_face_matching
                    default:
                        verificationMode = .liveness
                    }
                    LivenessService().initLiveness(referenceImagePath: ONBOARDDATAMANAGER.eidFacePath,
                                                   verificationMode: verificationMode,
                                                   customStepFace: customStepFace,
                                                   shouldRandomStepFace: shouldRandomStepFace)
                }
                break
            case "REQUEST_CHECK_ONBOARDING_STATE":
                BIOFACADE.bioGetOnboardStatus(deviceUUID: Utils.sampleDeviceUUID) { state in
                    MethodChannel.shared.invoke(event: .onResultCheckOnboardingStatus(Utils.sampleDeviceUUID, state.rawValue))
                } onError: { error in
                    MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
                }
            case "REQUEST_VERIFY_FACE_BIOMETRIC":
                if let args = event.arguments as? [String: Any] {
                    let facePath = (args["path"] as? String) ?? ""
                    RequestVerifyBioService().requestVerifyBio(facePath: facePath)
                }
            case "REQUEST_BIO_VERIFY_OTP":
                if let args = event.arguments as? [String: Any] {
                    let code = (args["code"] as? String) ?? ""
                    RequestBioOtpConfirmService().RequestBioOtpConfirm()
                }
            case "REQUEST_GET_DATA_ONBOARD_SUCCESS":
                let eid = ONBOARDDATAMANAGER.eid
                let chipImageBase64 = eid?.faceImage?.pngData()?.base64EncodedString()
                let onboardImageBase64 = try? Data(contentsOf: URL(string: ONBOARDDATAMANAGER.ekycFront)!).base64EncodedString()
                resultFlutter(["chipImageBase64": chipImageBase64,
                        "onboardImageBase64": onboardImageBase64,
                        "eid_number": eid?.personOptionalDetails?.eidNumber,
                        "full_name": eid?.personOptionalDetails?.fullName,
                        "place_of_residence": eid?.personOptionalDetails?.placeOfResidence,
                        "gender": eid?.personOptionalDetails?.gender,
                        "dob": eid?.personOptionalDetails?.dateOfBirth])
            case "REQUEST_BIO_VERIFY_FACE_TRANSFER":
                if let args = event.arguments as? [String: Any] {
                    let path = (args["path"] as? String) ?? ""
                    RequestTransactionFaceConfirmService().requestTransactionFaceConfirm(faceCenter: path)
                }
            case "REQUEST_GET_DATA_TRANSFER_SUCCESS":
                let eid = ONBOARDDATAMANAGER.eid
                let chipImageBase64 = eid?.faceImage?.pngData()?.base64EncodedString()
                let onboardImageBase64 = try? Data(contentsOf: URL(string: ONBOARDDATAMANAGER.ekycFront)!).base64EncodedString()
                resultFlutter(["chipImageBase64": chipImageBase64,
                        "onboardImageBase64": onboardImageBase64])
            case "REQUEST_VERIFY_OCR":
                if let args = event.arguments as? [String: Any] {
                    let imgFront = ((args["image_front"] as? String) ?? "").toPathFile()
                    let imgBack = ((args["image_back"] as? String) ?? "").toPathFile()
                    APISERVICE.verifyOCR(path: "", frontPath: imgFront, backPath: imgBack) { result in
                        switch result {
                        case .success(let data):
                            guard let data = try? JSONEncoder().encode(OCRResponseMapModel(from: data)) else {
                                return
                            }
                            let dict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
                                .flatMap { $0 as? [String: Any] } ?? [:]
                            MethodChannel.shared.invoke(event: .onVerifyOcrSuccess(dict))
                        case .failure(let error):
                            MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
                        }
                    }
                }
            case "DECODE_MRZ_BY_PATH":
                if let args = event.arguments as? [String: Any],
                   let path = (args["path"] as? String)?.toPathFile(),
                   let url = URL(string: path),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    EIDFACADE.processMrz(image: image) { mrzInfo in
                        if let mrzInfo = mrzInfo {
                            ONBOARDDATAMANAGER.mrzKey = try! EIDFACADE.buildMrzKey(eidNumber: mrzInfo.documentNumber, dateOfBirth: mrzInfo.dateOfBirth, dateOfExpiry: mrzInfo.dateOfExpiry) ?? ""
                            MethodChannel.shared.invoke(event: .onFinishMRZ(mrzInfo))
                        } else {
                            MethodChannel.shared.invoke(event: .onErrorMessage("Something error"))
                        }
                    } errorHandler: { error in
                        MethodChannel.shared.invoke(event: .onErrorMessage(error?.localizedDescription ?? "Something error"))
                    }
                } else {
                    MethodChannel.shared.invoke(event: .onErrorMessage("Something error"))
                }
            case "REQUEST_SCAN_EKYB":
                if let args = event.arguments as? [String: Any],
                       let filePaths = args["filePaths"] as? [String],
                       let documentType = args["documentType"] as? String {

                        let imageURLs = filePaths.compactMap { URL(fileURLWithPath: $0) }

                        let type: VerifyDocumentType
                        switch documentType {
                        case "DKKD_DN":
                            type = .businessCertificate
                        case "DKKD_CN":
                            type = .branchRegistrationCertificate
                        case "DKKD_HKD":
                            type = .businessHousehold
                        default:
                            type = .businessCertificate
                        }
                        
                        switch type {
                            case .businessCertificate:
                                APISERVICE.verifyOCReKYB(path: "", image: imageURLs, type: type.rawValue) { (result: Result<VerifyDocumentResponseModel<BusinessInfoResponseModel>, Error>) in
                                    self.handleAPIResponse(result: result, type: type,resultFlutter: resultFlutter)
                                }
                            case .branchRegistrationCertificate:
                                APISERVICE.verifyOCReKYB(path: "", image: imageURLs, type: type.rawValue) { (result: Result<VerifyDocumentResponseModel<BranchInfoResponseModel>, Error>) in
                                    self.handleAPIResponse(result: result, type: type,resultFlutter: resultFlutter)
                                }
                            case .businessHousehold:
                                APISERVICE.verifyOCReKYB(path: "", image: imageURLs, type: type.rawValue) { (result: Result<VerifyDocumentResponseModel<BusinessHouseholdResponseModel>, Error>) in
                                    self.handleAPIResponse(result: result, type: type,resultFlutter: resultFlutter)
                                }
                        }

                    } else {
                        let errorResponse: [String: Any] = [
                            "success": false,
                            "error": "Invalid input data for VERIFY_EID_EKYB"
                        ]
                        if let jsonData = try? JSONSerialization.data(withJSONObject: errorResponse, options: []),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            resultFlutter(jsonString)
                        } else {
                            resultFlutter(FlutterError(code: "JSON_ENCODING_ERROR", message: "Failed to encode error response", details: nil))
                        }
                    }
            case "VERIFY_TAX_CODE_ADVANCE":
                guard let args = event.arguments as? [String: Any],
                      let taxCode = args["taxCode"] as? String else {
                    resultFlutter(FlutterError(code: "INVALID_ARGUMENT", message: "Thiếu taxCode", details: nil))
                    return
                }

                APISERVICE.verifyTaxCode(path: "", taxCode: taxCode) { response in
                    switch response {
                    case .success(let result):
                        do {
                            if result.responds?.status == "error" {
                                resultFlutter(FlutterError(code: "500", message: "Giấy tờ không hợp lệ", details: nil))
                                return
                            }

                            let simplifiedData = SimplifiedTaxCodeData(
                                status: result.responds?.status,
                                isTaxCodeValid: result.isValid ?? false,
                                taxCode: result.responds?.company?.taxCode,
                                phoneNumber: result.responds?.company?.phoneNumber,
                                name: result.responds?.company?.name,
                                businessStatus: result.responds?.company?.businessStatus,
                                companyAddress: result.responds?.company?.companyAddress,
                                companyRepresentative: result.responds?.company?.representative,
                                companyRepresentativeId: result.responds?.company?.representativeID
                            )

                            let encoder = JSONEncoder()
                            encoder.keyEncodingStrategy = .convertToSnakeCase
                            let jsonData = try encoder.encode(simplifiedData)
                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                print("verifytaxcodeadvance = \(jsonString)")
                                resultFlutter(jsonString)
                            } else {
                                resultFlutter(FlutterError(code: "INVALID_JSON", message: "Không thể chuyển đổi dữ liệu sang String", details: nil))
                            }
                        } catch {
                            resultFlutter(FlutterError(code: "ENCODING_EXCEPTION", message: "Lỗi khi mã hóa JSON", details: error.localizedDescription))
                        }
                    case .failure(let error):
                        print("Lỗi xác thực: \(error.localizedDescription)")
                        resultFlutter(FlutterError(code: "ERROR", message: "Call Fail!", details: error.localizedDescription))
                    }
                }
            default:
                break
            }
        })
    }
    
    private func handleAPIResponse<T: Decodable>(result: Result<VerifyDocumentResponseModel<T>, Error>, type: VerifyDocumentType, resultFlutter: @escaping FlutterResult) {
        switch result {
        case .success(let data):
            do {
                var simplifiedData: SimplifiedDocumentData

                switch type {
                case .businessCertificate:
                    guard let businessData = data.data as? BusinessInfoResponseModel else {
                        resultFlutter(FlutterError(code: "INVALID_DATA", message: "Dữ liệu không đúng định dạng cho BusinessInfo", details: nil))
                        return
                    }
                    simplifiedData = SimplifiedDocumentData(
                        typeDocument: "Đăng ký kinh doanh - Doanh nghiệp",
                        businessName: businessData.name?.value,
                        representativeModel: {
                            if let firstRep = businessData.representatives?.first {
                                return SimplifiedDocumentData.RepresentativeData(
                                    nationality: firstRep.nationality?.value,
                                    ethnicity: firstRep.ethnicity?.value,
                                    gender: firstRep.gender?.value,
                                    name: firstRep.name?.value,
                                    position: firstRep.position?.value,
                                    permanentResidence: firstRep.permanentResidence?.value,
                                    id: firstRep.id?.value,
                                    dob: firstRep.dob?.value,
                                    idType: firstRep.idType?.value,
                                    address: firstRep.address?.value,
                                    documentPlaceOfIssue: firstRep.documentPlaceOfIssue?.value,
                                    documentIssueDate: firstRep.documentIssueDate?.value
                                )
                            }
                            return nil
                        }(),
                        textType: businessData.textType?.value,
                        address: businessData.companyAddress?.value,
                        placeOfIssue: businessData.placeOfIssue?.value,
                        signer: businessData.signer?.value,
                        taxcode: businessData.taxCode?.value,
                        phoneNumber: businessData.phoneNumber?.value
                    )

                case .branchRegistrationCertificate:
                    guard let branchData = data.data as? BranchInfoResponseModel else {
                        resultFlutter(FlutterError(code: "INVALID_DATA", message: "Dữ liệu không đúng định dạng cho BranchInfo", details: nil))
                        return
                    }
                    simplifiedData = SimplifiedDocumentData(
                        typeDocument: "Đăng ký kinh doanh - Chi nhánh",
                        businessName: branchData.businessName?.value,
                        representativeModel: {
                            if let leader = branchData.leader {
                                return SimplifiedDocumentData.RepresentativeData(
                                    nationality: leader.nationality?.value,
                                    ethnicity: leader.ethnicity?.value,
                                    gender: leader.gender?.value,
                                    name: leader.name?.value,
                                    position: nil,
                                    permanentResidence: leader.permanentResidence?.value,
                                    id: leader.id?.value,
                                    dob: leader.dob?.value,
                                    idType: leader.idType?.value,
                                    address: leader.address?.value,
                                    documentPlaceOfIssue: leader.documentPlaceOfIssue?.value,
                                    documentIssueDate: leader.documentIssueDate?.value
                                )
                            }
                            return nil
                        }(),
                        textType: branchData.textType?.value,
                        address: branchData.companyAddress?.value ?? branchData.headquartersAddress?.value,
                        placeOfIssue: branchData.placeOfIssue?.value,
                        signer: branchData.signer?.value,
                        taxcode: branchData.taxCode?.value,
                        phoneNumber: branchData.phoneNumber?.value
                    )

                case .businessHousehold:
                    guard let householdData = data.data as? BusinessHouseholdResponseModel else {
                        resultFlutter(FlutterError(code: "INVALID_DATA", message: "Dữ liệu không đúng định dạng cho BusinessHousehold", details: nil))
                        return
                    }
                    simplifiedData = SimplifiedDocumentData(
                        typeDocument: "Đăng ký kinh doanh - Hộ kinh doanh",
                        businessName: householdData.businessHouseholdName?.value,
                        representativeModel: {
                            if let rep = householdData.representative {
                                return SimplifiedDocumentData.RepresentativeData(
                                    nationality: rep.nationality?.value,
                                    ethnicity: rep.ethnicity?.value,
                                    gender: rep.gender?.value,
                                    name: rep.name?.value,
                                    position: rep.position?.value,
                                    permanentResidence: rep.permanentResidence?.value,
                                    id: rep.id?.value,
                                    dob: rep.dob?.value,
                                    idType: rep.idType?.value,
                                    address: rep.address?.value,
                                    documentPlaceOfIssue: rep.documentPlaceOfIssue?.value,
                                    documentIssueDate: rep.documentIssueDate?.value
                                )
                            }
                            return nil
                        }(),
                        textType: householdData.textType?.value,
                        address: householdData.businessLocation?.value,
                        placeOfIssue: householdData.placeOfIssue?.value,
                        signer: householdData.signer?.value,
                        taxcode: householdData.businessCode?.value,
                        phoneNumber: householdData.phoneNumber?.value
                    )
                }

                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                let encodedData = try encoder.encode(simplifiedData)
                if let jsonString = String(data: encodedData, encoding: .utf8) {
                    resultFlutter(jsonString)
                } else {
                    resultFlutter(FlutterError(code: "INVALID_JSON", message: "Không thể chuyển đổi dữ liệu sang String", details: nil))
                }
            } catch {
                resultFlutter(error as? FlutterError ?? FlutterError(code: "ENCODING_EXCEPTION", message: "Lỗi khi mã hóa JSON", details: error.localizedDescription))
            }
        case .failure(let error):
            print("Lỗi xác thực: \(error.localizedDescription)")
            resultFlutter(FlutterError(code: "API_ERROR", message: "Lỗi xác thực tài liệu", details: error.localizedDescription))
        }
    }
}



enum EventMethodChannel {
    case onFinishMRZ(MRZInfo)
    case onScanQRCodeSuccess(BasicInformation)
    case onStartSessionNFC
    case onFinishNFC
    case onVerifyingEidWithRar
    case onVerifyEidSuccess(Eid, String)
    case onErrorMessage(String)
    case onPlaySound
    case onStepLiveness(String)
    case onVerifyingFaceLiveness
    case onVerifyFaceLivenessFinish
    case onLivenessSuccess(Bool,Bool,String)
    case onVerifyFaceMatchingSuccess(Bool)
    case onResultCheckOnboardingStatus(String, Int)
    case onBioVerifyFaceMatchingSuccess(Bool)
    case onBioVerifyOtpSuccess(Bool)
    case onVerifyOcrSuccess([String: Any])

    
    var method: String {
        switch self {
        case .onFinishMRZ:
            return "ON_FINISH_MRZ"
        case .onScanQRCodeSuccess:
            return "ON_SCAN_QR_CODE_SUCCESS"
        case .onVerifyEidSuccess:
            return "ON_VERIFY_EID_SUCCESS"
        case .onErrorMessage:
            return "ON_ERROR_MESSAGE"
        case .onStartSessionNFC:
            return "ON_START_SESSION_NFC"
        case .onFinishNFC:
            return "ON_FINISH_NFC"
        case .onVerifyingEidWithRar:
            return "ON_VERIFYING_EID_WITH_RAR"
        case .onPlaySound:
            return "ON_PLAY_SOUND"
        case .onStepLiveness:
            return "ON_STEP_LIVENESS"
        case .onVerifyingFaceLiveness:
            return "ON_VERIFYING_FACE_LIVENESS"
        case .onVerifyFaceLivenessFinish:
            return "ON_VERIFY_FACE_LIVENESS_FINISH"
        case .onLivenessSuccess:
            return "ON_LIVENESS_SUCCESS"
        case .onResultCheckOnboardingStatus:
            return "ON_RESULT_CHECK_ONBOARDING_STATUS"
        case .onBioVerifyFaceMatchingSuccess:
            return "ON_BIO_VERIFY_FACE_MATCHING_SUCCESS"
        case .onBioVerifyOtpSuccess:
            return "ON_BIO_VERIFY_OTP_SUCCESS"
        case .onVerifyOcrSuccess:
            return "ON_VERIFY_OCR_SUCCESS"
        case .onVerifyFaceMatchingSuccess(_):
            return "ON_VERIFY_FACE_MATCHING_SUCCESS"
        }
    }
    
    var arguments: Any? {
        switch self {
        case .onFinishMRZ(let mrzInfo):
            return ["mrzInfo": Utils.objectToJsonString(object: EncodableMRZInfo(mrzInfo: mrzInfo))]
        case .onScanQRCodeSuccess(let qrcodeInfo):
            return ["basicInformation": Utils.objectToJsonString(object: EncodableQRCodeInfo(basicInfomation: qrcodeInfo) )]
        case .onVerifyEidSuccess(let eid, let faceImage):
            guard let personOptionalDetails = eid.personOptionalDetails else { return [:] }
            let personOptionalDetailsStr = Utils.objectToJsonString(object: EncodablePersonOptionalDetails(detail: personOptionalDetails))
            let verificationStatus = Utils.objectToJsonString(object: EncodableVerificationStatuss(eid: eid, isValidIdCard: true))
            return ["personOptionalDetails": personOptionalDetailsStr,
                    "verificationStatus": verificationStatus,
                    "faceImage": faceImage]
        case .onErrorMessage(let message):
            return ["message": message]
        case .onStepLiveness(let step):
            return ["step": step]
        case .onLivenessSuccess(let isVerifyLiveness,let isFaceMatch,let image):
            return ["isMatching": isFaceMatch, "isVerifyLiveness": isVerifyLiveness,"image": image ]
        case let .onResultCheckOnboardingStatus(deviceId, state):
            return ["deviceId": deviceId, "onboardingState": state]
        case let .onBioVerifyFaceMatchingSuccess(isFaceMatch):
            return ["isFaceMatch": isFaceMatch]
        case let .onBioVerifyOtpSuccess(isSuccess):
            return ["isSuccess": isSuccess]
        case let .onVerifyOcrSuccess(dict):
            return dict
        default:
            return nil
        }
    }
}
