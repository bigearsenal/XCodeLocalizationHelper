import Foundation

public protocol ConfigRepository {
    func getConfig() async throws -> Config
    func saveConfig(_ config: Config) async throws
}

/// Config reader for XCodeLocalizationHelper
public actor ConfigRepositoryImpl: ConfigRepository {
    // MARK: - Properties
    
    /// Default config JSON file name inside project (Optional)
    private let configJSONFileName = ".xcode-localization-helper-config.json"
    
    /// Directory of the project
    private let projectDir: String
    
    /// Config file absolute path
    private var absoluteConfigFilePath: String {
        projectDir + "/" + configJSONFileName
    }
    
    // MARK: - Initializer
    
    /// Initializer
    /// - Parameter projectDir: directory of the project
    public init(projectDir: String) {
        self.projectDir = projectDir
    }
    
    // MARK: - Method
    
    /// Get XCodeLocalizationHelper from
    /// - Returns: XCodeLocalizationHelper's config
    public func getConfig() throws -> Config {
        // read the json
        guard let fileHandler = FileHandle(forReadingAtPath: absoluteConfigFilePath)
        else {
            throw ConfigRepositoryError.couldNotOpenFile
        }
        
        guard let data = try fileHandler.readToEnd()
        else {
            throw ConfigRepositoryError.invalidFileFormat
        }
        let config = try JSONDecoder().decode(Config.self, from: data)
        return config
    }
    
    /// Save XCodeLocalizationHelper
    public func saveConfig(_ config: Config) throws {
        // construct file handler
        guard let fileHandler = FileHandle(forWritingAtPath: absoluteConfigFilePath)
        else {
            throw ConfigRepositoryError.couldNotOpenFile
        }
        
        // erase old data
        try fileHandler.truncate(atOffset: 0)
        try fileHandler.seek(toOffset: 0)
        
        // rewrite config
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(config)
        fileHandler.write(data)
    }
}
