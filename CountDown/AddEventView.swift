//
//  NewProjectApp.swift
//  NewProject
//
//  Created by Modi Alshammari on 19/06/1444 AH.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @State var title: String = ""
    @State var selectedEventDate = Date()
    @State var selectedEventColor: Color = .blue
    var body: some View {
        Form{
            Section {
                TextField("Title", text: $title)
                
                DatePicker(selection: $selectedEventDate, in: Date.now...) {
                    Text("Select a date")
                        .font(.footnote)
                }
            }
            
            ColorPicker(selection: $selectedEventColor) {
                Text("Select color for your event")
            }
            
            Button {
                let event = Event(context: viewContext)
                event.title = title
                event.date = selectedEventDate
                event.color = UIColor(selectedEventColor).encode()
                do {
                    try viewContext.save()
                    
                } catch {
                    
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                
                Text("Save")
                    .frame(width: 320, height: 30)
                    
                    //.foregroundColor(Color("Tcolor"))
                    //.background(Color("Tcolor"))
                    
            }
           
        }
        
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

extension UIColor {

     class func color(data: Data) -> UIColor? {
          return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
     }

     func encode() -> Data? {
          return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
     }
}

