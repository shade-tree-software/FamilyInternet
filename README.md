# FamilyInternet

This is a Rails-based web app that enables each family member to have their own daily allotment of Internet minutes.  A simple web page allows each family member to turn his or her Internet access on or off throughout the day and to see how many minutes are remaining.  Time limits can be set differently for each family member, and you can also set up blackout hours during the nighttime when Internet is not allowed.

This app is designed to run on a Linux server that has a WiFi card and two Ethernet jacks, and it requires a companion command line app called IPTHelper which manages the iptables firewall rules.  Note that IPTHelper must have root setuid permissions.  You must set this machine up as a NAT server, and you must configure the WiFi card as a wireless hotspot.
