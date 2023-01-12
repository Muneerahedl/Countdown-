//
//  NewProjectApp.swift
//  NewProject
//
//  Created by modi on 19/06/1444 AH.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let title:LocalizedStringKey = "Countdown"
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)])
    private var events: FetchedResults<Event>
    @State var isShowingAddEventView: Bool = false
    var body: some View{
        NavigationView{
            List{
                ForEach(events, id:\.self) { event in
                    Group{
                        if let dateColor = event.color {
                            HStack{
                               // Image("Image")
                                Image(systemName: "arrow.down.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    //.foregroundColor(.white)
                                    //.foregroundColor(.black)
                                    .foregroundColor(Color(.color(data: dateColor)!))
                                Spacer()
                                if let date = event.date {
                                    VStack(alignment: .leading){
                                        Text(event.title ?? "")
                                            .fontWeight(.bold)
                                           //.foregroundColor(Color(.color(data: dateColor)!))
                                        Text(date.convertDate(formattedString: .formattedType1))
                                    }
                                    Spacer()
                                    VStack{
                                        Text(date.convertToTimeWill(style: .full))
                                        Text("left")
                                    }
                                }
                            }//.listRowBackground(Color(.color(data: dateColor)!))
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewContext.delete(event)
                            do {
                                try viewContext.save()
                            } catch {
                                
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .navigationTitle(title)
            //.background((Color("Tcolor")))
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        //.foregroundColor(Color("Tcolor"))
                       // .foregroundColor(.white)
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddEventView.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                          // .foregroundColor(Color("Tcolor"))
                           .accessibility(label: Text("Add new countdown"))
                           
                    }

                }
            }
        }.sheet(isPresented: $isShowingAddEventView) {
            AddEventView()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext,
                                   PersistenceController.shared.container.viewContext)
            .preferredColorScheme(.dark)
    }
}



extension Date {
    /// To convert a date to specific type
    func convertDate(formattedString: DateFormattedType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formattedString.rawValue
        return formatter.string(from: self)
    }
    /// To print 1s ago , 4d ago, 1month ago
    func convertToTimeAgo(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = style
        let now = Date()
        return formatter.string(from: self, to: now) ?? ""
    }
    
    func convertToTimeWill(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = style
        let now = Date()
        return formatter.string(from: now, to: self) ?? ""
    }
    
    func interval(ofComponent comp: Calendar.Component, from date: Date) -> Float {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0.0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0.0 }
        return Float(start - end)
    }
    
}

enum DateFormattedType: String, CaseIterable {
    /// Date sample  Sunday, Sep 6, 2020
    case formattedType1 = "EEEE, MMM d, yyyy"
    /// Date sample  09/24/2020
    case formattedType2 = "MM/dd/yyyy"
    /// Date sample  09-06-2020 02:45 AM
    case formattedType3 = "MM-dd-yyyy h:mm a"
    /// Date sample  Sep 6, 2:45 AM
    case formattedType4 = "MMM d, h:mm a"
    /// Date sample  02:45:07.397
    case formattedType5 = "HH:mm:ss.SSS"
    /// Date sample  02:45:07.397
    case formattedType6 = "dd.MM.yy"
    /// Date sample  Sep 6, 2020
    case formattedType7 = "MMM d, yyyy"
    /// Time sample  24/05/2020 ● 9:24:22 PM
    case formattedType8 = "dd/MM/yyyy ● h:mm:ss a"
    /// Time sample  Fri23/Oct/2020
    case formattedType9 = "E d/MMM/yyy"
    /// Thu, 22 Oct 2020 5:56:22 pm
    case formattedType10 = "E, d MMM yyyy h:mm:ss a"
    /// Date sample for Month only JUNE
    case formattedType11 = "MMMM"
    /// Date sample for Day in Number only 04
    case formattedType12 = "dd"
    /// to get seconds only
    case formattedType13 = "ss"
    /// time only 9:24:22 PM
    case timeOnly = "h:mm a"
    /// Date Sample Sun
    case dayOnly = "E"
}

