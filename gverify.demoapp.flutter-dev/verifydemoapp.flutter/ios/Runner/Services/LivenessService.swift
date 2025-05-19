import xverifysdk
import AVFoundation

class LivenessService {
    var player: AVAudioPlayer?
    
    func initLiveness(referenceImagePath: String,  verificationMode: EkycVerificationMode, customStepFace: [StepFace], shouldRandomStepFace: Bool) {
        ACTIVEEKYCSERVICE.initialize(referenceImagePath: referenceImagePath, verificationMode: verificationMode,
                                     faceDelegate: self, faceResultDelegate: self, verifyDelegate: self,
                                     customStepFace: customStepFace, navigateDelegate: self, shouldRandomStepFace: shouldRandomStepFace)
    }
    
    private func playSound() {
        guard let path = Bundle.main.path(forResource: "sound_beep", ofType:"wav") else {return}
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
// --------------------------------------
// MARK: EkycLivenessDelegate
// --------------------------------------

extension LivenessService: EkycLivenessDelegate {
    
    func onStep(step: StepFace) {
            if step == .left{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.left.rawValue))
            }else if step == .right{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.right.rawValue))
            }else if step == .face{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.faceCenter.rawValue))
            }else if step == .smile{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.smile.rawValue))
            }else if step == .up{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.nodUp.rawValue))
            }else if step == .down{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.nodDown.rawValue))
            }else if step == .far{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.faceFar.rawValue))
            }else if step == .near{
                MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.faceNear.rawValue))
            }
        }
    
    func onMultiFace(){
        MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.onMultiFace.rawValue))
    }

    func onNoFace(){
        MethodChannel.shared.invoke(event: .onStepLiveness(EkycLivenessGuide.onNoFace.rawValue))
    }

    func onPlaySound(){
        playSound()
    }
}

// --------------------------------------
// MARK: EkycVerifyDelegate
// --------------------------------------

extension LivenessService: EkycVerifyDelegate {
    func onFinish() {
        MethodChannel.shared.invoke(event: .onVerifyFaceLivenessFinish)
    }
    
    func onVerifyCompleted(ekycVerificationMode: xverifysdk.EkycVerificationMode, verifyLiveness: Bool, verifyFaceMatch: Bool, capturedFace: String?) {
        MethodChannel.shared.invoke(event: .onVerifyFaceLivenessFinish)
                if  let url = URL(string: capturedFace ?? "") {
                    switch ekycVerificationMode {
                    case .liveness:
                        print("Only face center")
                        MethodChannel.shared.invoke(event: .onLivenessSuccess(verifyLiveness,verifyFaceMatch,url.relativePath))
                    case .liveness_face_matching:
                        MethodChannel.shared.invoke(event: .onLivenessSuccess(verifyLiveness,verifyFaceMatch,url.relativePath))
                    case .verify_liveness:
                        print("Verify left - right - center : verifyLiveness")
                    case .verify_liveness_face_matching:
                        if verifyLiveness{
                            MethodChannel.shared.invoke(event: .onLivenessSuccess(verifyLiveness,verifyFaceMatch,url.relativePath))
                        }

                    @unknown default:
                        break
                    }
                    ONBOARDDATAMANAGER.ekycFront = capturedFace ?? ""
                }
    }
    
    func onProcess() {
        MethodChannel.shared.invoke(event: .onVerifyingFaceLiveness)
    }
    

    func onFailed(error: NSError, capturedFace: String, ekycVerificationMode: xverifysdk.EkycVerificationMode, errorCode: xverifysdk.EkycVerifyError) {
        MethodChannel.shared.invoke(event: .onErrorMessage(error.localizedDescription))
        if error.code == ErrorCode.verifyLivenessError.rawValue {
            ACTIVEEKYCSERVICE.resetAnalysis()
        }
    }
}


extension LivenessService: EkycLivenessNavigateDelegate {
    func onResetState() {
    }
    
    func onReadyDetect(isReady: Bool) {
    }
    
    func onNavigateState(ekycLivenessState: EkycLivenessState) {
    }
}

extension LivenessService: EkycFaceResultDelegate {
    func onFaceFar(_ faceFar: String) {
    }
    
    func onFaceNear(_ faceNear: String) {
    }
}

enum EkycLivenessGuide: String {
    case onMultiFace = "ON_MULTI_FACE"
    case onNoFace = "ON_NO_FACE"
    case faceCenter = "FACE_CENTER"
    case left = "LEFT"
    case right = "RIGHT"
    case smile = "SMILE"
    case openMouth = "OPEN_MOUTH"
    case surprised = "SURPRISED"
    case sadness = "SADNESS"
    case nodUp = "NOD_UP"
    case nodDown = "NOD_DOWN"
    case faceFar = "FACE_FAR"
    case done = "DONE"
    case faceNear = "FACE_NEAR"
}
