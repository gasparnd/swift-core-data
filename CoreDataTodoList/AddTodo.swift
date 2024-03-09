//
//  AddTodo.swift
//  CoreDataTodoList
//
//  Created by Gaspar Dolcemascolo on 09/03/2024.
//

import SwiftUI

struct AddTodo: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var title = String()
    var body: some View {
        NavigationStack {
            Form {
                TextField("To Do", text: $title).submitLabel(.done).onSubmit {
                    if !self.title.isEmpty {
                        self.addTodo()
                    }
                }
                Button("Add", action: self.addTodo).disabled(self.title.isEmpty).buttonStyle(.borderedProminent)
            }.navigationTitle("Add task")
        }
    }
    
    func addTodo() {
        let add = Todo(context: viewContext)
        add.id = UUID()
        add.title = self.title
        add.date = Date()
        add.done = false
        try! viewContext.save()
        dismiss()
    }
}

#Preview {
    AddTodo()
}
