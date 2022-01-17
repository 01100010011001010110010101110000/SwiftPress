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

// MARK: - Markdown.Table.Row + Identifiable

extension Markdown.Table.Row: Identifiable {
  public var id: Int {
    indexInParent
  }
}

extension Markdown.Table.ColumnAlignment {
  // TODO: Needs localization
  func toAlignment() -> SwiftUI.Alignment {
    switch self {
    case .center:
      return .center
    case .left:
      return .leading
    case .right:
      return .trailing
    }
  }
}
