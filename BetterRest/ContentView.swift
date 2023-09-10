//
//  ContentView.swift
//  BetterRest
//
//  Created by Rishi Singh on 09/09/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffieAmount = 1
    
    @State private var alertTilte = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static private var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    Text("When do you want to wakeup?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(coffieAmount == 1 ? "1 Cup" : "\(coffieAmount) Cups", value: $coffieAmount, in: 1...20)
                }
            }
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTilte, isPresented: $showingAlert) {
                Button("Ok") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 3600
            let minutes = (components.minute ?? 0) * 60
            let wakeupSeconds = Double(hour + minutes)
            
            let prediction = try model.prediction(wake: wakeupSeconds, estimatedSleep: sleepAmount, coffee: Double(coffieAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTilte = "Your ideal bedtime is..."
            alertMessage = "\(sleepTime.formatted(date: .omitted, time: .shortened))"
//            More code here
        } catch {
            alertTilte = "Error"
            alertMessage = "Sorry there was a problem calculating your bedtime."
//            Something wend wrong
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
