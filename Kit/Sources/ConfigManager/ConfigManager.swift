import Foundation
import Combine

public protocol ConfigManager {
    var configPublisher: AnyPublisher<Config, Never> { get }
    func getConfig() async
    func saveCurrentConfig() async
}

/// Class for managing XCodeLocalizationHelper's config
public final class ConfigManagerImpl: ConfigManager {
    // MARK: - Properties
    
    /// Default config
    private let defaultConfig: Config = .init(
        automation: .init(
            script: "Pods/swiftgen/bin/swiftgen config run --config swiftgen.yml",
            pathType: .relative
        )
    )
    
    /// Current config
    private let currentConfigSubject: CurrentValueSubject<Config, Never>
    
    /// Repository
    private let repository: ConfigRepository
    
    // MARK: - Public properties

    public var configPublisher: AnyPublisher<Config, Never> {
        currentConfigSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer

    public init(repository: ConfigRepository) {
        self.repository = repository
        currentConfigSubject = .init(defaultConfig)
    }
    
    // MARK: - Methods

    /// Get current project's config or return defaultConfig
    public func getConfig() async {
        // get project config
        if let config = try? await repository.getConfig() {
            currentConfigSubject.send(config)
        } else {
            currentConfigSubject.send(defaultConfig)
            await saveCurrentConfig()
        }
    }
    
    /// Save current config
    public func saveCurrentConfig() async {
        try? await repository.saveConfig(currentConfigSubject.value)
    }
}
