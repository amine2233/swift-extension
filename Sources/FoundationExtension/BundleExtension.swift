//
//  BundleExtension.swift
//  XebiaiOS
//
//  Created by Amine Bensalah on 13/01/2017.
//  Copyright © 2017 nebuladev.info. All rights reserved.
//

import Foundation

public extension Bundle {
    var bundleName: String? {
        infoDictionary?["CFBundleName"] as? String
    }

    var appName: String? {
        infoDictionary?["CFBundleDisplayName"] as? String
    }

    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    var appEnvironement: String? {
        infoDictionary?["WCAppName"] as? String
    }
}
