// swift-tools-version: 5.9

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "WhatToWatch",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "WhatToWatch",
            targets: ["WhatToWatch"],
            bundleIdentifier: "com.whattowatch.app",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .tv),
            accentColor: .presetColor(.purple),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "WhatToWatch",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
