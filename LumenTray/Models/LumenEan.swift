import Foundation

enum LumenEan {
    static func normalize(_ raw: String) -> String? {
        let runs = digitRuns(raw)
        guard let pick = pickRun(runs) else { return nil }
        if pick.count == 12 { return "0" + pick }
        if (8...14).contains(pick.count) { return pick }
        return nil
    }

    static func digitRuns(_ raw: String) -> [String] {
        var runs: [String] = []
        var buffer = ""
        for character in raw {
            if character.isNumber {
                buffer.append(character)
            } else if !buffer.isEmpty {
                runs.append(buffer)
                buffer = ""
            }
        }
        if !buffer.isEmpty { runs.append(buffer) }
        return runs
    }

    static func pickRun(_ runs: [String]) -> String? {
        if let thirteen = runs.first(where: { $0.count == 13 }) { return thirteen }
        if let ranged = runs.first(where: { (8...14).contains($0.count) }) { return ranged }
        return runs.max(by: { $0.count < $1.count })
    }
}
