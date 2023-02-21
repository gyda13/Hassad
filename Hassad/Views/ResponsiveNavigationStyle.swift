//
//  ResponsiveNavigationStyle.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//


import SwiftUI

struct ResponsiveNavigationStyle: ViewModifier {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  @ViewBuilder
  func body(content: Content) -> some View {
    if horizontalSizeClass == .compact { /// iPhone
      content.navigationViewStyle(StackNavigationViewStyle())
    } else { /// iPad or larger iPhone in landscape
      content.navigationViewStyle(StackNavigationViewStyle())
    }
  }
}
