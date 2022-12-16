//
// Created by Рамиль Зиганшин on 09.12.2022.
//

import UIKit

extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl: String {
        return self.removingPercentEncoding!
    }
}
