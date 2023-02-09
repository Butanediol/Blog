import Foundation
import Ink
import Plot
import Publish
import RegexBuilder

public extension Plugin {
    static func note() -> Self {
        Plugin(name: "Note") { context in
            context.markdownParser.addModifier(.note())
        }
    }
}

public extension Modifier {
    static func note() -> Self {
        return Modifier(target: .codeBlocks) { html, markdown in
            guard let content = markdown.firstSubstring(between: .prefix("```note."), and: .suffix("\nendnote\n```")),
                  let noteTypeString = content.split(separator: "\n").first,
                  let noteType = NoteType(rawValue: String(noteTypeString))
            else {
                return html
            }

            let contentString = content
                .split(separator: "\n")
                .dropFirst()
                .joined()

            return Div {
                Markdown(contentString)
            }
            .class("note")
            .class("note-\(noteType.rawValue)")
            .render()
        }
    }
}

private enum NoteType: String {
    case primary
    case secondary
    case success
    case danger
    case warning
    case info
    case light

    var primaryColor: String {
        switch self {
        case .primary: return "#6944ba"
        case .secondary: return "#777777"
        case .success: return "#74b666"
        case .danger: return "#c95c54"
        case .warning: return "#e6b05f"
        case .info: return "#5589c5"
        case .light: return "#0f0f0f"
        }
    }

    var secondaryColor: String {
        switch self {
        case .primary: return "#f4f0f9"
        case .secondary: return "#f7f7f7"
        case .success: return "#f1f8f1"
        case .danger: return "#faf1f2"
        case .warning: return "#fcf8e8"
        case .info: return "#f0f7fa"
        case .light: return "#fefefe"
        }
    }
}
