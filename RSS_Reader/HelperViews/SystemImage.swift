//
//  Icon.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// All SystemImages Strings in app, easily to get
enum SystemImage {
    /// SideMenuView
    case all
    case bookmarked
    /// MainView
    case side_menu
    case hide_read
    case show_read
    case settings
    case share
    case search
    case sensitive
    case insensitive
    /// settings
    case feed_settings
    case collection_settings
    case option_auto_refresh
    case option_theme
    case no_style
    case square_style
    case square_round_style
    case circle_style
    case option_image_style
    case option_icon_size
    case option_reset_app
    /// several occurences
    case add
    case trash
    case folder
    case edit
    case check
    case xmark
    case minus
    case plus
    case circle_small
    case close
    case forward
    case bookmark
    case unmark

    /// returns the String of specific SystemImages
    var name: String {
        switch self {
        case .side_menu:
            return "sidebar.left"
        case .all:
            return "infinity.circle"
        case .bookmark:
            return "bookmark.fill"
        case .unmark:
            return "bookmark"
        case .hide_read:
            return "eye.fill"
        case .show_read:
            return "eye"
        case .settings:
            return "gear"
        case .share:
            return "square.and.arrow.up"
        case .search:
            return "magnifyingglass"
        case .sensitive:
            return "textformat"
        case .insensitive:
            return "textformat.size.larger"
        case .feed_settings:
            return "newspaper"
        case .collection_settings:
            return "folder"
        case .option_auto_refresh:
            return "arrow.clockwise"
        case .option_theme:
            return "paintpalette"
        case .add:
            return "plus"
        case .trash:
            return "trash"
        case .folder:
            return "folder"
        case .edit:
            return "pencil"
        case .check:
            return "checkmark"
        case .xmark:
            return "xmark.circle.fill"
        case .minus:
            return "minus.circle.fill"
        case .plus:
            return "plus.circle.fill"
        case .circle_small:
            return "circle.fill"
        case .close:
            return "xmark"
        case .forward:
            return "chevron.forward"
        case .no_style:
            return "square.dashed"
        case .square_style:
            return "squareshape"
        case .square_round_style:
            return "square"
        case .circle_style:
            return "circle"
        case .option_image_style:
            return "cursorarrow.and.square.on.square.dashed"
        case .option_icon_size:
            return "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"
        case .option_reset_app:
            return "doc.badge.gearshape"
        case .bookmarked:
            return "bookmark.circle"
        }
    }
    
    /// returns the Image of specific SystemImage
    var image: Image {
        switch  self {
        default:
            return Image(systemName: self.name)
        }
    }
}
