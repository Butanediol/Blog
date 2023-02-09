import Foundation
import Plot
import Publish

extension Theme {
    public static var xnh: Self {
        Theme(
            htmlFactory: XNHThemeFactory<Site>(),
            resourcePaths: ["Resources/XNH/styles.css"]
        )

    }
}

private struct XNHThemeFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Publish.Index, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .link(
                rel: "stylesheet", 
                href: "https://unpkg.com/@sakun/system.css"
            ),
            .link(
                rel: "preconnect", 
                href: "https://fonts.googleapis.com"
            ),
            .link(
                rel: "preconnect", 
                href: "https://fonts.gstatic.com"
            ),
            .link(
                rel: "stylesheet", 
                href: "https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@200;400;600;900&display=swap"
            ),
            .body {
                XNHThemeHeader(context: context)

                SystemTitleBar(inactive: true) {
                    H1("Home")
                        .class("title")
                }

                for item in context.allItems(sortedBy: \.date, order: .descending) {
                    XNHThemePostCard(item: item)
                }

                SystemStandardDialog(center: true, scaleDown: true) {
                    H1(context.site.name)
                        .class("dialog-text")
                    Paragraph("Crafted &copy; 2019-2023 Butanediol")
                        .class("dialog-text")
                    Paragraph("Powered by Publish")
                        .class("dialog-text")
                }
                .style("width: 15rem;")
            }
        )
    }

    func makeSectionHTML(for section: Publish.Section<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .link(
                rel: "stylesheet", 
                href: "https://unpkg.com/@sakun/system.css"
            ),
            .link(
                rel: "preconnect", 
                href: "https://fonts.googleapis.com"
            ),
            .link(
                rel: "preconnect", 
                href: "https://fonts.gstatic.com"
            ),
            .link(
                rel: "stylesheet", 
                href: "https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@200;400;600;900&display=swap"
            ),
            .body {
                XNHThemeHeader(context: context)

                SystemTitleBar(inactive: true) {
                    H1(section.title)
                        .class("title")
                }

                for item in context.allItems(sortedBy: \.date, order: .descending) {
                    XNHThemePostCard(item: item)
                }

                SystemStandardDialog(center: true, scaleDown: true) {
                    H1(context.site.name)
                        .class("dialog-text")
                    Paragraph("Crafted &copy; 2019-2023 Butanediol")
                        .class("dialog-text")
                    Paragraph("Powered by Publish")
                        .class("dialog-text")
                }
                .style("width: 15rem;")
            }
        )
    }

    func makeItemHTML(for item: Publish.Item<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .link(
                rel: "stylesheet", 
                href: "https://unpkg.com/@sakun/system.css"
            ),
            .link(
                rel: "preconnect", 
                href: "https://fonts.googleapis.com"
            ),
            .link(
                rel: "preconnect", 
                href: "https://fonts.gstatic.com"
            ),
            .link(
                rel: "stylesheet", 
                href: "https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@200;400;600;900&display=swap"
            ),
            .body {
                XNHThemeHeader(context: context)

                SystemWindow(scaleDown: true) {
                    SystemTitleBar {
                        SystemCloseButton()
                        SystemTitle(item.title)
                    }
                    SystemSeparator()
                    SystemWindowPane {
                        Article {
                            Div(item.content.body)
                        }
                    }
                }

                SystemStandardDialog(center: true, scaleDown: true) {
                    H1(context.site.name)
                        .class("dialog-text")
                    Paragraph("Crafted &copy; 2019-2023 Butanediol")
                        .class("dialog-text")
                    Paragraph("Powered by Publish")
                        .class("dialog-text")
                }
                .style("width: 15rem;")
            }
        )
    }

    func makePageHTML(for page: Publish.Page, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            
        )
    }

    func makeTagListHTML(for page: Publish.TagListPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        HTML(
            
        )
    }

    func makeTagDetailsHTML(for page: Publish.TagDetailsPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        HTML(
        )
    }


}

private struct XNHThemePostCard<Site: Website>: Component {
    let item: Item<Site>

    var body: Component {
        SystemWindow(scaleDown: true) {
            SystemTitleBar {
                SystemCloseButton()
                SystemTitle(item.title)
            }
            SystemSeparator()
            if item.description != "" {
                SystemWindowPane {
                    Paragraph(item.description)
                    Link(url: item.path.absoluteString) {
                        SystemButton("阅读")
                    }
                    .style("float: right;")
                }
            }
        }
        .style("text-decoration: none;")
        .style("text-decoration-line: none;")
    }
}

private struct XNHThemeHeader<Site: Website>: Component {
    let context: PublishingContext<Site>

    var body: Component {
        Header {
            List {
                ListItem {
                    Text("Blog")
                    List {
                        for section in context.sections {
                            ListItem {
                                Link(section.title, url: section.path.absoluteString)
                            }
                            .attribute(named: "role", value: "menu-item")
                        }
                    }
                    .attribute(named: "role", value: "menu")
                }
                .attribute(named: "role", value: "menu-item")
                .attribute(named: "tabindex", value: "0")
                .attribute(named: "aria-haspopup", value: "true")
            }
            .attribute(named: "role", value: "menu-bar")

            SystemWindow {
                SystemTitleBar {
                    SystemTitle {
                        Link(url: "/") {
                            Span(context.site.name)
                        }
                    }
                }
            }
        }
    }
}

private extension Node where Context == HTML.DocumentContext {
    static func link(rel: String, href: String) -> Self {
        .element(
            named: "link", 
            attributes: [
                .init(name: "rel", value: rel),
                .init(name: "href", value: href)
            ]
        )
    }
}