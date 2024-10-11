//
//  ContentView.swift
//  LiveActivityExample
//
//  Created by seregin-ma on 09.10.2024.
//

import SwiftUI
import SwiftData
import ActivityKit

// Сюда не смотреть, это бойлерплейт нового проекта
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    // захерячил сюда вью модель с форсом. не хотел опционалы использовать
    @StateObject var viewModel = try! ViewModel()
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

import Combine
// вью моделька для теста
final class ViewModel: ObservableObject {
    // прихранивать не обязательно, все активити должны быть в Activity<LiveActivityWidgetAttributes>.activities
    let activity: Activity<LiveActivityWidgetAttributes>
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var progress: Float = 0
    
    var disposables = Set<AnyCancellable>()
    
    init() throws {
        // создаем постоянные неизменяемые переменные. в моем примере не используется
        let attr = LiveActivityWidgetAttributes(name: "some name")
        
        // тут создаем просто стейет изначальный
        let state = LiveActivityWidgetAttributes.ContentState(progress: 0.0)
        
        // делаем запрос на разрешение использования активити
        // Также надо проверять какие активити уже созданы, потому как может быть создано дофигище этих активити.
        // активити отображается на лок скрине и в шторке уведомлений.
        activity = try Activity<LiveActivityWidgetAttributes>
            .request(
                attributes: attr,
                content: .init(
                    state: state,
                    // эта хреновина говорит до какого момента показывать виджет
                    staleDate: Date().advanced(by: 3600)
                )
            )
        bind()
    }
    
    // думаю тут все понятно; просто херячим таймер для обновления прогреса
    func bind() {
        timer.sink { _ in
            if self.progress < 1 {
                self.progress += 0.06
                Task { try await self.update(value: self.progress)}
            }
        }
        .store(in: &disposables)
    }
    
    // в симуляторе раз в секунду обновляет нормально, на телефоне почему-то были подлагивания, примерно раз в секунду, потом раз в 2 секунды, потом раз в 3 секунды
    // помимо апдейдта можно завершить LA принудительно await activity.end(nil)
    func update(value: Float) async throws {
        print(value)
        // создаем новый стейт
        let state = LiveActivityWidgetAttributes.ContentState( progress: value)
        // асинхронно обновляем стейт
        await activity.update(.init(state: state, staleDate: Date().advanced(by: 3600)))
    }
}
