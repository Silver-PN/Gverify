import UIKit
import CoreNFC
import AVFoundation
import xverifysdk

class CameraQRCodeFactory: NSObject, FlutterPlatformViewFactory {
    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?
    ) -> FlutterPlatformView {
        return CameraQRCode(frame: frame, viewId: viewId)
    }
}

class CameraQRCode: NSObject, FlutterPlatformView {
    private let captureSession = AVCaptureSession()
    private let previewLayer: AVCaptureVideoPreviewLayer
    var cameraDevice: AVCaptureDevice?
    var isFinished = false
    
    init(frame: CGRect, viewId: Int64) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        super.init()
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.frame = .init(origin: .zero, size: .init(width: 300, height: 300))
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
        guard let device = strongSelf.captureDevice(forPosition: .back) else {
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
        DISPATCH_ASYNC_MAIN_AFTER(1) {
            self.zoomCamera()
        }
    }
    
    func zoomCamera() {
        guard let cameraDevice = cameraDevice else { return }

        do {
            try cameraDevice.lockForConfiguration()

            // Apply the calculated zoom factor within limits
            let maxZoomFactor = cameraDevice.activeFormat.videoMaxZoomFactor
            let newZoomFactor = min(2.5, maxZoomFactor)

            cameraDevice.videoZoomFactor = newZoomFactor
            cameraDevice.unlockForConfiguration()

            print("Set zoom ratio: \(newZoomFactor)")

        } catch {
            print("Failed to lock configuration: \(error)")
        }
    }
   
   private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
       guard let captureDevice = AVCaptureDevice.default(for: .video) else {
           print("Failed to access the camera.")
           return nil
       }
   
       cameraDevice = captureDevice
       return captureDevice
   }
    
    @available(iOS 14.0, *)
    func processQr(sampleBuffer: CMSampleBuffer) {
        
        QRCodeReader.processQr(sampleBuffer: sampleBuffer) { [weak self] data in
            guard let self = self else { return }
            guard let barcodes = data else {
                return
            }
            if barcodes.isEmpty { return }
            
            if self.captureSession.isRunning == true {
                self.captureSession.stopRunning()
            }
            
            if isFinished { return }
            isFinished = true
            let basicInfomaton = EIDFACADE.parserQrCode(result: barcodes[0])
            MethodChannel.shared.invoke(event: .onScanQRCodeSuccess(basicInfomaton!))
        }
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

@available(iOS 14.0, *)
extension CameraQRCode: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
          print("Failed to get image buffer from sample buffer.")
          return
        }
        self.processQr(sampleBuffer: sampleBuffer)
    }
}

extension CameraQRCode: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            guard let cameraDevice = cameraDevice else { return }
            
            // Here, you can implement a custom zoom logic based on the detected barcode/QR code
            autoZoomForDetectedCode(metadataObject)
        }
    }
    // Custom function to handle auto zoom logic
    func autoZoomForDetectedCode(_ metadataObject: AVMetadataMachineReadableCodeObject) {
        guard let cameraDevice = cameraDevice else { return }

        // Simulate zoom based on the bounding box of the detected code
        let zoomFactor: CGFloat = calculateZoomFactor(for: metadataObject.bounds)

        do {
            try cameraDevice.lockForConfiguration()

            // Apply the calculated zoom factor within limits
            let maxZoomFactor = cameraDevice.activeFormat.videoMaxZoomFactor
            let newZoomFactor = min(max(zoomFactor, 1.0), maxZoomFactor)

            cameraDevice.videoZoomFactor = newZoomFactor
            cameraDevice.unlockForConfiguration()

            print("Set zoom ratio: \(newZoomFactor)")

        } catch {
            print("Failed to lock configuration: \(error)")
        }
    }

    // Example zoom factor calculation based on the bounding box of the detected code
    func calculateZoomFactor(for bounds: CGRect) -> CGFloat {
        // Custom zoom logic based on the size and position of the detected QR/barcode
        // For example, the smaller the bounding box, the higher the zoom factor
        let area = bounds.width * bounds.height
        let screenArea = view().frame.width * view().frame.height

        // Simple zoom calculation (can be adjusted based on your use case)
        return screenArea / area
    }
}

