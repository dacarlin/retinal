import Foundation

struct Atom {
    let atomId: String
    let atomName: String
    let residueName: String
    let chainId: Character
    let residueNumber: Int
    let x: Double
    let y: Double
    let z: Double
}

func parsePDBFile(filePath: String) -> [Atom] {
    var atoms: [Atom] = []

    guard let pdbContent = try? String(contentsOfFile: filePath) else {
        print("jkjkjkķ")
        return atoms
    }

    let lines = pdbContent.components(separatedBy: .newlines)
    print(lines)
    for line in lines {
        if line.starts(with: "ATOM") {
            let atomId = line[line.index(line.startIndex, offsetBy: 6)..<line.index(line.startIndex, offsetBy: 11)].trimmingCharacters(in: .whitespacesAndNewlines)
            let atomName = line[line.index(line.startIndex, offsetBy: 12)..<line.index(line.startIndex, offsetBy: 16)].trimmingCharacters(in: .whitespacesAndNewlines)
            let residueName = line[line.index(line.startIndex, offsetBy: 17)..<line.index(line.startIndex, offsetBy: 20)].trimmingCharacters(in: .whitespacesAndNewlines)
            let chainId = line[line.index(line.startIndex, offsetBy: 21)]
            let residueNumber = Int(line[line.index(line.startIndex, offsetBy: 22)..<line.index(line.startIndex, offsetBy: 26)].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            let x = Double(line[line.index(line.startIndex, offsetBy: 30)..<line.index(line.startIndex, offsetBy: 38)].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
            let y = Double(line[line.index(line.startIndex, offsetBy: 38)..<line.index(line.startIndex, offsetBy: 46)].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
            let z = Double(line[line.index(line.startIndex, offsetBy: 46)..<line.index(line.startIndex, offsetBy: 54)].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0

            let atom = Atom(atomId: atomId, atomName: atomName, residueName: residueName, chainId: chainId, residueNumber: residueNumber, x: x, y: y, z: z)
            atoms.append(atom)
        }
    }

    return atoms
}
