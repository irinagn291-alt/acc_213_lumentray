import AVFoundation
import SwiftUI
import UIKit

struct LumenPaneScanner: UIViewControllerRepresentable {
    var onGlyph: (String) -> Void

    func makeUIViewController(context: Context) -> LumenPaneScanHost {
        let host = LumenPaneScanHost()
        host.onGlyph = onGlyph
        return host
    }

    func updateUIViewController(_ uiViewController: LumenPaneScanHost, context: Context) {
        uiViewController.onGlyph = onGlyph
    }
}

final class LumenPaneScanHost: UIViewController, @preconcurrency AVCaptureMetadataOutputObjectsDelegate {
    var onGlyph: ((String) -> Void)?
    nonisolated(unsafe) private let session = AVCaptureSession()
    private var preview: AVCaptureVideoPreviewLayer?
    private var lastEmit: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            mountSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted { self?.mountSession() }
                }
            }
        default:
            break
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preview?.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spin(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spin(false)
    }

    private func mountSession() {
        guard preview == nil else { return }
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }
        session.addInput(input)
        let output = AVCaptureMetadataOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        let wanted: [AVMetadataObject.ObjectType] = [.ean8, .ean13, .upce, .code128, .qr]
        output.metadataObjectTypes = wanted.filter { output.availableMetadataObjectTypes.contains($0) }
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        preview = layer
        spin(true)
    }

    private func spin(_ on: Bool) {
        let session = session
        DispatchQueue.global(qos: .userInitiated).async {
            if on {
                if !session.isRunning { session.startRunning() }
            } else if session.isRunning {
                session.stopRunning()
            }
        }
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        let now = Date().timeIntervalSince1970
        guard now - lastEmit > 1.4 else { return }
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let raw = object.stringValue,
              let code = LumenEan.normalize(raw) else { return }
        lastEmit = now
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        onGlyph?(code)
    }
}
