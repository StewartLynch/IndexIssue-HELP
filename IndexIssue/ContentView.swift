//
//  ContentView.swift
//  IndexIssue
//
//  Created by Stewart Lynch on 2020-09-24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var itemsVM = ItemViewModel()
    @State private var selectedItem:Item?
    var body: some View {
        VStack {
            List {
                ForEach(itemsVM.items) { item in
                    Button(action: {
                        selectedItem = item
                    }) {
                        Text(item.name)
                    }
                }
            }
        }.sheet(item: $selectedItem) { item in
            ItemView(itemsVM: itemsVM, item: $itemsVM.items[itemsVM.items.firstIndex{$0.id == item.id}!])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Other stuff
// MARK: - Item Detail View
struct ItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var itemsVM:ItemViewModel
    @Binding var item:Item
    var body: some View {
        VStack {
            Text("\(item.name)")
            Button("Delete") {
                let index = itemsVM.items.firstIndex{$0.id == item.id}!
                itemsVM.items.remove(at: index)
                presentationMode.wrappedValue.dismiss()
                
            }
        }
    }
}

// MARK: - Model
struct Item: Identifiable {
    var id = UUID()
    var name: String
}

// MARK: - View Model
class ItemViewModel:ObservableObject {
    @Published var items: [Item]
    init() {
        items = [
            Item(name: "one"),
            Item(name: "two"),
            Item(name: "three"),
        ]
    }
}

