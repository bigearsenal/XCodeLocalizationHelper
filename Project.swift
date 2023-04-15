import ProjectDescription // <1>

let projectName = "LocalizationHelper"
let bundleIdMacOS = "info.bigears.LocalizationHelper"
let kitName = projectName + "Kit"

let spm: [String: Package] = [
    "Alamofire": .remote(
        url: "https://github.com/Alamofire/Alamofire.git",
        requirement: .upToNextMajor(from: "5.4.0")
    ),
    "XcodeProj": .remote(
        url: "https://github.com/tuist/xcodeproj.git",
        requirement: .upToNextMajor(from: "8.0.0")
    ),
    "Resolver": .remote(
        url: "https://github.com/hmlongco/Resolver.git",
        requirement: .upToNextMajor(from: "1.4.3")
    )
]

let macOSTargets = makeKitFrameworkTargets(platform: .macOS, spm: spm.map {$0.key}) +
    createAppTarget(platform: .macOS, bundleId: bundleIdMacOS)

let project = Project(
    name: projectName,
    packages: spm.map {$0.value},
    targets: macOSTargets
)

private func createAppTarget(
    platform: Platform,
    bundleId: String,
    spm: [String] = []
) -> [Target] {
    let name = projectName
    let platformDir = "Apps"
    
    return [
        Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: bundleId,
            deploymentTarget: .macOS(targetVersion: "12.0"),
            infoPlist: .file(path: .init(platformDir + "/Info.plist")),
            sources: [
                "\(platformDir)/Sources/**"
            ],
            resources: [
                "\(platformDir)/Resources/**"
            ],
            dependencies: [.target(name: kitName)]
                + spm.map {TargetDependency.package(product: $0) }
        ),
        Target(
            name: name + "Tests",
            platform: platform,
            product: .unitTests,
            bundleId: bundleId + "Tests",
            deploymentTarget: .macOS(targetVersion: "12.0"),
            infoPlist: .default,
            sources: [
                "\(platformDir)/Tests/**"
            ],
            dependencies: [
                .target(name: "\(name)")
            ])
    ]
}

/// Helper function to create a framework target and an associated unit test target
private func makeKitFrameworkTargets(platform: Platform, spm: [String] = []) -> [Target] {
    let kitBundleId = bundleIdMacOS + "Kit"
    let name = kitName
    
    let sources = Target(
        name: name,
        platform: platform,
        product: .framework,
        bundleId: kitBundleId,
        deploymentTarget: .macOS(targetVersion: "12.0"),
        infoPlist: .default,
        sources: ["Kit/Sources/**"],
        resources: [],
        dependencies: spm.map {TargetDependency.package(product: $0) }
    )
    let tests = Target(
        name: "\(name)Tests",
        platform: platform,
        product: .unitTests,
        bundleId: kitBundleId + "Tests",
        deploymentTarget: .macOS(targetVersion: "12.0"),
        infoPlist: .default,
        sources: ["Kit/Tests/**"],
        resources: [],
        dependencies: [
            .target(name: name)
        ]
    )
    return [sources, tests]
}
