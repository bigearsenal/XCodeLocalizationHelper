import Foundation

/// LineReader for reading lines in a text file
public class LineReader: Sequence {

    // MARK: - Nested type

    public struct Result: Equatable {
        public let string: String
        public let offset: Int
        public let length: Int
    }

    // MARK: - Properties

    private let encoding: String.Encoding
    private let chunkSize: Int
    private let fileHandle: FileHandle
    private let delimPattern : Data
    
    private var buffer: Data
    private var offset: Int = 0
    private var length: Int = 0
    
    // MARK: - Public properties

    public private(set) var isAtEOF: Bool = false
    
    // MARK: - Initializer

    public init?(
        path: String,
        delimeter: String = "\n",
        encoding: String.Encoding = .utf8,
        chunkSize: Int = 4096
    ) {
        guard let fileHandle = FileHandle(forReadingAtPath: path) else { return nil }
        self.fileHandle = fileHandle
        self.chunkSize = chunkSize
        self.encoding = encoding
        buffer = Data(capacity: chunkSize)
        delimPattern = delimeter.data(using: .utf8)!
    }
    
    deinit {
        fileHandle.closeFile()
    }

    // MARK: - Methods

    public func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.removeAll(keepingCapacity: true)
        isAtEOF = false
    }
    
    public func nextLine() -> String? {
        if isAtEOF { return nil }
        
        repeat {
            if let range = buffer.range(of: delimPattern, options: [], in: buffer.startIndex..<buffer.endIndex) {
                let subData = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
                let line = String(data: subData, encoding: encoding)
                buffer.replaceSubrange(buffer.startIndex..<range.upperBound, with: [])
                offset += subData.count + 1
                length = subData.count
                return line
            } else {
                let tempData = fileHandle.readData(ofLength: chunkSize)
                if tempData.count == 0 {
                    isAtEOF = true
                    length = 0
                    return (buffer.count > 0) ? String(data: buffer, encoding: encoding) : nil
                }
                length = tempData.count
                buffer.append(tempData)
            }
        } while true
    }
}

extension LineReader {
    public func makeIterator() -> AnyIterator<LineReader.Result> {
        .init {
            // get offset before calling nextLine
            let offset = self.offset
            
            // call next line
            guard let string = self.nextLine() else {
                return nil
            }
            
            // return result
            return .init(string: string, offset: offset, length: self.length)
        }
    }
}
