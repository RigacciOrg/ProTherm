# ProTherm, a programmable thermostat for the Raspberry Pi

http://www.rigacci.org/wiki/doku.php/doc/appunti/hardware/raspberrypi_thermostat

This is a do-it-yourself project to make a **programmable thermostat** with the **Raspberry Pi**, a credit-card sized computer costing about 35 €. I was frustrated by a low-cost thermostat which has only one daily program with just two temperatures. Time accuracy was of a quarter of an hour and temperature accuracy above one Celsius degree.

So I embarked on this project, whose main features are:

* Programmable with the **accuracy of the minute** and **tenths of a degree**.
* Can keep **several weekly programs**, plus MANUAL OFF and MANUAL ON modes.
* Show current status via an **LCD**.
* Just one **push button** to cycle through all the programs.
* Talks with the boiler with a **ON/OFF relay** (which controls the burner status).
* Remote operation and alerting messages via **Telegram Messenger chat**.
* Remote operation using a **web page**.
* Extensive graphing capabilities via **SNMP**.

This is the list of the hardware required, with their cost:

* **Raspberry Pi** model B with power supply (44 €)
* Dallas **DS18B20** temperature sensor (2 €)
* **Relay board** with two realys, but used just one (3.50 €)
* **Push button** (1 €)
* **LCD display** (Nokia 5110-3310) (5 €)
* Edimax **WiFi nano USB** adapter (10 €)

At the total of 65.50 € you must add a suitable case.

You can define several weekly programs and cycle among them pushing a button. There is a very basic web interface to manage the thermostat remotely, but the preferred way to talk to the thermostat is via Telegram Messenger chat.

## protherm

The Python daemon which polls the temperature sensor and sets the relay status (ON/OFF) accordingly to a temperature program.

## protherm-tbot

The Telegram Bot which send and receive messages to manage the thermostat remotely. It is written in Python using the telepot library.
