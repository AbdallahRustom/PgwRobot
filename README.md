# Functional Test

## Overview

The Functional Test suite is designed to thoroughly evaluate the Packet Data Network Gateway (PGW) functionality within a telecommunications network environment. It simulates the process of sending GTP messages to the PGW, verifying its response, and acting as a Diameter peer to receive Diameter messages.

The tests are implemented using the Robot Framework, leveraging Python functions to automate test scenarios across various interfaces and bearer types. The following tests are currently covered:

    1) Sending CSR to PGW for Default Bearer (S5c and Gx Interfaces)
        Verifies the functionality of default bearer establishment between the User Equipment (UE) and PGW.

    2) Sending CSR to PGW for Dedicated Bearer (IMS) (S5c and Gx Interfaces)
        Validates the setup of dedicated bearers, particularly for IP Multimedia Subsystem (IMS) services.

    3) Sending CSR to PGW for S6b and S2b Interfaces
        Tests the interactions between the PGW and external entities via the S6b and S2b interfaces.
    
    4) Testing Modify Bearer Response
        Ensures that the PGW handles Modify Bearer requests correctly and responds appropriately.
    
    5)Testing Create Bearer Request
        Validates the PGW's ability to establish new bearers based on incoming requests.
    
    6)Testing Delete Bearer Request
        Verifies the PGW's capability to terminate existing bearers upon receiving delete requests.
    
    7)Testing Delete Session Request
        Ensures proper handling of session termination requests by the PGW.
    
    8)Testing and validate dataplane:
        Ensures proper handling of gtp traffic by sending a ICMP encapsulated GTP packet to PGWU

## Folders in the Repository

CNFS: it contain the Dockerfile and initialization to build Container

Deployments: it contain Yaml file to be deployed in the stagging enviroment

Src: it contain the source code of python functions and robotframework 

# Getting Started

## Prerequisites

    1) apt install python3-pip
    2) pip install scapy redis jinja2 pyyaml robotframework

## Instaltion 

To execute the Functional Test suite, follow these steps:

    1) Clone the GitLab repository containing the test scripts. 
        git clone https://gitlab.tech.orange/win/oinis/olb-2g6/functional-test.git

    2) Install the necessary dependencies

    3) Configure the test environment parameters

    4) Run the desired test suites or individual test cases using the Robot Framework command-line interface.
        cd pgwrobot
        robot pgw.robot (This will run all test cases)
        robot --include First pgw.robot (This will only run the First Test Case) 

    5) Review the test results and logs to identify any issues or failures.

## Support 
For assistance or inquiries regarding the Functional Test suite, please contact [Abdallah.r.waly@orange.com].
