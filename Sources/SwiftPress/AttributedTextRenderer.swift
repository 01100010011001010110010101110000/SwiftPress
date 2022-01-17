// Copyright (C) 2020 Tyler Gregory (@01100010011001010110010101110000)
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <http://www.gnu.org/licenses/>.

import Foundation
import Markdown
import SwiftUI

public extension SwiftPress {
  struct AttributedTextRenderer: MarkupVisitor {
    // MARK: Public

    public mutating func defaultVisit(_ markup: Markup) -> AttributedString {
      renderChildren(markup)
    }

    public mutating func visitText(_ text: Markdown.Text) -> AttributedString {
      AttributedString(text.string)
    }

    public mutating func visitLink(_ link: Markdown.Link) -> AttributedString {
      var result = renderChildren(link)
      guard let destination = link.destination else { return result }
      result.link = URL(string: destination)
      return result
    }

    public mutating func visitSoftBreak(_: SoftBreak) -> AttributedString {
      var result = AttributedString(" ")
      result.inlinePresentationIntent = .softBreak
      return result
    }

    public mutating func visitLineBreak(_: LineBreak) -> AttributedString {
      var result = AttributedString("\n")
      result.inlinePresentationIntent = .lineBreak
      return result
    }

    public mutating func visitEmphasis(_ emphasis: Emphasis) -> AttributedString {
      var result = renderChildren(emphasis)
      result = result.transformingAttributes(\.font) { transformer in
        transformer.value = (transformer.value ?? .body).italic()
      }
      return result
    }

    public mutating func visitStrong(_ strong: Strong) -> AttributedString {
      var result = renderChildren(strong)
      result = result.transformingAttributes(\.font) { transformer in
        transformer.value = (transformer.value ?? .body).bold()
      }
      return result
    }

    public mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> AttributedString {
      var result = renderChildren(strikethrough)
      result.strikethroughStyle = .single
      return result
    }

    public mutating func visitParagraph(_ paragraph: Paragraph) -> AttributedString {
      renderChildren(paragraph) + "\n"
    }

    public mutating func visitHeading(_ heading: Heading) -> AttributedString {
      var result = renderChildren(heading)
      result.foregroundColor = .red
      result.font = .system(size: .init(32))
      return result
    }

    public mutating func visitInlineCode(_ inlineCode: InlineCode) -> AttributedString {
      var result = AttributedString(inlineCode.code)
      result.inlinePresentationIntent = .code
      return result
    }

    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> AttributedString {
      var result = AttributedString(codeBlock.code)
      result.inlinePresentationIntent = .code
      result.languageIdentifier = codeBlock.language
      return result
    }

    public mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> AttributedString {
      let prevListType = listType
      listDepth += 1
      listType = .unordered

      let result = renderChildren(unorderedList)

      listType = prevListType
      listDepth -= 1

      return result
    }

    public mutating func visitOrderedList(_ orderedList: OrderedList) -> AttributedString {
      let prevListType = listType
      listDepth += 1
      listType = .ordered

      let result = renderChildren(orderedList)

      listType = prevListType
      listDepth -= 1

      return result
    }

    public mutating func visitListItem(_ listItem: ListItem) -> AttributedString {
      let prefix = listItem.itemPrefix(for: listType!, atDepth: listDepth)
      let spacing = String(repeating: " ", count: 4 * Int(listDepth - 1))
      return AttributedString("\(spacing)\(prefix) ") + renderChildren(listItem)
    }

    public mutating func visitImage(_ image: Markdown.Image) -> AttributedString {
      var result = renderChildren(image)
      result.imageURL = URL(string: image.source!)
      result.alternateDescription = image.title
      result.toolTip = image.title
      return result
    }

    public mutating func visitTableCell(_ tableCell: Markdown.Table.Cell) -> AttributedString {
      renderChildren(tableCell)
    }

    // MARK: Private

    private var listType: MarkdownListType?
    private var listDepth: UInt = 0

    private mutating func renderChildren(_ markup: Markup) -> AttributedString {
      var result = AttributedString()
      for child in markup.children {
        result += visit(child)
      }
      return result
    }
  }
}
