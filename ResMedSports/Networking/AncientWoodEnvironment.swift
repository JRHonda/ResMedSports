//
//  AncientWoodEnvironment.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import struct Foundation.URL

struct AncientWoodEnvironment {
    // MARK: - Properties
    var baseURL: URL
}

extension AncientWoodEnvironment {
    static let prod = AncientWoodEnvironment(baseURL: URL(string: "https://ancient-wood-1161.getsandbox.com:443")!)
}
