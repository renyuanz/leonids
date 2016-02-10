---
layout: post
title: "Accepting Payments on Android with Paystack"
date: 2016-02-09 05:05:30
description: How to accept and process payments on Android using Paystack
permalink: /posts/accepting-payments-android-with-paystack
tags: [android, payments, paystack, tutorial]
excerpt: "Brief tutorial on how to setup and use Paystack on Android "
twitter_card_image: /img/paystack-logo.png
comments: true
---
<p align="center">
	<img src="/img/paystack-logo.png">
</p>

If you’ve been looking around Payments in Nigeria these days ([here](http://radar.techcabal.com/t/which-nigerian-online-payment-startup-wins-your-love/2772) and [here](https://techpoint.ng/2016/01/18/theres-no-market-yet-for-stripe-in-nigeria/)),
then you probably have heard or at least seen the name [Paystack](https://paystack.com).
They recently announced that they have gone [live](http://radar.techcabal.com/t/paystack-is-live/4161 ) .


One thing that is great about their platform, is that it is very developer friendly.
They have a quite easy to use developer docs and a very well documented android SDK. (See [here](https://github.com/PaystackHQ/paystack-android)).


[Many developers](https://developers.paystack.co/docs/libraries-and-plugins) have also contributed (and still contributing) their own wrappers and plugins to the platform.

This is a technical post demonstrating how to use their Android SDK to accept payments within your apps.

##First things first.
First thing is to go to [https://paystack.com](https://paystack.com) to get a free account.
When you’re in, navigate to the settings page and select Developer/API tab, you’ll see a screen that looks like this:

<p align="center">
	<img src="/img/paystack-dashboard.png">
</p>

##Now that we’re in
Things to note here are:

1. By default, you’re in a test mode, and you have an option to go live. This test mode is specifically good, for devs while you’re still working on your project.
2. There are two sets of keys, test keys and live keys. The test keys work well for testing and debugging and the live keys...oh..well..are what you use..when you’re going live.
3. Each set of key contains a public key and a secret key. The public key is that you can put on your clients, and apps; the secret key is meant for your eyes only and should be guarded with your life.

##How does this even work?
So the way I understand Paystack to work is very easy, and is as shown below:

<p align="center">
	<img src="/img/paystack-how-it-works.png">
</p>

1. Client requests for a token from Paystack server
2. Paystack server returns the token to the client
3. Client sends token to your server, to charge
4. Your Server hits Paystack to charge the token
5. Paystack returns the response of the ‘charging’ success or otherwise
6. Your server takes that and processes a response to be sent to the client.

This means that you need a client (mobile app or web app) to accept the token as well as a server to charge the token.

##Setting up on my Android Studio
Ok, so we know how to get around on the website, back to our IDE.

1. First step is to add the library to your app’s build.gradle

    `compile 'co.paystack.android:paystack:1.1.0'`

2. Next thing is to add the internet permission to your app’s AndroidManifest.xml, well, because we need to use the internet.

    `<uses-permission android:name="android.permission.INTERNET" />`

3. After adding this, assuming you have your UI for accepting the card details looking like this, in the onCreate of our activity or fragment, we initialize the SDK. Using this:

    `PaystackSdk.initialize(this)` for an activity, or

    `PaystackSdk.intialize(getActivity())` if you’re in a fragment.

4.  Now, we need to create a token, and luckily, Paystack’s got us, we simply use:

    `PaystackSdk.createToken` to create a token which will be sent to our server.

    {% highlight java %}

    private void createToken(String cardNumber, int expiryMonth, int expiryYear, String cvv {
        Card card = new Card.Builder(number, expiryMonth, expiryYear, cvv).build();

        //TODO show progress
        PaystackSdk.createToken(card, new Paystack.TokenCallback() {
              @Override
              public void onCreate(Token token) {
                  if(token != null) {
                      //TODO dismiss progress

                      //send the token to your server for charging
                  }
              }

              @Override
              public void onError(Exception error) {
                  //dismiss progress, show error to the user
              }
          });
      }

    {% endhighlight %}

It is here you now send the token to a server. Luckily, there are some server side wrappers already developed to make it easy for you.

For a full example app, you can check out the full source code of a sample application [here](https://github.com/segunfamisa/PaystackSample)


Check out [https://developers.paystack.co/](https://developers.paystack.co/) for more details on how to implement on the server side.

Hopefully, one of these days, I'll find some time to use the Node.js wrapper to implement a sample server side for accepting payments.

If you enjoyed this or thought it was useful, please show some love, drop comments and share. Thanks :)
