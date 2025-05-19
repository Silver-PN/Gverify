import UIKit
import CoreNFC
import AVFoundation
import xverifysdk

class CameraLivenessFactory: NSObject, FlutterPlatformViewFactory {
    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?
    ) -> FlutterPlatformView {
        return CameraLivenessView(frame: frame, viewId: viewId)
    }
}

class CameraLivenessView: NSObject, FlutterPlatformView {
    private let captureSession = AVCaptureSession()
    private let previewLayer: AVCaptureVideoPreviewLayer
    private var lastFrame: CMSampleBuffer?
    
    init(frame: CGRect, viewId: Int64) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        super.init()
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.frame = .init(origin: .zero, size: .init(width: 270, height: 270))
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
        startSession()
    }
  
    func view() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    private func setUpCaptureSessionOutput() {
        weak var weakSelf = self
        guard let strongSelf = weakSelf else {
            print("Self is nil!")
            return
        }
        strongSelf.captureSession.beginConfiguration()
        strongSelf.captureSession.sessionPreset = AVCaptureSession.Preset.high

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
        output.setSampleBufferDelegate(strongSelf, queue: outputQueue)
        guard strongSelf.captureSession.canAddOutput(output) else {
            print("Failed to add capture session output.")
            return
        }
        strongSelf.captureSession.addOutput(output)
        strongSelf.captureSession.commitConfiguration()
    }
    
    private func setUpCaptureSessionInput() {
        weak var weakSelf = self
        guard let strongSelf = weakSelf else {
            print("Self is nil!")
            return
        }
        guard let device = strongSelf.captureDevice(forPosition: .front) else {
            print("Failed to get capture device for camera position: back")
            return
        }
        do {
            strongSelf.captureSession.beginConfiguration()
            let currentInputs = strongSelf.captureSession.inputs
            for input in currentInputs {
                strongSelf.captureSession.removeInput(input)
            }

            let input = try AVCaptureDeviceInput(device: device)
            guard strongSelf.captureSession.canAddInput(input) else {
                print("Failed to add capture session input.")
                return
            }
            strongSelf.captureSession.addInput(input)
            strongSelf.captureSession.commitConfiguration()
        } catch {
            print("Failed to create capture device input: \(error.localizedDescription)")
        }
    }
    
   
   private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
             deviceTypes: [.builtInWideAngleCamera],
             mediaType: .video,
             position: .unspecified
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
   }
    
    private func startSession() {
        weak var weakSelf = self
        DISPATCH_ASYNC_BG {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.startRunning()
        }
    }

    private func stopSession() {
        weak var weakSelf = self
        DISPATCH_ASYNC_BG {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.captureSession.stopRunning()
        }
    }
}

extension CameraLivenessView: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        lastFrame = sampleBuffer
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        
        ACTIVEEKYCSERVICE.processDetectFaces(sampleBuffer: sampleBuffer, width: imageWidth, height: imageHeight)
    }
}
