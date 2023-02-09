import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case categories
    }

    struct ItemMetadata: WebsiteItemMetadata {
        let updated: Date
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://blog.butanediol.me")!
    var name = "丁丁の店"
    var description = "我的名字上有两个字，一个是“丁”，另一个也是“丁” —— 节选自《节选自〈节选〉》"
    var language: Language { .chinese }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try Blog().publish(
    using: [
        .installPlugin(.splash(withClassPrefix: "")),
        .installPlugin(.note()),
        .addMarkdownFiles(),
        .copyResources(),
        .generateHTML(withTheme: .xnh),
        .generateRSSFeed(including: [.posts]),
        .generateSiteMap(),
    ]
)