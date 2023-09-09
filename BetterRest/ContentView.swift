//
//  ContentView.swift
//  BetterRest
//
//  Created by Rishi Singh on 09/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepValue = 8.0
    @State private var sleepDate = Date.now
    var body: some View {
        VStack {
            Stepper("\(sleepValue.formatted()) hours", value: $sleepValue, in: 4...12, step: 0.25)
            DatePicker("Pick a date", selection: $sleepDate, in: Date.now...)
            Text(Date.now, format: .dateTime.day().month().year())
            Text(Date.now.formatted(date: .long, time: .shortened))
        }
        .padding()
    }
    
    func dateExample() {
        let component = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        let hour = component.hour ?? 0
        let minute = component.minute ?? 0
         
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
