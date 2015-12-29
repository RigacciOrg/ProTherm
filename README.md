# ProTherm, a programmable thermostat for the Raspberry Pi

http://www.rigacci.org/wiki/doku.php/doc/appunti/hardware/raspberrypi_thermostat

Features a Dallas **DS18B20 temperature sensor**, an **LCD display**, a **push button** and a **relay** to start/stop the heating boiler; everything is running on a **Raspberry Pi** Model B.

Room temperature can be programmed on a weekly basis, time resolution is the minute. You can define several weekly programs and cycle among them pushing a button.

There is a very basic web interface to manage the thermostat remotely, but the preferred way to talk to the thermostat is via **Telegram Messenger**.

## protherm

The Python daemon which polls the temperature sensor and sets the relay status (ON/OFF) accordingly to a temperature program.

## protherm-tbot

The Telegram Bot which send and receive messages to manage the thermostat remotely. It is written in Python using the telepot library.
