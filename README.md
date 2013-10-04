# Ruby Hanvon Client Library

This is a ruby client that communicates with Hanvon Time & Attendance devices over the network.

Hanvon provides an SDK consisting only  of a file named HwDevComm.dll. There is no official Linux support. Hence, I decided to reverse engineer the protocol. When used without a commukey / password, you can easily communicate with the device via a TCP socket and send the commands in plain text. However, when a key is used, messages sent and received are encrypted.

This is not official code from Hanvon. This is tested on the F710, but should work for the other models.

For more info on Hanvon devices, visit:

http://www.hanvon.com/en/products/FaceID/products/index.html

SDK documentation with list of functions is included in doc/

## Installation

Add this line to your application's Gemfile:

    gem 'hanvon'
