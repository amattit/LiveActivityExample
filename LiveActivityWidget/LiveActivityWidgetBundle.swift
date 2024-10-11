//
//  LiveActivityWidgetBundle.swift
//  LiveActivityWidget
//
//  Created by seregin-ma on 09.10.2024.
//

import WidgetKit
import SwiftUI

// таким макаром активити и виджеты запускаются.
// можно добавить несколько виджетов подряд, допустим виджет для рабочего стола
@main
struct LiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveActivityWidgetLiveActivity()
    }
}
