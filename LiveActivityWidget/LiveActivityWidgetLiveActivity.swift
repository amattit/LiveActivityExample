//
//  LiveActivityWidgetLiveActivity.swift
//  LiveActivityWidget
//
//  Created by seregin-ma on 09.10.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

/// В таргете мы только описываем активити.
/// Управление и создание активити происходит из основного таргета приложения
/// ОБРАТИТЬ ВНИМАНИЕ, этот файл я пошарил между двумя таргетами, для удобства
/// в основном таргете обязательно надо в info.plist добавить Supports Live Activities = YES

struct LiveActivityWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // переменные, которые можно поменять лежат тут
        var progress: Float
    }
    // Переменные которые никогда не будут меняться лежат тут
    var name: String
}

struct LiveActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                HStack {
                    // это плейсхолдер для картинки. По идее ни кто не ограничивает на использование AsyncImage, Image
                    // просто не пробовал
                    // в переменные стейта можно передать url картинки и отобразить ее тут
                    ZStack {
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.black.opacity(0.3))
                        Text("PH")
                    }
                    // тут тоже хардкод. также добавляем переменные в стейт
                    VStack(alignment: .leading) {
                        Text("Harry Potter")
                            .font(.title)
                        Text("The Session")
                    }
                    Spacer()
                }
                ProgressView(value: context.state.progress)
                    .accentColor(.green)
                
                HStack {
                    // Кнопки не работают. начиная с 17 ios можно использовать Link вместо button
                    // Сам не проверял
                    Button(action: {}) {
                        Image(systemName: "backward.fill")
                    }
                    Button(action: {}) {
                        Image(systemName: "play.fill")
                    }
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                    }
                }
            }
            .activitySystemActionForegroundColor(Color.black)
        
        } dynamicIsland: { context in
            // не нашел инициализатора без динамического острова, можно закостылить таким образом
            // При этом при тапе на динамический остров будет открываться приложение
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    EmptyView()
                }
            } compactLeading: {
                EmptyView()
            } compactTrailing: {
                EmptyView()
            } minimal: {
                EmptyView()
            }
        }
    }
}

// превьюхи ради
extension LiveActivityWidgetAttributes {
    fileprivate static var preview: LiveActivityWidgetAttributes {
        LiveActivityWidgetAttributes(name: "World")
    }
}

extension LiveActivityWidgetAttributes.ContentState {
    fileprivate static var smiley: LiveActivityWidgetAttributes.ContentState {
        LiveActivityWidgetAttributes.ContentState(progress: 0.4)
     }
     
     fileprivate static var starEyes: LiveActivityWidgetAttributes.ContentState {
         LiveActivityWidgetAttributes.ContentState(progress: 0.8)
     }
}

#Preview("Notification", as: .content, using: LiveActivityWidgetAttributes.preview) {
   LiveActivityWidgetLiveActivity()
} contentStates: {
    LiveActivityWidgetAttributes.ContentState.smiley
    LiveActivityWidgetAttributes.ContentState.starEyes
}
