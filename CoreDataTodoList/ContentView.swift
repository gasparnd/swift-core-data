//
//  ContentView.swift
//  CoreDataTodoList
//
//  Created by Gaspar Dolcemascolo on 09/03/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ Todo.id, ascending: true)],
        animation: .default)
    private var todos: FetchedResults<Todo>
    @State private var showAddTodoView = false
    @State private var presetDeleteAlert = false
    static let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    let mockDate = Date()
    var body: some View {
        NavigationStack {
            VStack {
                if todos.isEmpty {
                        Button(action: {
                            self.showAddTodoView = true
                        }) {
                            HStack {
                            Text("Add task").font(.largeTitle).foregroundStyle(Color.secondary)
                            Image(systemName: "plus").foregroundStyle(Color.secondary)
                        }
                    }
                } else {
                    List {
                        ForEach(todos, id: \.id) { todo in
                            HStack {
                                Button(action: {
                                    togleTodo(todo: todo)
                                }, label: {
                                    Image(systemName: todo.done ? "checkmark.circle.fill" : "checkmark.circle")
                                        .font(.headline.bold()).foregroundStyle(todo.done ? Color.green : Color.gray)
                                })
                                VStack(alignment: .leading) {
                                    Text(todo.title ?? "").font(.headline.bold())
                                        .foregroundStyle(todo.done ? Color.secondary : Color.primary)
                                        .strikethrough(todo.done, color: .secondary)
                                    Text("\(todo.date ?? self.mockDate, formatter: Self.dateFormatter)").font(.caption).foregroundStyle(Color.secondary)
                                        .strikethrough(todo.done, color: .secondary)
                                }
                            }
                            
                        }.onDelete(perform: delete)
                    }
                    Button("Delete all", action: {
                        self.presetDeleteAlert = true
                    }).alert(
                        "Delete all task",
                        isPresented: $presetDeleteAlert
                    ) {
                        Button("Delete", role: .destructive, action: self.cleanTodos)
                    } message: {
                        Text("Are you sure you want to delete all?")
                    }
                    
                }
            }.navigationTitle(todos.isEmpty ? "" : "List").toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.showAddTodoView = true
                    }) {
                        Image(systemName: "plus").foregroundStyle(Color.blue)
                    }
                }
                
            }.sheet(isPresented: $showAddTodoView, content: {
                AddTodo().environment(\.managedObjectContext, self.viewContext)
            })
        }
    }
    
    func togleTodo(todo: Todo) {
        todo.done.toggle()
        try! self.viewContext.save()
    }
    
    func delete(todo elements: IndexSet) {
        for index in elements {
            let elementToDelete = self.todos[index]
            self.viewContext.delete(elementToDelete)
        }
        try! self.viewContext.save()
    }
    
    func cleanTodos() {
        for todo in self.todos {
            self.viewContext.delete(todo)
        }
        try! self.viewContext.save()
    }
}


//private func deleteItems(offsets: IndexSet) {
//    withAnimation {
//        offsets.map { items[$0] }.forEach(viewContext.delete)
//
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
