//
//  ViewController.swift
//  PaymentPayPal
//
//  Created by Thaliees on 8/5/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn

class ViewController: UIViewController, BTAppSwitchDelegate, BTViewControllerPresentingDelegate {
    
    // This value is your Tokenization Keys generated. Read README.md: Getting Started 2.ii
    private let tokenizationBraintree = "sandbox_rz372q9p_g75p6ygbfcmzr8s5"
    private var productList:[Item] = [Item]()
    private var braintreeClient:BTAPIClient!
    
    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let product = Item(name: "Product", productCode: "54200283", kind: "debit", descrip: "Example",
                           quantity: 1, unitAmount: 0.1, totalAmount: 0.1, taxAmount: 0, discountAmount: 0)
        // As we can handle several products in a single transaction, we add this product to our product list
        productList.append(product)
        indicator.stopAnimating()
    }

    @IBAction func confirmPayment(_ sender: UIButton) {
        // Initialize BTAPIClient
        braintreeClient = BTAPIClient(authorization: tokenizationBraintree)!
        
        // If you don't want to show dropIn, uncomment the following line and comment showDropIn()
        //startCheckout()
        showDropIn()
    }
    
    private func showAlertError(message: String) {
        self.indicator.stopAnimating()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showAlert(msg: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let margin:CGFloat = 10.0
        let customView = UIView(frame: CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: 150))
        customView.backgroundColor = .clear
        
        let check = UIImageView(frame: CGRect(x: 95, y: 0, width: 72, height: 72))
        check.image = UIImage(named: "check_circle")
        customView.addSubview(check)
        
        let title = UILabel(frame: CGRect(x: 30, y: 80, width: 200, height: 60))
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.text = "Thanks!"
        title.numberOfLines = 2
        title.textAlignment = .center
        customView.addSubview(title)
        
        let message = UILabel(frame: CGRect(x: 5, y: 140, width: 240, height: 60))
        message.font = UIFont.systemFont(ofSize: 16)
        message.text = msg
        message.numberOfLines = 0
        message.textAlignment = .center
        customView.addSubview(message)
        
        alert.view.addSubview(customView)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 260)
        alert.view.addConstraint(height)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func calculateTotal() -> Double {
        var total:Double = 0.0
        for item in productList {
            total += item.totalAmount
        }
        
        return total
    }
    
    private func calculateTax() -> Double {
        var tax:Double = 0.0
        for item in productList {
            tax += item.taxAmount
        }
        
        return tax
    }
    
    private func calculateDiscount() -> Double {
        var discount:Double = 0.0
        for item in productList {
            discount += item.discountAmount
        }
        
        return discount
    }
    
    private func getDeviceData(nonce: String?, total: Double, shippingAddress: Address?, billingAddress: Address?, paymentOption: BTUIKPaymentOptionType) {
        guard let nonce = nonce else {
            showAlertError(message: "No nonce")
            return
        }
        
        let taxt = calculateTax()
        let discount = calculateDiscount()
        
        let dataCollector = BTDataCollector(apiClient: braintreeClient)
        dataCollector.collectDeviceData { (deviceData) in
            let info = CreateTransactionModel(paymentMethodNonce: nonce, deviceData: deviceData,
                                            totalAmount: total, taxAmount: taxt, discountAmount: discount, shippingAmount: 0,
                                            currency: "USD", shipping: shippingAddress, billing: billingAddress, items: self.productList)
            switch paymentOption {
                case .payPal:
                    self.transactionPayPal(info: info)
                default:
                    self.transaction(info: info)
            }
        }
    }
    
    // MARK: - Checkout with PayPal
    private func startCheckout() {
        indicator.startAnimating()
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self
        
        let total = calculateTotal()
        // Specify the transaction amount here
        let request = BTPayPalRequest(amount: String(total))
        request.currencyCode = "USD" // This is optional
        
        // Realize the connection with PayPal
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            guard let tokenized = tokenizedPayPalAccount else {
                if let error = error { self.showAlertError(message: error.localizedDescription) }
                return
            }
            // Get a nonce, this value will be sent our API (Server-side)
            let nonce = tokenized.nonce
            
            // Access additional information
            var shippingAddress: Address?
            var billingAddress: Address?
            self.email.text = tokenized.email
            self.name.text = tokenized.firstName
            self.lastName.text = tokenized.lastName
            if let billing = tokenized.billingAddress, let address = billing.streetAddress, let city = billing.locality, let postal = billing.postalCode {
                self.address.text = address
                self.city.text = city
                self.postalCode.text = postal
                
                let name = tokenized.firstName
                let lastName = tokenized.lastName
                billingAddress = Address(id: nil, name: name, lastName: lastName, address: address, postalCode: postal, city: city)
            }
            else if let shipping = tokenized.shippingAddress, let address = shipping.streetAddress, let city = shipping.locality, let postal = shipping.postalCode {
                self.address.text = address
                self.city.text = city
                self.postalCode.text = postal
                
                let name = tokenized.firstName
                let lastName = tokenized.lastName
                shippingAddress = Address(id: nil, name: name, lastName: lastName, address: address, postalCode: postal, city: city)
            }
            
            self.viewData.isHidden = false
            self.getDeviceData(nonce: nonce, total: total, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOption: .payPal)
        }
    }
    
    private func showDropIn() {
        let total = calculateTotal()
        let paypal = BTPayPalRequest(amount: String(total))
        paypal.currencyCode = "USD"
        
        let request =  BTDropInRequest()
        request.payPalRequest = paypal
        let dropIn = BTDropInController(authorization: tokenizationBraintree, request: request) { (controller, result, error) in
            DispatchQueue.main.async {
                if let error = error { self.showAlertError(message: error.localizedDescription) }
                else if let result = result {
                    if (!result.isCancelled) {
                        self.indicator.startAnimating()
                        self.getDeviceData(nonce: result.paymentMethod?.nonce, total: total, shippingAddress: nil, billingAddress: nil, paymentOption: result.paymentOptionType)
                    }
                }
            }
            
            controller.dismiss(animated: true, completion: nil)
        }
        
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    private func transactionPayPal(info: CreateTransactionModel) {
        DispatchQueue.main.async {
            APIPayPalManager.sharedInstance.createTransactionPayPal(info: info, onSuccess: { (response) in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.showAlert(msg: "TransactionId: \(response.id)")
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.showAlertError(message: error)
                }
            }
        }
    }
    
    private func transaction(info: CreateTransactionModel) {
        DispatchQueue.main.async {
            APIPayPalManager.sharedInstance.createTransaction(info: info, onSuccess: { (response) in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.showAlert(msg: "TransactionId: \(response.id)")
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.showAlertError(message: error)
                }
            }
        }
    }
    
    // MARK: - Braintree Delegates
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

