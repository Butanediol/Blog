import Foundation
import Plot
import Publish

struct SystemWindow: Component {
	let scaleDown: Bool
	@ComponentBuilder var content: Component

	init(scaleDown: Bool = false, @ComponentBuilder content: @escaping ContentProvider) {
		self.content = content()
		self.scaleDown = scaleDown
	}

	var body: Component {
		Div {
			content
		}
		.class("window")
		.class(scaleDown ? "scale-down" : "")
	}
}

struct SystemTitleBar: Component {
	let inactive: Bool
	@ComponentBuilder var content: Component

	init(inactive: Bool = false, @ComponentBuilder content: @escaping ContentProvider) {
		self.content = content()
		self.inactive = inactive
	}

	var body: Component {
		Div {
			content
		}
		.class(inactive ? "inactive-title-bar" : "title-bar")
	}
}

struct SystemDetailsBar: Component {
	@ComponentBuilder var content: Component

	var body: Component {
		Div {
            content
        }
        .class("details-bar")
	}
}

struct SystemWindowPane: Component {
	@ComponentBuilder var content: Component

	var body: Component {
		Div {
            content
        }
        .class("window-pane")
	}
}

struct SystemStandardDialog: Component {
	let center: Bool
	let scaleDown: Bool
	@ComponentBuilder var content: Component

	init(center: Bool = false, scaleDown: Bool = false, @ComponentBuilder content: @escaping ContentProvider) {
		self.content = content()
		self.center = center
		self.scaleDown = scaleDown
	}

	var body: Component {
		Div {
            content
        }
        .class("standard-dialog")
        .class(center ? "center" : "")
        .class(scaleDown ? "scale-down" : "")
	}
}

struct SystemCloseButton: Component {
	var body: Component {
		Button()
		.class("close")
		.attribute(named: "aria-label", value: "Close")
	}
}

struct SystemSeparator: Component {
	var body: Component {
		Div()
		.class("separator")
	}
}

struct SystemResizeButton: Component {
	var body: Component {
		Button()
		.class("resize")
		.attribute(named: "aria-label", value: "Resize")
	}
}

struct SystemTitle: Component {
	@ComponentBuilder let content: Component

	init(_ text: String) {
		self.content = Span(text)
	}

	init(@ComponentBuilder content: @escaping ContentProvider) {
		self.content = content()
	}

	var body: Component {
		content
            .class("title")
	}
}

struct SystemButton: Component {
	let text: String

	init(_ text: String) {
		self.text = text
	}
	
	var body: Component {
		Button(text)
			.class("btn")
	}
}