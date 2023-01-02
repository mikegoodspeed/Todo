//
//  ContentView.swift
//  Todo
//
//  Created by Mike Goodspeed on 1/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newTodo = ""
    @State private var todos: [TodoItem] = []
    private let key = "WesTodo"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add todo...", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit(addTodo)
                    Button("Add", action: addTodo)
                        .buttonStyle(.borderedProminent)
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                List {
                    ForEach(todos) { item in
                        Text(item.value)
                    }
                    .onDelete(perform: self.deleteTodo)
                }
                .listStyle(.inset)
            }
            .navigationTitle("Wesley's Todo List")
        }
        .onAppear(perform: self.loadTodos)
    }
    
    private func addTodo() {
        guard !self.newTodo.isEmpty else { return }
        self.todos.append(TodoItem(value: self.newTodo))
        self.newTodo = ""
        self.saveTodos()
    }
    
    private func saveTodos() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.todos), forKey: self.key)
    }
    
    private func loadTodos() {
        if let data = UserDefaults.standard.value(forKey: self.key) as? Data {
            if let parsedTodos = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: data) {
                self.todos = parsedTodos
            }
        }
    }
    
    private func deleteTodo(offsets: IndexSet) {
        self.todos.remove(atOffsets: offsets)
        self.saveTodos()
    }
}

struct TodoItem: Codable, Identifiable {
    var id: UUID = UUID()
    var value: String
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
