//
//  BundleHelper.swift
//  DHLCustomDropDown
//
//  Created by Daniel Hernandez on 26/06/2026.
//

import Foundation

private class BundleToken {}

extension Bundle {
    static var dhlResources: Bundle {
        let podBundle = Bundle(for: BundleToken.self)

        guard let url = podBundle.url(forResource: "DHLCustomDatePickerResources", withExtension: "bundle"),
              let bundle = Bundle(url: url) else {
            fatalError("No se pudo encontrar DHLCustomDatePickerResources.bundle")
        }

        return bundle
    }
}
