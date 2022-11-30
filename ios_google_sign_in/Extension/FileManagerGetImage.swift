//
// Created by Рамиль Зиганшин on 29.11.2022.
//

import UIKit

extension FileManager {
    func getImageInBundle(bundlePath: String) -> UIImage? {
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent(bundlePath)
        return UIImage.init(contentsOfFile: assetURL.relativePath)
    }
}
