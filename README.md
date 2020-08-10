# Payment Gateway: Paypal
[Project created with Xcode V11.6] [Deployment Target >= 13.0]

## Documentation
* [Braintree - Guide PayPal](https://developers.braintreepayments.com/guides/paypal/overview/ios/v4)
* [PayPal - Sandbox Merchant](https://www.sandbox.paypal.com/mx/webapps/mpp/merchant). Here you can see the transactions made.

## Prerequisites
1. Register PayPal Account. [Register you here](https://www.paypal.com/mx/webapps/mpp/account-selection)
1. PayPal Developer Sandbox Account. [Log in you here](https://developer.paypal.com/classic-home/) with your credentials of PayPal Account
1. Register Braintree Sandbox Account. [Register you here](https://www.braintreepayments.com/sandbox). Read **[Getting Started](#getting-started)**: Step 2.i.

## Getting Started
1. PayPal Developer Sandbox Account: [Link](https://developer.paypal.com/developer/accounts/)     
    1. Credentials     
        Log in in to your PayPal Developer Sandbox Account. In left panel, select the option, **Accounts**. In the section **Sandbox Accounts**, you be able to see two accounts by *default*.     
        Now, click on the three dots options button of the *Business Account*, and select **View/Edit Account**. Copy the Email ID and System Generated Password.
    2. My Apps and Credentials     
        In the same panel, select the option **My Apps & Credentials**. In the section, **REST API apps**, you can create a new app or use *Default Application*.     
        Now, click on *Default Applications* (or your new app), and copy values Sandbox account, Client ID, and Secret (click on Show button to show secret key).
2. Braintree Sandox Account: [Link](https://www.braintreepayments.com/sandbox)     
    1. Braintree Sandbox Account     
        When you click on **Log in**, is possible you see a pop modal. Click on Log in that is in the bottom (Looking for Sandbox? Log in or sign up).     
        To log in, you can also do it with PayPal credentials; these credentials are the ones copied in the step 1.i. If you want to create an account different, do it.
    2. Tokenization Keys     
        Now, click on the *Gear* icon in the top right corner, then click on API. In the section **Tokenization Keys**, click on *+ Generate New Tokenization Key*, and copy the key generated.
    3. Enable PayPal     
        In the panel that is in the top, click on *Processing*. In the section, **Payment Methods**, in the option *PayPal*, click on *Link Sandbox* (below the switch button).     
        So, paste the values copied in the step 1.ii, then Check checkbox *Manage PayPal Disputes in the Braintree Control Panel*. To finish, click on *Link PayPal Sandbox*.
3. Install CocoaPods and Pods     
    * If you don't have cocoapods installed:     
        ```
        % sudo gem install cocoapods
        ```     
    1. Create Podfile within of your project     
        ```
        % pod init
        ```     
    2. Add Pods in your Podfile file created     
        `pod 'Braintree'`     
        `pod 'BraintreeDropIn'`     
        `pod 'Braintree/PayPal'`     
        `pod 'Braintree/DataCollector'`     
    3. Install Pods     
    ```
    % pod install
    ```
4. URL Types and Schemes     
    1. To open the project, search for the file with the extension **.xcworkspace**. *Example, PaymentPayPal.xcworkspace*
    1. Click on your project in the Project  Navigator. *Example, PaymentPayPal*
    1. Click on the target. *Example, PaymentPayPal*
    1. Click *Info* Section and then in URL Types Section, press + and add your scheme:     
        Identifier: Your bundle ID. *Example, com.Thaliees.PaymentPayPal*     
        URL Schemes: How will your app be identified from another application. This value must start with your app's bundleID and be devicated to Braintree app switch returns. *Example, com.Thaliees.PaymentPayPal.payments*     
    * Try opening Mobile Safari (in your device (simulator o real)) and type your_url_scheme://something *Example: com.Thaliees.PaymentPayPal.payments://testing*

## Project Base.
To implement PayPal you need implement Braintree. The following points guide how to implement Braintree within our project. For read more about the implementation, see **[Documentation](#documentation)**

1. AppDelegate     
    In `application:didFinishLauchingWithOptions:` call `BTAppSwitch.setReturnURLScheme("value")`, where *value* is your url scheme
2. Handle app switch     
    * If your app use `UISceneDelegate`:     
        In `scene:openURLContexts` call `BTAppSwitch.handleOpenURLContext()`. Remember, the value to compare is your url scheme
    * If you app don't use `UISceneDelegate`:     
        In `application:openURL:options` call `BTAppSwitch.handleOpen(url, options: options)`. Remember, the value to compare is your url scheme
3. APIPayPalManager File     
    This file handles the calls to API.
4. Flows     
    Braintree offers two options when accepting PayPal payments: **Vault** and **Checkout**.     
    - Vault: Will save the payment method for later reference.
    - Checkout: Is for one-time payments when you don't want to save the payment method. For this project, we use this flow.
5. Delegates     
    In your ViewController where you make the transaction, you need implement the `BTAppSwitchDelegate` and `BTViewControllerPresentingDelegate`.
6. Transaction     
    Client-side, **only** accesses the account from which the payment will be taken, Server-side will make the transaction. To see the server implementation [click here](https://github.com/thaliees/nodejs-PaymentGateway)
7. Testing     
    - To test payment with PayPal Accounts:     
        1. Log in in to your PayPal Developer Sandbox Account. In left panel, select the option, **Accounts**. In the section **Sandbox Accounts**, you be able to see two accounts by *default*. You can test with *Personal Account* or *Create account*     
        2. Click on the three dots options button of the account, and select **View/Edit Account**. Copy the Email ID and System Generated Password.
        3. When run the application (whether if you use `startCheckout()` or `showDropIn()`), enter the credentials copied
    - To test card credit/debit:     
        1. In [this link](https://developers.braintreepayments.com/reference/general/testing/node), you can find **transaction amounts**, **credit card numbers**, **valid card numbers**, etc.
        2. You should use `showDropIn()` function to test this option
        2. When run the application, and select Credit or Debit Card, copy the data you want to test

## License
This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.