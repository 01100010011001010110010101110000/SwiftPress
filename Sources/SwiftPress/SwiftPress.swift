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

import Markdown
import SwiftUI

// MARK: - SwiftPress

public struct SwiftPress {
  public init() {}
}

// MARK: MarkupVisitor

extension SwiftPress: MarkupVisitor {
  // MARK: Public

  public mutating func defaultVisit(_ markup: Markup) -> AnyView {
    renderChildren(markup: markup)
  }

  // MARK: Inline container nodes

  public mutating func visitText(_ text: Markdown.Text) -> AnyView {
    renderText(text)
  }

  public mutating func visitParagraph(_ paragraph: Paragraph) -> AnyView {
    renderText(paragraph)
  }

  public mutating func visitLink(_ link: Markdown.Link) -> AnyView {
    renderText(link)
  }

  public mutating func visitStrong(_ strong: Strong) -> AnyView {
    renderText(strong)
  }

  public mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> AnyView {
    renderText(strikethrough)
  }

  public mutating func visitImage(_ image: Markdown.Image) -> AnyView {
    renderText(image)
  }

  public mutating func visitEmphasis(_ emphasis: Emphasis) -> AnyView {
    renderText(emphasis)
  }

  public mutating func visitHeading(_ heading: Heading) -> AnyView {
    renderText(heading)
  }

  // MARK: Block nodes

  public mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> AnyView {
    renderText(unorderedList)
  }

  public mutating func visitOrderedList(_ orderedList: OrderedList) -> AnyView {
    renderText(orderedList)
  }

  public mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> AnyView {
    renderText(codeBlock)
  }

  public mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> AnyView {
    let children = renderChildren(markup: blockQuote)
    return HStack {
      RoundedRectangle(cornerRadius: 2.0)
        .frame(width: 5)
        .foregroundColor(.secondary)
      VStack(alignment: .leading) {
        children
      }
    }.erase()
  }

  public mutating func visitThematicBreak(_: ThematicBreak) -> AnyView {
    Divider()
      .erase()
  }

  public mutating func visitTable(_ table: Markdown.Table) -> AnyView {
    renderTable(table)
  }

  // MARK: Private

  private mutating func renderChildren(markup: Markup) -> AnyView {
    let array = Array(markup.children).map { visit($0) }
    return ForEach(array.indices, id: \.self) { idx in
      array[idx]
    }.erase()
  }

  private mutating func renderText(_ markup: Markup) -> AnyView {
    var renderer = AttributedTextRenderer()
    return SwiftUI.Text(renderer.visit(markup)).erase()
  }

  private mutating func renderTable(_ table: Markdown.Table) -> AnyView {
    guard !table.isEmpty else { return EmptyView().erase() }

    let rows = Array(table.body.rows)
    let rowContent: [[AnyView]] = rows.map { row in
      row.cells.map { cell in
        renderText(cell)
      }
    }

    let head = Array(table.head.cells)

    func unwrapCellAtIndex(_ index: Int, in row: Markdown.Table.Row, rowContent: [[AnyView]]) -> AnyView {
      rowContent[row.indexInParent][safe: index] ?? SwiftUI.Text(verbatim: "").erase()
    }

    switch table.head.childCount {
    case 1:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 2:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 3:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 4:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
        TableColumn(head[3].plainText) { unwrapCellAtIndex(3, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 5:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
        TableColumn(head[3].plainText) { unwrapCellAtIndex(3, in: $0, rowContent: rowContent) }
        TableColumn(head[4].plainText) { unwrapCellAtIndex(4, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 6:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
        TableColumn(head[3].plainText) { unwrapCellAtIndex(3, in: $0, rowContent: rowContent) }
        TableColumn(head[4].plainText) { unwrapCellAtIndex(4, in: $0, rowContent: rowContent) }
        TableColumn(head[5].plainText) { unwrapCellAtIndex(5, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 7:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
        TableColumn(head[3].plainText) { unwrapCellAtIndex(3, in: $0, rowContent: rowContent) }
        TableColumn(head[4].plainText) { unwrapCellAtIndex(4, in: $0, rowContent: rowContent) }
        TableColumn(head[5].plainText) { unwrapCellAtIndex(5, in: $0, rowContent: rowContent) }
        TableColumn(head[6].plainText) { unwrapCellAtIndex(6, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 8:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
        TableColumn(head[3].plainText) { unwrapCellAtIndex(3, in: $0, rowContent: rowContent) }
        TableColumn(head[4].plainText) { unwrapCellAtIndex(4, in: $0, rowContent: rowContent) }
        TableColumn(head[5].plainText) { unwrapCellAtIndex(5, in: $0, rowContent: rowContent) }
        TableColumn(head[6].plainText) { unwrapCellAtIndex(6, in: $0, rowContent: rowContent) }
        TableColumn(head[7].plainText) { unwrapCellAtIndex(7, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    case 9:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
        TableColumn(head[3].plainText) { unwrapCellAtIndex(3, in: $0, rowContent: rowContent) }
        TableColumn(head[4].plainText) { unwrapCellAtIndex(4, in: $0, rowContent: rowContent) }
        TableColumn(head[5].plainText) { unwrapCellAtIndex(5, in: $0, rowContent: rowContent) }
        TableColumn(head[6].plainText) { unwrapCellAtIndex(6, in: $0, rowContent: rowContent) }
        TableColumn(head[7].plainText) { unwrapCellAtIndex(7, in: $0, rowContent: rowContent) }
        TableColumn(head[8].plainText) { unwrapCellAtIndex(8, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    default:
      return SwiftUI.Table(rows) {
        TableColumn(head[0].plainText) { unwrapCellAtIndex(0, in: $0, rowContent: rowContent) }
        TableColumn(head[1].plainText) { unwrapCellAtIndex(1, in: $0, rowContent: rowContent) }
        TableColumn(head[2].plainText) { unwrapCellAtIndex(2, in: $0, rowContent: rowContent) }
        TableColumn(head[3].plainText) { unwrapCellAtIndex(3, in: $0, rowContent: rowContent) }
        TableColumn(head[4].plainText) { unwrapCellAtIndex(4, in: $0, rowContent: rowContent) }
        TableColumn(head[5].plainText) { unwrapCellAtIndex(5, in: $0, rowContent: rowContent) }
        TableColumn(head[6].plainText) { unwrapCellAtIndex(6, in: $0, rowContent: rowContent) }
        TableColumn(head[7].plainText) { unwrapCellAtIndex(7, in: $0, rowContent: rowContent) }
        TableColumn(head[8].plainText) { unwrapCellAtIndex(8, in: $0, rowContent: rowContent) }
        TableColumn(head[9].plainText) { unwrapCellAtIndex(9, in: $0, rowContent: rowContent) }
      }
      .frame(height: 30 * CGFloat(rows.count + 1))
      .erase()
    }
  }
}

private extension Collection {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

private extension View {
  func erase() -> AnyView {
    AnyView(erasing: self)
  }
}
