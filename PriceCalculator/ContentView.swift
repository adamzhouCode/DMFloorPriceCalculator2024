import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: FloorCalculator(type: .spc)) {
                    CalculatorButton(title: "SPC Floor Calculator")
                }
                .padding()

                NavigationLink(destination: FloorCalculator(type: .waterproofLaminate)) {
                    CalculatorButton(title: "Waterproof Laminate Calculator")
                }
                .padding()

                NavigationLink(destination: FloorCalculator(type: .superWaterproofLaminate)) {
                    CalculatorButton(title: "Super Waterproof Laminate Calculator")
                }
                .padding()
                NavigationLink(destination: FloorCalculator(type: .mgo)) {
                    CalculatorButton(title: "MGO Calculator")
                }
                .padding()
            }
            .navigationTitle("Floor Calculators")
        }
    }
}

struct FloorCalculator: View {
    let type: FloorType

    @State private var priceOutOfStorage = ""
    @State private var numberOfSquareMeters = ""
    @State private var usdToRMB = "7.1"
    @State private var patentFee = ""
    @State private var antiSoundPadFee = "0"
    @State private var rmbResultPerSquareMeter = ""
    @State private var rmbResultPerSquareFeet = ""
    @State private var usdResultPerSquareMeter = ""
    @State private var usdResultPerSquareFeet = ""

    var body: some View {
            ScrollView {
                VStack(spacing:3) {
                    // Section 1: USD to RMB Conversion
                    Section(header: Text("USD to RMB Exchange rate")) {
                        TextField("", text: $usdToRMB)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }

                    // Section 2: Price Calculation
                    Section(header: Text("Enter Price and Details")) {
                        Text("Enter the RMB price out of storage:")
                        TextField("", text: $priceOutOfStorage)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)

                        Text("Enter how much square meter a container can hold:")
                        TextField("", text: $numberOfSquareMeters)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Text("Enter the RMB how much per square meter for anti sound pad:")
                        TextField("", text: $antiSoundPadFee)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)

                        Text("Enter how much (USD) patent fee per square meter:")
                        TextField("", text: $patentFee)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }

                    // Section 3: Calculate Button and Results
                    Section {
                        Button(action: {
                            calculatePrice()
                        }) {
                            Text("Get Price")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Text("USD Per Square Meter: \(usdResultPerSquareMeter)")
                            .padding()
                            .font(.headline)
                        Text("USD Per Square Feet: \(usdResultPerSquareFeet)")
                            .padding()
                            .font(.headline)
                        Text("RMB Per Square Meter: \(rmbResultPerSquareMeter)")
                            .padding()
                            .font(.headline)
                        Text("RMB Per Square Feet: \(rmbResultPerSquareFeet)")
                            .padding()
                            .font(.headline)
                        
                    }
                }
                .padding()
                .navigationTitle("\(type.rawValue) Calculator")
                
                
            }
        }

    private func calculatePrice() {
        if let price = Double(priceOutOfStorage), 
            let numberOfSquareMeters = Double(numberOfSquareMeters),
            let rate = Double(usdToRMB),
            let patentFee = Double(patentFee),
            let antiSoundPadFee = Double(antiSoundPadFee)
             {
            // (出厂价+港杂)/1.1 退税 + 专利费
            let rmbPricePerSquareMeter = (price + roundUpToTwoDecimal(5000/numberOfSquareMeters)+antiSoundPadFee)/1.1 + patentFee*rate
            
            let rmbPricePerSquareFeet = roundUpToTwoDecimal(rmbPricePerSquareMeter / 10.76)
            
            let usdPricePerSquareMeter = roundUpToTwoDecimal(rmbPricePerSquareMeter/rate)
            
            let usdPricePerSquareFeet = roundUpToTwoDecimal(usdPricePerSquareMeter/10.76)
            
            
            rmbResultPerSquareFeet = String(format: "Price: ¥%.2f", rmbPricePerSquareFeet)
            rmbResultPerSquareMeter = String(format: "Price: ¥%.2f", rmbPricePerSquareMeter)
            usdResultPerSquareMeter = String(format: "Price: $%.2f", usdPricePerSquareMeter)
            usdResultPerSquareFeet = String(format: "Price: $%.2f", usdPricePerSquareFeet)
            
        } else {
            rmbResultPerSquareMeter = "Invalid Input"
        }
    }
    
    // 保留两位小数
    func roundUpToTwoDecimal(_ number: Double) -> Double {
        let roundedNumber = ceil(number * 100) / 100
        return roundedNumber
    }
}

enum FloorType: String {
    case spc = "SPC"
    case waterproofLaminate = "Waterproof Laminate"
    case superWaterproofLaminate = "Super Waterproof Laminate"
    case mgo = "MGO"
}

struct CalculatorButton: View {
    var title: String

    var body: some View {
        Text(title)
            .frame(width: 250, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
