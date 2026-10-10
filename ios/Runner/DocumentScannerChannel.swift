import Flutter
import UIKit
import VisionKit

/// Dokumentenscanner (VisionKit) und Kamera-Foto (Gegenstück zu
/// DocumentScannerChannel.kt).
///
/// Gleiche Rückgabe wie Android: `scan` → `{"pdf": Pfad, "images": [Pfade]}`
/// oder `null` (abgebrochen); `takePhoto` → JPEG-Pfad oder `null`. Dateien
/// landen im Cache unter `scans/` — dort räumt `TempFiles.purge` auf.
final class DocumentScannerChannel: NSObject, VNDocumentCameraViewControllerDelegate,
  UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  static let name = "mai/document_scanner"

  private let presenter: () -> UIViewController?
  private var pending: FlutterResult?
  private var pendingPhoto: FlutterResult?

  init(presenter: @escaping () -> UIViewController?) {
    self.presenter = presenter
    super.init()
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "scan":
      scan(result)
    case "takePhoto":
      takePhoto(result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: Scan

  private func scan(_ result: @escaping FlutterResult) {
    if pending != nil || pendingPhoto != nil {
      result(FlutterError(code: "busy", message: "Es läuft bereits ein Scan.", details: nil))
      return
    }
    guard VNDocumentCameraViewController.isSupported else {
      result(
        FlutterError(
          code: "unavailable",
          message: "Der Dokumentenscanner ist auf diesem Gerät nicht verfügbar.", details: nil))
      return
    }
    guard let host = presenter() else {
      result(FlutterError(code: "unavailable", message: "Keine Ansicht für den Scanner.", details: nil))
      return
    }
    let controller = VNDocumentCameraViewController()
    controller.delegate = self
    // Vollbild: kein Wegwischen ohne Rückmeldung an Dart.
    controller.modalPresentationStyle = .fullScreen
    pending = result
    host.present(controller, animated: true)
  }

  func documentCameraViewController(
    _ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan
  ) {
    controller.dismiss(animated: true)
    guard let result = pending else { return }
    pending = nil
    var pages: [UIImage] = []
    for index in 0..<scan.pageCount {
      pages.append(scan.imageOfPage(at: index))
    }
    if pages.isEmpty {
      result(nil)
      return
    }
    DispatchQueue.global(qos: .userInitiated).async {
      let value: Any?
      do {
        value = try Self.writeScan(pages)
      } catch {
        value = FlutterError(
          code: "failed", message: "Scan nicht gespeichert: \(error.localizedDescription)",
          details: nil)
      }
      DispatchQueue.main.async { result(value) }
    }
  }

  func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
    controller.dismiss(animated: true)
    let result = pending
    pending = nil
    result?(nil)
  }

  func documentCameraViewController(
    _ controller: VNDocumentCameraViewController, didFailWithError error: Error
  ) {
    controller.dismiss(animated: true)
    let result = pending
    pending = nil
    result?(
      FlutterError(
        code: "unavailable", message: "Scanner-Fehler: \(error.localizedDescription)", details: nil))
  }

  /// Seiten als JPEG + ein PDF (je Seite DIN A4, Bild eingepasst).
  private static func writeScan(_ pages: [UIImage]) throws -> [String: Any] {
    let dir = try scansDirectory()
    let stamp = UUID().uuidString
    var images: [String] = []
    var jpegs: [Data] = []
    for (index, page) in pages.enumerated() {
      guard let data = page.jpegData(compressionQuality: 0.85) else {
        throw ScanError.encoding
      }
      let url = dir.appendingPathComponent("scan_\(stamp)_\(index).jpg")
      try data.write(to: url, options: [.atomic, .completeFileProtection])
      images.append(url.path)
      jpegs.append(data)
    }
    let pdfURL = dir.appendingPathComponent("scan_\(stamp).pdf")
    let a4 = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    let renderer = UIGraphicsPDFRenderer(bounds: a4)
    let pdf = renderer.pdfData { context in
      for data in jpegs {
        // Aus den JPEG-Daten gezeichnet: das PDF bettet sie komprimiert ein.
        guard let image = UIImage(data: data) else { continue }
        let landscape = image.size.width > image.size.height
        let bounds = landscape ? CGRect(x: 0, y: 0, width: a4.height, height: a4.width) : a4
        context.beginPage(withBounds: bounds, pageInfo: [:])
        image.draw(in: fit(image.size, into: bounds))
      }
    }
    try pdf.write(to: pdfURL, options: [.atomic, .completeFileProtection])
    return ["pdf": pdfURL.path, "images": images]
  }

  private static func fit(_ size: CGSize, into bounds: CGRect) -> CGRect {
    guard size.width > 0, size.height > 0 else { return bounds }
    let scale = min(bounds.width / size.width, bounds.height / size.height)
    let width = size.width * scale
    let height = size.height * scale
    return CGRect(
      x: bounds.midX - width / 2, y: bounds.midY - height / 2, width: width, height: height)
  }

  // MARK: Foto

  private func takePhoto(_ result: @escaping FlutterResult) {
    if pending != nil || pendingPhoto != nil {
      result(FlutterError(code: "busy", message: "Es läuft bereits eine Aufnahme.", details: nil))
      return
    }
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      result(FlutterError(code: "unavailable", message: "Keine Kamera verfügbar.", details: nil))
      return
    }
    guard let host = presenter() else {
      result(FlutterError(code: "unavailable", message: "Keine Ansicht für die Kamera.", details: nil))
      return
    }
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.mediaTypes = ["public.image"]
    picker.delegate = self
    picker.modalPresentationStyle = .fullScreen
    pendingPhoto = result
    host.present(picker, animated: true)
  }

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    picker.dismiss(animated: true)
    guard let result = pendingPhoto else { return }
    pendingPhoto = nil
    guard let image = info[.originalImage] as? UIImage else {
      result(nil)
      return
    }
    DispatchQueue.global(qos: .userInitiated).async {
      let value: Any?
      do {
        value = try Self.writePhoto(image)
      } catch {
        value = FlutterError(
          code: "failed", message: "Foto nicht gespeichert: \(error.localizedDescription)",
          details: nil)
      }
      DispatchQueue.main.async { result(value) }
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
    let result = pendingPhoto
    pendingPhoto = nil
    result?(nil)
  }

  /// Ausrichtung fest einrechnen: PDF und Texterkennung lesen EXIF nicht
  /// überall gleich.
  private static func writePhoto(_ image: UIImage) throws -> String {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    let upright = UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
      image.draw(in: CGRect(origin: .zero, size: image.size))
    }
    guard let data = upright.jpegData(compressionQuality: 0.9) else {
      throw ScanError.encoding
    }
    let url = try scansDirectory().appendingPathComponent("photo_\(UUID().uuidString).jpg")
    try data.write(to: url, options: [.atomic, .completeFileProtection])
    return url.path
  }

  private enum ScanError: LocalizedError {
    case encoding
    var errorDescription: String? { "Bild konnte nicht kodiert werden" }
  }

  /// `Library/Caches/scans` — entspricht `getTemporaryDirectory()/scans` in Dart.
  private static func scansDirectory() throws -> URL {
    let caches = try FileManager.default.url(
      for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let dir = caches.appendingPathComponent("scans", isDirectory: true)
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    return dir
  }
}
